# 🛠️ NixOS Installation Guide

This guide provides step-by-step instructions for a fresh NixOS installation using this flake.

## 1. 🏗️ Preparation
Boot from the NixOS installation ISO and prepare your environment.

```bash
# Switch to root
sudo -i

# Enable flakes and git
nix-shell -p nixFlakes git

# Core hardware generation (from /mnt after partitioning/mounting)
nixos-generate-config --root /mnt
```

> **Secure Boot**: This flake uses `lanzaboote` for Secure Boot. After installation, enroll your keys with `sudo sbctl create-keys && sudo sbctl enroll-keys --microsoft` and rebuild.

## 2. 📥 Repository Setup
Clone the configuration and integrate your hardware settings.

```bash
# Backup default config
mv /mnt/etc/nixos /mnt/etc/nixos.backup

# Clone this repository (replace with your fork if applicable)
git clone https://github.com/cesargomez89/dotflakes /mnt/etc/nixos

# IMPORTANT: Copy your generated hardware configuration into the right machine directory
# Replace <machine> with your target (e.g., desktop-amd, laptop-nvidia, desktop-amd-niri, laptop-nvidia-niri)
cp /mnt/etc/nixos.backup/hardware-configuration.nix /mnt/etc/nixos/nixos/machines/<machine>/
```

## 3. 📝 Configuration Verification
Before installing, ensure the following fields match your hardware and intended user:

| File | Setting | Requirement |
| :--- | :--- | :--- |
| `flake.nix` | `nixosConfigurations.<name>` | The config key (e.g., `desktop-amd`, `laptop-nvidia-niri`) |
| `nixos/machines/<machine>/configuration.nix` | `desktopEnv` | Set to `"gnome"` or `"niri"` depending on your preference |
| `nixos/machines/<machine>/configuration.nix` | `config.users.users.cesar` | Rename to your preferred username if needed |

> [!IMPORTANT]
> If you change the username, search and replace "cesar" across the entire repository (especially in `home.nix`, `gnome.nix`, `apps.nix`, `noctalia.nix`, `niri.nix`, `themes.nix`, `random-bg.nix`).

## 4. 🚀 Installation
Run the installation command using the flake.

```bash
# Replace <machine> with your configuration name (e.g., desktop-amd, laptop-nvidia-niri)
nixos-install --flake /mnt/etc/nixos#<machine> --no-root-passwd
```

## 5. 🏁 Post-Installation
After rebooting and logging in as your user:

```bash
# Set your user password
passwd

# Ensure wallpaper directory exists
mkdir -p ~/Pictures/Wallpapers

# The random-bg script should be automatically linked to ~/.local/bin/
# Verify it is executable
ls -l ~/.local/bin/random-bg
```

## ✅ Verification Checklist
- [ ] **Home Manager**: Verify your user environment is active.
- [ ] **Wallpaper**: Run `random-bg` to test the background switcher.
- [ ] **Desktop**: Check that your desktop (GNOME or Niri) starts correctly.
- [ ] **Stack**: Verify core tools like `kitty`, `zsh`, and `neovim` are available.

> **Note**: This flake supports two desktop environments. Set `desktopEnv = "gnome"` for GNOME or `desktopEnv = "niri"` for the Niri compositor in your machine configuration. For Niri, the system uses `tuigreet` + `greetd` instead of GDM.
