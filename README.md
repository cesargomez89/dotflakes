# ❄️ DotFlakes

[![NixOS](https://img.shields.io/badge/NixOS-26.05-blue?style=flat-square&logo=nixos)](https://nixos.org)
[![macOS](https://img.shields.io/badge/macOS-Sonoma+-orange?style=flat-square&logo=apple)](https://nix-darwin.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

A premium, reproducible **NixOS + macOS** configuration featuring **Home Manager** with **GNOME** desktop (Linux) and **yabai** tiling WM (macOS), built with modern Nix Flakes.

## 🎯 Philosophy

DotFlakes is designed to be a stable, aesthetic, and highly productive base system. It prioritizes system-level management while keeping the environment visually polished and functionally robust.

## ⚡ Quick Start

Ready to try it? Follow the [Installation Guide](./INSTALL.md) or:

### NixOS
```bash
# 1. Clone this repository
git clone https://github.com/cesargomez89/dotflakes /etc/nixos

# 2. Copy your hardware configuration
cp /etc/nixos.backup/hardware-configuration.nix /etc/nixos/nixos/machines/<your-machine>/

# 3. Update hostname in flake.nix and configuration.nix

# 4. Install
sudo nixos-install --flake /etc/nixos#<your-machine> --no-root-passwd
```

### macOS
```bash
# 1. Clone this repository
git clone https://github.com/cesargomez89/dotflakes ~/dotflakes
cd ~/dotflakes

# 2. Generate hardware config
nix run nix-darwin -- --show-hardware-config > darwin/machines/macbook-pro/hardware-configuration.nix

# 3. Activate the system
nix run nix-darwin -- switch --flake .#macbook-pro
```

## 📋 Prerequisites

### For NixOS
- **NixOS 26.05** or newer
- **Flakes enabled** (`experimental-features = flakes nix-command` in `/etc/nix/nix.conf`)
- **Git** installed
- **UEFI** boot system
- **Secure Boot** (optional): Set up `sbctl` keys for lanzaboote

### For macOS
- macOS Sonoma 14+ (Apple Silicon)
- **Nix** installed ([Determinate Nix Installer](https://determinate.systems/nix-installer/) recommended)
- **Rosetta** installed: `softwareupdate --install-rosetta` (for Homebrew x86_64 emulation)
- **Git** installed

## 🛠️ Technology Stack

### Core System
- **NixOS**: The foundation of the system.
- **Flakes**: For reproducible and versioned configuration.
- **Home Manager**: Declarative user environment management.
- **direnv**: Fast, automatic shell environments.

### Desktop Environment
- **GNOME**: A polished, stable DE with customized extensions.
- **Stylix**: Consistent system-wide theming.

### Shell & Tools
- **Zsh**: Enhanced with **Starship** prompt.
- **Kitty**: Fast, GPU-accelerated terminal.
- **Neovim / Tmux**: Core development tools.
- **Lazygit / Lazydocker / OpenCode**: CLI productivity interfaces.

### Programming Languages
- **Python 3.14**, **Go**, **Ruby**, **Node.js 24** (via pnpm).

---

## 🚀 Machines

This configuration supports both Linux and macOS machines:

| Machine | Description |
|---------|-------------|
| `desktop-amd` | AMD desktop + GNOME |
| `macbook-pro` | Apple Silicon Mac + yabai tiling WM (macOS) |

---

## 🍴 How to Fork & Customize

### 1. Rename the Username

The username `cesar` is hardcoded throughout. To use your own username:

```bash
# Search and replace all occurrences
cd /path/to/dotflakes
grep -rl "cesar" . | xargs sed -i 's/cesar/yourusername/g'
```

Files to check manually:
- `home-manager/home.nix` (user name, home directory)
- `home-manager/gnome.nix` (user paths)
- `flake.nix` (if referenced)

### 2. Add a New Machine

```bash
# Create machine directory
mkdir -p nixos/machines/<your-machine>

# Generate hardware config (on target machine)
sudo nixos-generate-config --show-hardware-config > nixos/machines/<your-machine>/hardware-configuration.nix

# Create configuration.nix:
```

```nix
{ lib, ... }:

{
  imports = [
    ../../base.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  # Your username
  users.users.yourusername = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
```

Add to `flake.nix` under `nixosConfigurations`:
```nix
your-machine = makeNixosConfiguration "your-machine" ./nixos/machines/your-machine/configuration.nix;
```

### 3. Customize Packages

- **System packages**: Edit `nixos/base.nix` → `environment.systemPackages`
- **User packages**: Edit `home-manager/home.nix` → `home.packages`
- **Machine-specific**: Edit `nixos/machines/<machine>/configuration.nix`

---

## ⌨️ Shortcuts

### NixOS (GNOME)
| Key | Action |
| :--- | :--- |
| `<Super> + Return` | Open Terminal (Kitty) |
| `<Super> + B` | Open Browser (Chrome) |
| `<Super> + E` | Open File Manager (Nautilus/Finder) |
| `<Super> + C` | Open Chat (Slack) |
| `<Super> + Y` | Open Music (YouTube Music) |
| `<Super> + R` | Change Wallpaper (Random) |
| `<Super> + Q` | Close Window |
| `<Super> + Backspace` | Log Out |

### macOS (yabai + skhd)
| Key | Action |
| :--- | :--- |
| `<Ctrl> + Return` | Open Terminal (Kitty) |
| `<Ctrl> + B` | Open Browser (Chrome) |
| `<Ctrl> + E` | Open Finder |
| `<Ctrl> + C` | Open Chat (Slack) |
| `<Ctrl> + Q` | Close Window |
| `<Alt> + H/J/K/L` | Focus window (vim-style) |
| `<Alt> + F` | Toggle fullscreen |
| `<Caps Lock>` → `Ctrl` | Karabiner remap |

---

## 🖼️ Features

### Random Wallpaper Switcher
The system includes a custom `random-bg` script that changes your wallpaper from `~/Pictures/Wallpapers/`.
- **Manual change**: Use `<Super> + R`

### GNOME Extensions
- **Open Bar**: Beautifully customized top panel.
- **Tiling Shell**: Optional tiling window management.
- **Blur My Shell**: Elegant blur effects.
- **Vitals**: System monitoring in the panel.

---

## 📂 Project Structure

```
.
├── flake.nix                    # Entry point (supports both NixOS & nix-darwin)
├── INSTALL.md                   # Installation guide
├── README.md                    # This file
├── LICENSE                      # MIT License
├── nixos/                       # Linux (NixOS) system configuration
│   ├── base.nix                 # Shared configuration (networking, services, packages)
│   ├── gnome.nix                # GNOME display manager & desktop settings
│   ├── options.nix              # Custom options (desktopEnv)
│   └── machines/
│       └── desktop-amd/
├── darwin/                      # macOS (nix-darwin) system configuration
│   ├── base.nix                 # macOS system config (packages, nix settings, homebrew)
│   ├── desktop.nix              # Dock, finder, yabai tiling WM, skhd keybindings
│   └── machines/
│       └── macbook-pro/
├── home-manager/                # Shared user-level configuration (both platforms)
│   ├── home.nix                 # Main entry (conditionally imports per platform)
│   ├── apps.nix                 # User packages (cross-platform)
│   ├── themes.nix               # Stylix theming (Catppuccin Mocha)
│   ├── gnome.nix                # GNOME extensions & dconf (NixOS only)
│   ├── random-bg.nix            # Random wallpaper (NixOS + swww)
│   ├── macos.nix                # Karabiner, yabai config, wallpaper (macOS only)
│   └── random-bg.sh             # Wallpaper script (shared logic)
```

---

## 🔧 Troubleshooting

### Flakes not enabled

Add to `/etc/nix/nix.conf`:
```
experimental-features = flakes nix-command
```

### Home Manager not applying

```bash
home-manager switch --flake .
```

### Build fails with permission error

Ensure you're using `sudo` for system-level changes:
```bash
sudo nixos-rebuild switch --flake .#<machine>
```

### Wallpaper script not working

```bash
mkdir -p ~/Pictures/Wallpapers
# Add images to this directory
random-bg  # test manually
```

---

## 🤝 Contributing

This is my personal configuration, but I'm happy to accept suggestions, bug reports, or forks. Feel free to open an issue or a PR!

## 📜 License

MIT License - See [LICENSE](LICENSE) for details.
