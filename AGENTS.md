# 🤖 AI Agent Guidelines

Welcome! This repository contains a NixOS configuration built with Flakes and Home Manager. Follow these guidelines to maintain system integrity.

## 📂 Repository Structure

- `flake.nix`: Entry point. Manages dependencies (inputs) and system configurations (outputs).
- `INSTALL.md`: Step-by-step installation guide for fresh NixOS setups.
- `nixos/`: System-level configuration (drivers, services, networking).
  - `base.nix`: Shared configuration for all machines.
  - `nvidia.nix`: NVIDIA-specific settings (conditional).
  - `options.nix`: Custom option definitions.
  - `machines/`: Machine-specific configurations.
    - `desktop-amd/`: AMD desktop configuration.
    - `laptop-nvidia/`: Laptop with NVIDIA (includes specialization for power-saving mode).
- `home-manager/`: User-level configuration (dotfiles, app settings, shell).
  - `home.nix`: Main Home Manager entry point.
  - `gnome.nix`: GNOME settings & extensions.

## ⚠️ Critical: Hardcoded Username

The username **`cesar`** is hardcoded throughout this repository. Before deploying:

1. **Search and replace** all occurrences of `cesar` with your desired username
2. Key files to update:
   - `home-manager/home.nix` - user name and home directory path
   - `home-manager/gnome.nix` - user-specific paths
   - `flake.nix` - home-manager users.cesar → users.yourname
   - `nixos/machines/*/configuration.nix` - users.users.cesar

Use: `grep -rl "cesar" . | xargs sed -i 's/cesar/yourusername/g'`

## 🛠️ Build, Lint & Verification Commands

This is a NixOS configuration repository - no traditional unit tests exist.

### Available Configurations
```bash
nix flake show                              # Show all flake outputs
```

### Syntax Validation
```bash
nix flake check                                          # Check flake syntax
nix eval .#nixosConfigurations.desktop-amd.config.system.build.toplevel.drv.outPath  # Evaluate config
```

### Dry Run & Apply
```bash
# Desktop (AMD)
sudo nixos-rebuild dry-activate --flake .#desktop-amd
sudo nixos-rebuild switch --flake .#desktop-amd

# Laptop with NVIDIA
sudo nixos-rebuild dry-activate --flake .#laptop-nvidia
sudo nixos-rebuild switch --flake .#laptop-nvidia
```

### Specialization (NVIDIA Power-Saving)
The laptop-nvidia config has a specialization for power-saving mode:
- Build once: `sudo nixos-rebuild switch --flake .#laptop-nvidia`
- On reboot, select "NixOS, with on-the-go" from bootloader for NVIDIA offload mode
- No rebuild needed to switch between modes

### Home Manager
```bash
home-manager switch --flake .    # Apply home-manager changes
home-manager dry-run --flake .   # Dry run home-manager
```

### Debugging
```bash
nix develop                                      # Enter Nix shell with dependencies
sudo NIX_SHOW_TRACE=1 nixos-rebuild dry-activate --flake .#desktop-amd  # Show trace on errors
```

## 📝 Code Style Guidelines

### Module Arguments
```nix
{ config, pkgs, lib, inputs, ... }@args:  # Standard signature
{ config, pkgs, lib, stylix, unstablePkgs, enableGnome, ... }:  # With custom args
```

### Indentation & Attributes
- Use 2-space indentation for nested attributes
- Always use curly braces for attribute sets: `{ key = "value"; }`
- Trailing semicolons are required

### Naming Conventions
- Files: lowercase with hyphens (e.g., `configuration.nix`)
- Variables/attributes: lowercase with hyphens (kebab-case)
- Package names: use the attribute name from nixpkgs

### Conditionals
```nix
# Conditional imports (single condition)
imports = [ ./base.nix ] ++ lib.optional config.enableNvidia ./nvidia.nix;

# Conditional imports (multiple conditions)
imports = [ ./base.nix ] ++ lib.optionals config.enableNvidia [ ./nvidia.nix ];

# Conditional attributes
hardware.nvidia = lib.mkIf config.enableNvidia { enable = true; };

# Force override
boot.loader.systemd-boot.enable = lib.mkForce false;

# Default value
desktopManager.gnome.enable = lib.mkDefault true;
```

### Custom Options
Custom options are defined in `nixos/options.nix` (e.g., `enableNvidia`, `enableNvidiaOffload`). Import this file in machine configs to use them.

### Package Lists
```nix
environment.systemPackages = with pkgs; [
  pkg-config cmake openssl.dev git
];

# Mix pkgs and unstablePkgs
home.packages = with pkgs; [ neovim starship ] ++ [ unstablePkgs.opencode ];
```

### Flake Inputs & Theming
- Reference flake inputs via `inputs` attribute set
- Use `unstablePkgs` (passed from flake.nix) for packages from nixos-unstable
- Use Stylix for theming - avoid hardcoding colors
- **antigravity-nix**: Adds "Antigravity" desktop app for file search (see `home-manager/apps.nix`)

## 🏗️ Common Tasks

### Add System Package
Edit `nixos/base.nix`, add to `environment.systemPackages`:
```nix
environment.systemPackages = with pkgs; [ existing-package new-package ];
```

### Add User Package
Edit `home-manager/home.nix`, add to `home.packages`:
```nix
home.packages = with pkgs; [ existing-package new-package ];
```

### Add Machine-Specific Package
Add to the appropriate `nixos/machines/<machine>/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [ package-name ];
```

### Add New Machine
1. Create directory: `nixos/machines/<name>/`
2. Generate hardware config: `sudo nixos-generate-config --show-hardware-config > nixos/machines/<name>/hardware-configuration.nix`
3. Create configuration.nix:
```nix
{ lib, ... }:

{
  imports = [
    ../../base.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];
}
```
4. Add to flake.nix under `nixosConfigurations`

## 🔐 Secrets Handling

**CRITICAL**: No secret manager (sops-nix/agenix) is used.

- Never hardcode passwords, API keys, or tokens
- Store credentials in system-specific locations (e.g., `/etc/nixos/secrets/`)
- Use environment variables for runtime secrets

## 🧪 Testing Changes

1. Run `nix flake check` to validate syntax
2. Run `sudo nixos-rebuild dry-activate --flake .#desktop-amd` to test
3. Only run `sudo nixos-rebuild switch --flake .#desktop-amd` after dry run succeeds

## ⚠️ Critical Rules

1. **Declarative**: Never suggest `nix-env -i` or `pip install` (globally). Always add to Nix configuration.
2. **Hardware**: Use `nixos-generate-config` or modify `hardware-configuration.nix` with caution.
3. **Reproducibility**: Pin versions in `flake.nix` inputs.
4. **Verify First**: Always run dry-activate before switching.

Happy hacking! ❄️
