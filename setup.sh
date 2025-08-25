#!/usr/bin/env bash
# Full macOS dev setup with Fish shell, Node, Git, Brewfile apps

set -e

DIR=$(dirname "$0")
cd "$DIR"

info()    { printf "\n\033[1;34m[INFO]\033[0m %s\n" "$1"; }
success() { printf "\n\033[1;32m[SUCCESS]\033[0m %s\n" "$1"; }

###############################################################################
# Homebrew Installation
###############################################################################
info "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

info "Adding Homebrew to PATH..."
UNAME_MACHINE="$(/usr/bin/uname -m)"
if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

###############################################################################
# Brew packages and casks
###############################################################################
info "Installing Brew packages from Brewfile..."
brew update
brew upgrade
brew bundle --file="$DIR/Brewfile"
brew cleanup

###############################################################################
# macOS defaults
###############################################################################

info "Applying macOS defaults..."
osascript -e 'tell application "System Preferences" to quit'
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# General UI/UX
sudo scutil --set ComputerName "simon-mbp"
sudo scutil --set HostName "simon"
sudo scutil --set LocalHostName "simon"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "simon"
sudo nvram SystemAudioVolume=" "
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Keyboard & Trackpad
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 12
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
sudo chflags nohidden /Volumes

# Dock
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock mineffect -string "genie"
defaults write com.apple.dock minimize-to-application -bool false
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false

# Screenshots

SCREENSHOT_DIR="$HOME/Screenshots"

info "Creating screenshots folder at $SCREENSHOT_DIR..."
mkdir -p "$SCREENSHOT_DIR"

info "Setting macOS to save screenshots in $SCREENSHOT_DIR..."
defaults write com.apple.screencapture location "$SCREENSHOT_DIR"


defaults write com.apple.screencapture type -string "png"

# Security
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true
defaults write com.apple.appstore ShowDebugMenu -bool true
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Git global defaults
###############################################################################

git config --global user.name "Simon"
git config --global user.email "simimueller@hotmail.com"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global pull.rebase true
git config --global credential.helper osxkeychain
git config --global format.pretty "%C(yellow)%h%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"
git config --global push.default simple

###############################################################################
# Node with fnm
###############################################################################
info "Setting up Node with fnm..."
if ! command -v fnm >/dev/null 2>&1; then
    echo "fnm not installed via Homebrew. Exiting."
    exit 1
fi

# Install latest LTS Node
fnm install --lts
fnm default lts
fnm use lts

###############################################################################
# Fish shell setup
###############################################################################
info "Setting up Fish shell..."
FISH_DEST="$HOME/.config/fish"
mkdir -p "$FISH_DEST/functions" "$FISH_DEST/completions"

# Symlink main config.fish
ln -sf "$DIR/config.fish" "$FISH_DEST/config.fish"

# Symlink functions
if [ -d "$DIR/functions" ]; then
    find "$DIR/functions" -type f -name "*.fish" | while read fn; do
        ln -sf "$fn" "$FISH_DEST/functions/$(basename "$fn")"
    done
fi

# Symlink completions
if [ -d "$DIR/completions" ]; then
    find "$DIR/completions" -type f -name "*.fish" | while read fn; do
        ln -sf "$fn" "$FISH_DEST/completions/$(basename "$fn")"
    done
fi

# Add Fish to /etc/shells and set as default
FISH_BIN="$(which fish)"
if ! grep -Fxq "$FISH_BIN" /etc/shells; then
    echo "$FISH_BIN" | sudo tee -a /etc/shells
fi
chsh -s "$FISH_BIN"

# iTerm2 integration
curl -sL https://iterm2.com/shell_integration/fish -o ~/.iterm2_shell_integration.fish

###############################################################################
# Restart affected apps
###############################################################################
for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &> /dev/null || true
done

success "Mac setup complete! Log out and log back in to apply all changes."
