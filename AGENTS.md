# 🤖 AI Agent Guidelines

Welcome! This repository contains a NixOS configuration built with Flakes and Home Manager. Follow these guidelines to maintain system integrity.

## 📂 Repository Structure

- `flake.nix`: Entry point. Manages dependencies (inputs) and system configurations (outputs).
- `nixos/`: System-level configuration (drivers, services, networking).
  - `configuration.nix`: Core system settings.
  - `hardware-configuration.nix`: Hardware-specific settings (**DO NOT EDIT MANUALLY** unless necessary).
- `home-manager/`: User-level configuration (dotfiles, app settings, shell).
  - `home.nix`: Main Home Manager entry point.
  - `gnome.nix` / `hypr.nix`: Desktop environment specifics.

## 🛠️ Build, Lint & Verification Commands

This is a NixOS configuration repository - no traditional unit tests exist.

### Syntax Validation
```bash
nix flake check                                    # Check flake syntax
nix flake show                                    # Show all flake outputs
nix eval .#nixosConfigurations.nixos.config.system.build.toplevel.drv.outPath  # Evaluate config
```

### Dry Run & Apply
```bash
sudo nixos-rebuild dry-activate --flake .#nixos  # Validate without applying
sudo nixos-rebuild switch --flake .#nixos         # Apply changes (after dry run)
sudo nixos-rebuild build --flake .#nixos          # Build but don't switch
```

### Home Manager
```bash
home-manager switch --flake .    # Apply home-manager changes
home-manager dry-run --flake .   # Dry run home-manager
```

### Debugging
```bash
nix develop                                      # Enter Nix shell with dependencies
sudo NIX_SHOW_TRACE=1 nixos-rebuild dry-activate --flake .#nixos  # Show trace on errors
```

## 📝 Code Style Guidelines

### Module Arguments
```nix
{ config, pkgs, lib, inputs, ... }@args:  # Standard signature

{ config, pkgs, lib, stylix, unstablePkgs, enableGnome, enableHyprland, ... }:  # With custom args
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
# Conditional imports
imports = [ ./base.nix ] ++ lib.optionals enableGnome [ ./gnome.nix ];

# Conditional attributes
services.gnome = lib.mkIf enableGnome { enable = true; };

# Force override
boot.loader.systemd-boot.enable = lib.mkForce false;

# Default value
desktopManager.gnome.enable = lib.mkDefault true;
```

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

## 🏗️ Common Tasks

### Add System Package
Edit `nixos/configuration.nix`, add to `environment.systemPackages`:
```nix
environment.systemPackages = with pkgs; [ existing-package new-package ];
```

### Add User Package
Edit `home-manager/home.nix`, add to `home.packages`:
```nix
home.packages = with pkgs; [ existing-package new-package ];
```

### Toggle Desktop Environment
In `flake.nix`:
```nix
enableGnome = true;      # or false
enableHyprland = false;  # or true
```

## 🔐 Secrets Handling

**CRITICAL**: No secret manager (sops-nix/agenix) is used.

- Never hardcode passwords, API keys, or tokens
- Store credentials in system-specific locations (e.g., `/etc/nixos/secrets/`)
- Use environment variables for runtime secrets

## 🧪 Testing Changes

1. Run `nix flake check` to validate syntax
2. Run `sudo nixos-rebuild dry-activate --flake .#nixos` to test
3. Only run `sudo nixos-rebuild switch --flake .#nixos` after dry run succeeds

## ⚠️ Critical Rules

1. **Declarative**: Never suggest `nix-env -i` or `pip install` (globally). Always add to Nix configuration.
2. **Hardware**: Use `nixos-generate-config` or modify `hardware-configuration.nix` with caution.
3. **Reproducibility**: Pin versions in `flake.nix` inputs.
4. **Verify First**: Always run dry-activate before switching.

Happy hacking! ❄️
