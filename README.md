# ❄️ DotFlakes

A premium, reproducible NixOS configuration featuring **Home Manager** and **GNOME**, built with modern Nix Flakes.

## 🎯 Philosophy

DotFlakes is designed to be a stable, aesthetic, and highly productive base system. It prioritizes system-level management while keeping the environment visually polished and functionally robust.

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
The system includes a custom `random-bg` script that changes your wallpaper from `~/wallpapers/`.
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

## 🤝 Contributing

This is my personal configuration, but I'm happy to accept suggestions, bug reports, or forks. Feel free to open an issue or a PR!
