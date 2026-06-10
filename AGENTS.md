# AI Agent Guidelines

NixOS configuration using Flakes and Home Manager.

## Repository Structure

- `flake.nix` — entry point: inputs and `nixosConfigurations`.
- `INSTALL.md`, `README.md` — install guide and overview.
- `nixos/` — system config.
  - `base.nix` — shared across machines.
  - `gnome.nix` — desktop module.
  - `options.nix` — custom options: `desktopEnv` (`"gnome"`|`""`).
  - `machines/<host>/configuration.nix` — per-host config. Hosts: `desktop-amd`.
- `home-manager/` — user config.
  - `home.nix` — entry, conditionally imports per `desktopEnv`.
  - `gnome.nix` — desktop-specific.
  - `apps.nix` — user packages.
  - `themes.nix` — Stylix theming.
  - `random-bg.nix` — wallpaper switcher.

## Hardcoded Username

Username `cesar` is hardcoded. To rename:
`grep -rl "cesar" . | xargs sed -i 's/cesar/yourusername/g'`
Affects `home-manager/*.nix`, `flake.nix`, `nixos/machines/*/configuration.nix`.

## Commands

```bash
nix flake show                                              # list outputs
nix flake check                                             # syntax check
sudo nixos-rebuild dry-activate --flake .#<host>            # dry run
sudo nixos-rebuild switch --flake .#<host>                  # apply
home-manager switch --flake .                               # apply HM
nix develop                                                 # dev shell
sudo NIX_SHOW_TRACE=1 nixos-rebuild dry-activate --flake .#<host>  # trace
```

## Code Style

- 2-space indent, kebab-case names, trailing semicolons, attribute sets in `{ }`.
- Module signature: `{ config, pkgs, lib, inputs, ... }@args:` (add `stylix`, `unstablePkgs`, `desktopEnv` as needed).
- Conditionals:
  ```nix
  boot.loader.systemd-boot.enable = lib.mkForce false;
  desktopManager.gnome.enable = lib.mkDefault true;
  ```
- Packages:
  ```nix
  environment.systemPackages = with pkgs; [ pkg ] ++ [ unstablePkgs.opencode ];
  ```

## Flake Inputs

Use `inputs` attrset; `unstablePkgs` for nixos-unstable packages. Use Stylix, avoid hardcoded colors.
Notable inputs: `antigravity-nix`, `lanzaboote` (Secure Boot), `llama-cpp` (Vulkan), `llm-agents` (Claude Code, OpenCode, pi).

## Common Tasks

- Add system package → `nixos/base.nix` `environment.systemPackages`.
- Add user package → `home-manager/home.nix` `home.packages`.
- Add machine-specific package → that machine's `configuration.nix`.
- Add machine:
  1. `mkdir nixos/machines/<name>`
  2. `sudo nixos-generate-config --show-hardware-config > nixos/machines/<name>/hardware-configuration.nix`
  3. Create `configuration.nix` importing `../../base.nix`, `../../options.nix`, `./hardware-configuration.nix`.
  4. Register in `flake.nix` under `nixosConfigurations`.

## Secrets

No sops-nix/agenix. Never hardcode credentials. Store in `/etc/nixos/secrets/` or env vars.

## Rules

1. Declarative only — never `nix-env -i` / global `pip install`.
2. Edit `hardware-configuration.nix` with caution; prefer `nixos-generate-config`.
3. Pin versions in `flake.nix` inputs.
4. Always `dry-activate` before `switch`.
