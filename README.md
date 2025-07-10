# DotFlakes

A personal NixOS configuration featuring Home Manager and GNOME, built with flakes for reproducible system management.

## Philosophy

This configuration prioritizes OS-level system management while maintaining a balance between simplicity, visual appeal, and productivity. The focus is on creating a stable, declarative foundation for your desktop environment.

## Architecture

DotFlakes is designed as a system-level configuration manager that pairs seamlessly with [Kiddots](https://github.com/cesargomez89/kiddots) for application-specific dotfiles. This separation allows for:

- **System stability**: Core OS configuration remains consistent
- **Flexibility**: Application configs can evolve independently
- **Maintainability**: Clear separation of concerns

## What's Included

- **NixOS**: Declarative system configuration
- **Home Manager**: User environment management
- **GNOME**: Polished desktop environment with thoughtful customizations
- **Flakes**: Modern, reproducible Nix workflow

## What's Not Included

Terminal emulators, Neovim, tmux, and other frequently-changing application configurations are intentionally excluded. These are better managed through dedicated dotfiles like [Kiddots](https://github.com/cesargomez89/kiddots).

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

Further details in the [INSTALL.md](./INSTALL.md) file.


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

#### Random Wallpaper

The wallpaper switcher is configured to use the `random-bg` script in `~/.local/bin/`.
There are 3 ways to change the wallpaper:

1. It gets replaced on login automatically
2. Click on the random wallpaper icon in the dash
3. Run `~/.local/bin/random-bg` from the command line

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
| Nautilus | File manager |
| YouTube Music | Music player |
| Telegram | Chat client |
| Random Wallpaper | Change wallpaper |


#### Keybindings

| Keybinding | Action |
| --- | --- |
| `<Super>b` | Toggle Chrome |
| `<Super>e` | Toggle Nautilus |
| `<Super>Return` | Toggle Kitty |
| `<Super>c` | Toggle Slack |
| `<Super>r` | Change wallpaper |
| `<Super>y` | Toggle Youtube Music |
| `<Super>q` | Close window |


#### Extensions


| Extension | Description |
| --- | --- |
| Open Bar | Adds a bar to the top of the screen |
| Media Controls | Adds media controls to the top of the screen |
| Vitals | Adds a widget to the top of the screen |
| AppIndicator | Handles tray icons |
| Blur My Shell | Adds blur to multiple places |
| Tiling Shell | Tiling manager |


I use the [Open Bar](https://extensions.gnome.org/extension/6580/open-bar/) extension to add a bar to the top of the screen.
I went with it because it handles theme based on wallpaper and allows many customizations.

#### Pre-installed packages

| Package | Description |
| --- | --- |
| python314 | Python 3.14 |
| go | Go programming language |
| ruby | Ruby programming language |
| fnm | Fast and simple Node.js version manager |
| zsh | Z shell |
| kitty | Terminal emulator |
| neovim | Text editor |
| luarocks | Lua package manager |
| ripgrep | Search tool |
| starship | Shell prompt |
| eza | Archive manager |
| tmux | Terminal multiplexer |
| wget | Download utility |
| btop | Process monitor |
| neofetch | System information |
| cava | System information |
| fum | Player TUI |
| lazygit | Git TUI |
| lazydocker | Docker TUI |
| aider-chat | AI assistant |
| google-chrome | Web browser |
| youtube-music | Music player |
| slack | Chat client |
| postman | API client |
| zoom | Video conferencing |
| dbeaver-bin | Database client |
| telegram-desktop | Chat client |
| vlc | Video player |
| pinta | Image editor |
| gparted | Partition editor |

#### Services

| Service | Description |
| --- | --- |
| zerotierone | ZeroTier networking |

#### Programs

| Program | Description |
| --- | --- |
| git | Version control system |
| zsh | Shell |


#### Pre-installed fonts

| Font | Description |
| --- | --- |
| Caskaydia Cove | Nerd font |
| Fira Code | Nerd font |

## Screenshots

![Screenshot](https://raw.githubusercontent.com/cesargomez89/dotflakes/master/screenshots/1.png)

![Screenshot](https://raw.githubusercontent.com/cesargomez89/dotflakes/master/screenshots/2.png)

![Screenshot](https://raw.githubusercontent.com/cesargomez89/dotflakes/master/screenshots/3.png)

![Screenshot](https://raw.githubusercontent.com/cesargomez89/dotflakes/master/screenshots/4.png)

![Screenshot](https://raw.githubusercontent.com/cesargomez89/dotflakes/master/screenshots/5.png)

## Contributing

This is a personal configuration, but feel free to fork and adapt it to your needs. Pull requests, issues and suggestions are welcome.
