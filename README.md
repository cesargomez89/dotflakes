# ❄️ DotFlakes

[![NixOS](https://img.shields.io/badge/NixOS-25.11-blue?style=flat-square&logo=nixos)](https://nixos.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

A premium, reproducible NixOS configuration featuring **Home Manager** and **GNOME**, built with modern Nix Flakes.

## 🎯 Philosophy

DotFlakes is designed to be a stable, aesthetic, and highly productive base system. It prioritizes system-level management while keeping the environment visually polished and functionally robust.

## ⚡ Quick Start

Ready to try it? Follow the [Installation Guide](./INSTALL.md) or:

```bash
# 1. Clone this repository
git clone https://github.com/cesargomez89/dotflakes /etc/nixos

# 2. Copy your hardware configuration
cp /etc/nixos.backup/hardware-configuration.nix /etc/nixos/nixos/machines/<your-machine>/

# 3. Update hostname in flake.nix and configuration.nix

# 4. Install
sudo nixos-install --flake /etc/nixos#<your-machine> --no-root-passwd
```

## 📋 Prerequisites

- **NixOS 25.11** or newer
- **Flakes enabled** (`experimental-features = flakes nix-command` in `/etc/nix/nix.conf`)
- **Git** installed
- **UEFI** boot system

## 🛠️ Technology Stack

### Core System
- **NixOS**: The foundation of the system.
- **Flakes**: For reproducible and versioned configuration.
- **Home Manager**: Declarative user environment management.
- **Nix-Direnv**: Fast, automatic shell environments.

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

This configuration supports multiple machines:

| Machine | Description |
|---------|-------------|
| `desktop-amd` | AMD desktop (no NVIDIA) |
| `laptop-nvidia` | Laptop with NVIDIA (includes power-saving specialization) |

### NVIDIA Power-Saving Mode

The laptop has a specialization for power-saving mode:
- Build once: `sudo nixos-rebuild switch --flake .#laptop-nvidia`
- On reboot, select "NixOS, with on-the-go" from bootloader
- No rebuild needed to switch between modes

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

  # Set your hostname
  networking.hostName = "your-machine";

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

| Key | Action |
| :--- | :--- |
| `<Super> + Return` | Open Terminal (Kitty) |
| `<Super> + B` | Open Browser (Chrome) |
| `<Super> + E` | Open File Manager (Nautilus) |
| `<Super> + C` | Open Chat (Slack) |
| `<Super> + Y` | Open Music (YouTube Music) |
| `<Super> + R` | Change Wallpaper (Random) |
| `<Super> + Q` | Close Window |
| `<Super> + Backspace` | Log Out |
| `<Super>` | Overview / Activity search |
| `<Super> + Tab` | Switch Applications |

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
├── flake.nix                    # Entry point
├── INSTALL.md                   # Installation guide
├── LICENSE                      # MIT License
├── nixos/
│   ├── base.nix                 # Shared configuration
│   ├── nvidia.nix               # NVIDIA-specific settings
│   ├── options.nix              # Custom options
│   └── machines/
│       ├── desktop-amd/
│       │   ├── configuration.nix
│       │   └── hardware-configuration.nix
│       └── laptop-nvidia/
│           ├── configuration.nix
│           └── hardware-configuration.nix
└── home-manager/
    ├── home.nix                 # Main Home Manager entry
    └── gnome.nix                # GNOME settings
```

---

## 🔧 Troubleshooting

###flakes not enabled

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

### NVIDIA issues

Check that `enableNvidia` is set in your machine config:
```nix
enableNvidia = true;  # in nixos/machines/<machine>/configuration.nix
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
