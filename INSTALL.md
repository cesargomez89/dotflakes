# NixOS Installation Guide

## 1. Fresh Install Preparation
```bash
# From installation ISO after partitioning/mounting:
sudo -i
nix-shell -p nixFlakes git
nixos-generate-config --root /mnt  # Generate hardware config
```

## 2. Repository Setup
```bash
mv /mnt/etc/nixos /mnt/etc/nixos.original
git clone https://github.com/yourusername/your-repo /mnt/etc/nixos

# Critical: Replace generated hardware config with yours
cp /mnt/etc/nixos.original/hardware-configuration.nix /mnt/etc/nixos/nixos/
```

## 3. Configuration Validation
Ensure these matches:
```nix
# flake.nix
nixosConfigurations.nixos = ...  # ← This name

# configuration.nix
networking.hostName = "nixos";  # ← Must match

# home.nix
home.username = "cesar";  # ← Must match user creation
```

## 4. Build & Activate
```bash
nixos-install --flake /mnt/etc/nixos#nixos --no-root-passwd
```

## Post-Install Essentials
```bash
# As user 'cesar':
mkdir -p ~/wallpapers  # Required for random-bg script
chmod +x ~/.local/bin/random-bg

# Set password for user
passwd cesar
```

## Key Verification Points
1. Home Manager integration is properly nested under `home-manager.users.cesar`
2. `random-bg.nix` creates all required desktop entries and autostart
3. ZeroTier overlay uses the pinned 23.11 nixpkgs correctly
4. All GNOME extensions in `home.packages` exist in nixpkgs-unstable
