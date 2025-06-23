# DotFlakes

My personal NixOS + Home Manager + Gnome DM configuration using Flakes.

## Features

- System configuration in `nixos/`
- Home Manager configuration in `home-manager/`
- Managed using Nix Flakes for reproducibility

## Setup

1. Fork or clone this repository
2. Build your hardware configuration `nixos-generate-config`
3. Copy your hardware configuration to `nixos/hardware-configuration.nix`
4. Commit the changes to your repository
5. Build your system configuration `sudo nixos-rebuild switch --flake .#nixos`

Extra step for the wallpaper switcher:

```

git clone git@github.com:cesargomez89/wallpapers.git ~/wallpapers
```


## Structure

```
.
├── flake.nix         - Main flake configuration
├── home-manager/     - User configuration
├── nixos/            - System configuration
└── README.md         - This file
```

## Usage

Desktop UI is being handled by GDM + GNOME Shell for simplicity.

#### Wallpaper switcher

The wallpaper switcher is configured to use the `random-bg` script in `~/.local/bin/`.

To change the wallpaper, run `random-bg` from the command line.
This script reads the wallpapers from `~/wallpapers/`.

You can create your own folder and paste your collection or feel free to use mine from this repo:

```
git clone git@github.com:cesargomez89/wallpapers.git ~/wallpapers
```


#### Favorite apps in dash

| App | Description |
| --- | --- |
| Kitty | Terminal emulator |
| Google Chrome | Web browser |
| Slack | Chat client |
| Dbeaver | Database client |
| Postman | API client |


#### Keybindings

| Keybinding | Action |
| --- | --- |
| `<Super>b` | Toggle Chrome |
| `<Super>e` | Toggle Nautilus |
| `<Super>Return` | Toggle Kitty |
| `<Super>c` | Toggle Slack |


#### Extensions


| Extension | Description |
| --- | --- |
| Open Bar | Adds a bar to the top of the screen |


I only use the [Open Bar](https://extensions.gnome.org/extension/615/open-bar/) extension to add a bar to the top of the screen.
I went with it because it handles theme based on wallpaper and allows many customizations.

#### Pre-installed packages

| Package | Description |
| --- | --- |
| python314 | Python 3.14 |
| go | Go programming language |
| zsh | Z shell |
| kitty | Terminal emulator |
| neovim | Text editor |
| luarocks | Lua package manager |
| starship | Shell prompt |
| eza | Archive manager |
| wget | Download utility |
| btop | Process monitor |
| neofetch | System information |
| google-chrome | Web browser |
| slack | Chat client |
| postman | API client |
| zoom | Video conferencing |
| dbeaver-bin | Database client |
| telegram-desktop | Chat client |
| aider-chat | AI assistant |
| vlc | Video player |

#### Pre-installed fonts

| Font | Description |
| --- | --- |
| Caskaydia Cove | Nerd font |
| Fira Code | Nerd font |
