# AI Agent Guidelines

NixOS + nix-darwin configuration using Flakes and Home Manager (as a system module).

## Repository Structure

- `flake.nix`: inputs, `nixosConfigurations`, `darwinConfigurations`, `formatter`.
- `devenv.nix`, `devenv.yaml`: repo dev environment (linters, git hooks).
- `INSTALL.md`, `README.md`: install guide and overview.
- `nixos/`: NixOS system config.
  - `base.nix`: shared across NixOS machines.
  - `gnome.nix`: desktop module.
  - `options.nix`: custom options: `desktopEnv` (`"gnome"`|`""`).
  - `machines/<host>/configuration.nix`: per-host config. Hosts: `desktop-amd`.
- `darwin/`: nix-darwin system config.
  - `base.nix`, `desktop.nix`: shared macOS config (Homebrew, defaults, yabai/skhd).
  - `machines/<host>/configuration.nix`: per-host config. Hosts: `macbook-pro`.
- `home-manager/`: user config, all modules imported on every platform.
  - `home.nix`: entry.
  - `gnome.nix`: gated on `osConfig.desktopEnv == "gnome"`.
  - `macos.nix`: gated on `pkgs.stdenv.hostPlatform.isDarwin`.
  - `apps.nix`: user packages.
  - `themes.nix`: Stylix theming.
  - `random-bg.nix`, `random-bg.sh`: wallpaper switcher (`writeShellApplication`).

## Username

Defined once as `username` in `flake.nix` and passed to all modules via `specialArgs`.

## Commands

```bash
nix flake show                                              # list outputs
nix flake check                                             # eval check
nix fmt                                                     # format (nixfmt)
devenv shell                                                # dev env + git hooks
devenv shell lint                                           # nixfmt, statix, deadnix, shellcheck
sudo nixos-rebuild dry-activate --flake .#<host>            # dry run (NixOS)
sudo nixos-rebuild switch --flake .#<host>                  # apply (NixOS)
sudo darwin-rebuild build --flake .#<host>                  # dry run (macOS)
sudo darwin-rebuild switch --flake .#<host>                 # apply (macOS)
sudo NIX_SHOW_TRACE=1 nixos-rebuild dry-activate --flake .#<host>  # trace
```

## Code Style

- Formatted with `nixfmt` (run `nix fmt`). Must pass `statix` and `deadnix`.
- kebab-case names.
- Module signature: `{ config, pkgs, lib, inputs, ... }:`; add `username` or `osConfig` (HM) as needed.
- Platform checks: `pkgs.stdenv.hostPlatform.isDarwin` / `isLinux` in config, never in `imports`.
- Gate whole modules with `lib.mkIf` instead of conditional imports.
- Flake packages inside modules: `inputs.<input>.packages.${pkgs.stdenv.hostPlatform.system}`.

## Flake Inputs

Use the `inputs` attrset. Use Stylix, avoid hardcoded colors. Add `inputs.nixpkgs.follows = "nixpkgs"` to new inputs unless they rely on their own binary cache.
Tracks `nixos-unstable`; home-manager, nix-darwin and stylix track their main branches to match.
Notable inputs: `lanzaboote` (Secure Boot), `llama-cpp` (Vulkan), `llm-agents` (Claude Code, OpenCode, pi; intentionally not following nixpkgs), `nix-homebrew`, `mac-app-util`.

## Common Tasks

- Add system package: `nixos/base.nix` or `darwin/base.nix` `environment.systemPackages`.
- Add user package: `home-manager/apps.nix` `home.packages`.
- Add machine-specific package: that machine's `configuration.nix`.
- Project toolchains (compilers, libraries, language runtimes): prefer a per-project `devenv.nix`.
- Add NixOS machine:
  1. `mkdir nixos/machines/<name>`
  2. `sudo nixos-generate-config --show-hardware-config > nixos/machines/<name>/hardware-configuration.nix`
  3. Create `configuration.nix` importing `../../base.nix`, `../../options.nix`, `./hardware-configuration.nix`, and set `networking.hostName = "<name>"`.
  4. Register in `flake.nix` under `nixosConfigurations`.

## Secrets

No sops-nix/agenix. Never hardcode credentials. Store in `/etc/nixos/secrets/` or env vars.

## Rules

1. Declarative only: never `nix-env -i` / global `pip install`.
2. Edit `hardware-configuration.nix` with caution; prefer `nixos-generate-config`.
3. Pin versions in `flake.nix` inputs.
4. Always dry run before `switch`.
