# macOS Setup Design

## Overview

Extend the existing `dotflakes` repository to support macOS (Apple Silicon) using `nix-darwin` for system configuration and `home-manager` for user-level configuration, achieving maximum parity with the existing NixOS/GNOME setup.

## Architecture

- **Single repository** (`dotflakes`) with both `nixos/` (existing, unchanged) and `darwin/` (new) system configurations
- **Shared `home-manager/`** with conditional imports for macOS vs Linux differences
- **Architecture target:** `aarch64-darwin` for Apple Silicon Macs

## Flake Inputs (added)

| Input | Source | Purpose |
|---|---|---|
| `nix-darwin` | `github:lnl7/nix-darwin` | macOS system configuration (NixOS equivalent) |
| `nix-homebrew` | `github:zhaofengli-wip/nix-homebrew` | Declarative Homebrew management |
| `mac-app-util` | `github:hraban/mac-app-util` | Register Nix apps in macOS Spotlight |

## Flake Outputs (added)

- `darwinConfigurations.macbook-pro` — Apple Silicon Mac configuration

## darwin/ Directory Structure

```
darwin/
  base.nix              # Shared macOS system config (mirrors nixos/base.nix)
  desktop.nix           # Dock, Mission Control, yabai, skhd, macOS defaults
  machines/
    macbook-pro/
      configuration.nix
      hardware-configuration.nix
```

### darwin/base.nix

Mirrors `nixos/base.nix` where applicable:
- Nix settings (flakes, auto-optimise-store, flake registries)
- System packages: same dev tools + CLI utilities + fonts as NixOS base
- Time/locale: `America/Mexico_City`, `en_US.UTF-8`
- Shell: Zsh, direnv
- nix-homebrew: enable, auto-update, casks for macOS-native GUI apps
- mac-app-util: register Nix-built apps in Launchpad/Spotlight

### darwin/desktop.nix

macOS desktop configuration replacing `nixos/gnome.nix`:
- Dock: autohide, position, magnification, recent apps
- Mission Control: group windows, hot corners
- Trackpad: tap-to-click, natural scroll, three-finger drag
- Keyboard: key repeat rate, function keys
- Finder: path bar, extensions, default list view
- yabai: tiling window manager (gaps, padding, BSP layout)
- skhd: hotkey daemon for keybindings
- macOS defaults: dark mode, disable animations, disable confirmations

## Home-Manager Changes

### home-manager/home.nix

Conditional imports using `pkgs.stdenv.isDarwin`:
- Linux-only: `gnome.nix`, `random-bg.nix`
- macOS-only: `macos.nix` (new)
- Both: `apps.nix`, `themes.nix`

### home-manager/macos.nix (new)

- Karabiner-Elements configuration (ctrl:swapcaps)
- skhdrc deployment (keybindings file)
- yabairc deployment (window manager config)
- Wallpaper script (adapted for macOS — `osascript`/`desktoppr` instead of `swww`)
- macOS clipboard integration (pbcopy/pbpaste)

### home-manager/apps.nix

Most packages unchanged (cross-platform). Changes:
- Add `llama-cpp-mps` (Metal Performance Shaders variant for Apple Silicon)
- Drop Linux-specific packages (nautilus, etc.)
- Homebrew casks managed via nix-homebrew for macOS-native apps

### home-manager/themes.nix

Unchanged — Stylix supports macOS natively.

## Keybindings Map

| GNOME | macOS |
|---|---|
| `<Super>Return` → kitty | `Ctrl + Return` → kitty (skhd) |
| `<Super>B` → Chrome | `Ctrl + B` → Chrome (skhd) |
| `<Super>E` → Nautilus | `Ctrl + E` → Finder (skhd) |
| `<Super>C` → Slack | `Ctrl + C` → Slack (skhd) |
| `<Super>Q` → Close | `Ctrl + Q` → yabai close (skhd) |
| `Ctrl:swapcaps` | Karabiner-Elements rule |

## Desktop Replacements

| GNOME Feature | macOS Equivalent | Managed by |
|---|---|---|
| OpenBar (top bar) | Menu bar + Ice | nix-homebrew (cask) |
| Tiling Shell | yabai | darwin/desktop.nix |
| GDM | macOS loginwindow | Built-in |
| App launcher | Raycast | nix-homebrew (cask) |
| GNOME Keyring | macOS Keychain | Built-in |
| Wallpaper | random-bg.sh (osascript) | home-manager/macos.nix |

## Known Limitations

- yabai requires partial SIP disable for transparent title bar management
- Some nixpkgs packages may not have `aarch64-darwin` support (rare)
- Stylix GTK theming only applies to GTK apps running on macOS

## Implementation Order

1. Add nix-darwin + nix-homebrew + mac-app-util inputs to flake.nix
2. Create darwin/base.nix
3. Create darwin/desktop.nix
4. Create darwin/machines/macbook-pro/
5. Create home-manager/macos.nix
6. Update home-manager/home.nix with conditional logic
7. Update home-manager/apps.nix for macOS compatibility
8. Add makeDarwinConfiguration helper to flake.nix
9. Add darwinConfigurations output to flake.nix
10. Create hardware-configuration.nix (via nix-darwin bootstrap)
11. Test with `nix flake check` and dry build
