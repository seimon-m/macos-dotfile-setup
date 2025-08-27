# macOS Dotfile Setup

Opinionated macOS setup with **Fish shell**, **Node**, **Git**, and **Brewfile apps**.  
Automates software installation, macOS defaults, shell configuration, and developer tools setup.

---

## Features

- Install and manage apps via **Homebrew** (`Brewfile` included).
- Set **Fish** as your default shell with custom functions and completions.
- Configure **Node.js** via [fnm](https://github.com/Schniz/fnm).
- Apply sensible macOS defaults (dock, finder, key repeat, screenshot folder, etc).
- Preconfigured Git global defaults

---

## Installation

1. Clone the repo:

```bash
git clone https://github.com/<your-username>/macos-dotfile-setup.git
cd macos-dotfile-setup
```


2.	Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

## Fish Shell Setup
- Functions are in functions/ and symlinked to ~/.config/fish/functions.
- Completions are in completions/ and symlinked to ~/.config/fish/completions.

Example function:

```bash
function yd --description 'Start yarn dev'
    yarn dev || yarn start || yarn watch
end
```

Usage:

```bash
yd
```

## Updating
Re-run the setup script after changing configs, functions, or completions:

```bash
./setup.sh
```
