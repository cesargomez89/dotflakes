# 🛠️ Installation Guide

This guide provides step-by-step instructions for setting up this flake on **NixOS** or **macOS**.

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

### NixOS
- [ ] **Home Manager**: Verify your user environment is active.
- [ ] **Wallpaper**: Run `random-bg` to test the background switcher.
- [ ] **Desktop**: Check that your desktop (GNOME or Niri) starts correctly.
- [ ] **Stack**: Verify core tools like `kitty`, `zsh`, and `neovim` are available.

> **Note**: This flake supports two desktop environments. Set `desktopEnv = "gnome"` for GNOME or `desktopEnv = "niri"` for the Niri compositor in your machine configuration. For Niri, the system uses `tuigreet` + `greetd` instead of GDM.

---

# 🍎 macOS Installation Guide

This section covers setting up the flake on a new Apple Silicon MacBook Pro.

## 1. 🏗️ Prerequisites

```bash
# Install Nix (Determinate Nix Installer — recommended)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Restart your shell or source the profile
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Install Rosetta (required for Homebrew x86_64 emulation)
softwareupdate --install-rosetta --agree-to-license
```

## 2. 📥 Repository Setup

```bash
# Clone this repository (replace with your fork if applicable)
git clone https://github.com/cesargomez89/dotflakes ~/dotflakes
cd ~/dotflakes

# IMPORTANT: Rename username if needed
# grep -rl "cesar" . | xargs sed -i 's/cesar/yourusername/g'

# Generate hardware configuration
nix run nix-darwin -- --show-hardware-config > darwin/machines/macbook-pro/hardware-configuration.nix
```

## 3. 📝 Configuration

Review the following files before installing:

| File | Setting | Notes |
| :--- | :--- | :--- |
| `darwin/base.nix` | `networking.hostName` | Your Mac's network name |
| `darwin/base.nix` | `networking.computerName` | Your Mac's display name |
| `darwin/base.nix` | `users.users.cesar` | Rename username if needed |
| `darwin/base.nix` | `nix-homebrew.user` | Must match your username |
| `darwin/machines/macbook-pro/hardware-configuration.nix` | Hardware-specific | Generated in step 2 |

## 4. 🚀 Installation

```bash
# Activate the system (this will set up everything)
nix run nix-darwin -- switch --flake .#macbook-pro

# Or for subsequent updates (after first activation):
darwin-rebuild switch --flake .#macbook-pro
```

This single command will:
- Configure system settings (dock, finder, trackpad, keyboard)
- Install system packages (kitty, neovim, ripgrep, etc.)
- Install Homebrew and manage casks via `nix-homebrew`
- Set up Home Manager (zsh, git, starship, dev tools)
- Install and configure yabai (tiling window manager) + skhd (hotkeys)
- Deploy Karabiner-Elements config (Caps Lock → Ctrl)
- Deploy Stylix theming (Catppuccin Mocha)
- Deploy wallpaper script

## 5. 🏁 Post-Installation

### System Preferences
Some settings require manual approval:

```bash
# Create wallpaper directory
mkdir -p ~/Pictures/Wallpapers

# Add some wallpapers:
# cp ~/Downloads/my-wallpaper.jpg ~/Pictures/Wallpapers/

# Test wallpaper script
random-bg
```

### Accessibility Permissions

After first reboot, grant permissions:

1. **Karabiner-Elements** → Open the app, grant Input Monitoring when prompted
2. **yabai** → Grant Accessibility access in System Settings → Privacy & Security
3. **skhd** → Grant Accessibility access (same as yabai)

### SIP Configuration (for yabai)

yabai requires partial SIP disable for window transparency features:

```bash
# Reboot into Recovery Mode (hold Cmd+R at startup)
# Open Terminal from Utilities menu
csrutil enable --without fs --without debug --without nvram
# Reboot
```

Alternatively, yabai works without SIP changes — just without transparent window titles.

### Verify Installation

```bash
# Check darwin system
darwin-rebuild --version

# Check Home Manager
home-manager --version

# Check yabai
yabai --version

# Check Karabiner config
cat ~/.config/karabiner/karabiner.json | head -20

# Verify system packages are available
which kitty nvim rg
```

## ✅ macOS Verification Checklist
- [ ] **Hardware config**: Generated and placed in `darwin/machines/macbook-pro/`
- [ ] **System activated**: `darwin-rebuild switch --flake .#macbook-pro` completes
- [ ] **Wallpaper**: `random-bg` works via `desktoppr`
- [ ] **yabai**: Window tiling is active after reboot
- [ ] **skhd**: Keybindings work (`Ctrl + Return` opens kitty)
- [ ] **Karabiner**: Caps Lock functions as Ctrl
- [ ] **Homebrew**: Casks can be installed
- [ ] **Home Manager**: Zsh, git, starship, direnv are configured
- [ ] **Stack**: `kitty`, `neovim`, `ripgrep`, `btop` available in PATH

> **Note**: The first build will take a while (it compiles packages from source). Subsequent builds are much faster thanks to the Nix binary cache.
