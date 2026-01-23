# 🤖 AI Agent Guidelines

Welcome, fellow agent! This repository contains a premium NixOS configuration built with Flakes and Home Manager. To maintain system integrity and follow the established patterns, please adhere to these guidelines.

## 📂 Repository Structure

- `flake.nix`: Entry point. Manages dependencies (inputs) and system configurations (outputs).
- `nixos/`: System-level configuration (drivers, services, networking).
  - `configuration.nix`: Core system settings.
  - `hardware-configuration.nix`: Hardware-specific settings (**DO NOT EDIT MANUALLY** unless necessary).
- `home-manager/`: User-level configuration (dotfiles, app settings, shell).
  - `home.nix`: Main Home Manager entry point.
  - `gnome.nix` / `hypr.nix`: Desktop environment specifics.

## 🛠️ Common Tasks

### Adding a System-wide Package
Modify `nixos/configuration.nix` and add the package to `environment.systemPackages`.

### Adding a User-level Package
Modify `home-manager/home.nix` and add the package to `home.packages`.

### Changing Theming
The system uses **Stylix**. Global theme settings are usually in `flake.nix` or inherited through modules. Avoid hardcoding colors if possible.

## 🚀 Verification & Deployment

Before applying changes, ALWAYS verify the configuration:

1. **Check Flake Syntax**:
   ```bash
   nix flake check
   ```

2. **Dry Run (System)**:
   ```bash
   sudo nixos-rebuild dry-activate --flake .#nixos
   ```

3. **Apply Changes**:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

## ⚠️ Critical Rules

1. **Declarative Over Imperative**: Never suggest `nix-env -i` or `pip install` (globally). Always prefer adding to the Nix configuration.
2. **Handle Hardware Carefully**: If hardware changes are needed, use `nixos-generate-config` or modify `nixos/hardware-configuration.nix` with caution.
3. **Secrets**: Do not hardcode secrets. This configuration currently doesn't use a secret manager like sops-nix or agenix, so be careful with sensitive data.
4. **Reproducibility**: Ensure all changes are reflected in the flake to maintain reproducibility.

Happy hacking! ❄️
