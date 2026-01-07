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

## 2. 📥 Repository Setup
Clone the configuration and integrate your hardware settings.

```bash
# Backup default config
mv /mnt/etc/nixos /mnt/etc/nixos.backup

# Clone this repository (replace with your fork if applicable)
git clone https://github.com/cesargomez89/dotflakes /mnt/etc/nixos

# IMPORTANT: Copy your generated hardware configuration
cp /mnt/etc/nixos.backup/hardware-configuration.nix /mnt/etc/nixos/nixos/
```

## 3. 📝 Configuration Verification
Before installing, ensure the following fields match your hardware and intended user:

| File | Setting | Requirement |
| :--- | :--- | :--- |
| `flake.nix` | `nixosConfigurations.nixos` | Must match the target hostname |
| `nixos/configuration.nix` | `networking.hostName` | Must match the flake configuration name |
| `nixos/configuration.nix` | `users.users.cesar` | Rename to your preferred username if needed |

> [!IMPORTANT]
> If you change the username, search and replace "cesar" across the entire repository (especially in `home.nix` and `gnome.nix`).

## 4. 🚀 Installation
Run the installation command using the flake.

```bash
nixos-install --flake /mnt/etc/nixos#nixos --no-root-passwd
```

## 5. 🏁 Post-Installation
After rebooting and logging in as your user:

```bash
# Set your user password
passwd

# Ensure wallpaper directory exists
mkdir -p ~/wallpapers

# The random-bg script should be automatically linked to ~/.local/bin/
# Verify it is executable
ls -l ~/.local/bin/random-bg
```

## ✅ Verification Checklist
- [ ] **Home Manager**: Verify your user environment is active.
- [ ] **Wallpaper**: Run `random-bg` to test the background switcher.
- [ ] **Desktop**: Check that GNOME or Hyprland (depending on your choice) starts correctly.
- [ ] **Stack**: Verify core tools like `kitty`, `zsh`, and `neovim` are available.
