# Set colors for ls
set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

# Define terminal type
set -x -g TERM "xterm-256color"

# Setting up Homebrew variables
if test (uname -m) = "arm64"
    set brew_path /opt/homebrew
else
    set brew_path /usr/local
end

$brew_path/bin/brew shellenv | source


# Add GNU utils to PATH
set -x -g PATH (brew --prefix coreutils)/libexec/gnubin $PATH
set -x -g PATH (brew --prefix findutils)/libexec/gnubin $PATH


# Add user bin folder to PATH
set -x -g PATH $HOME/bin $PATH

# Setup FNM
fnm env --use-on-cd | source

# Setup iterm2 shell integration
source ~/.iterm2_shell_integration.fish

# Run setup function
setup