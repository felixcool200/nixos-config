# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NixOS flake-based system configuration for user `felixcool200`. Uses Home Manager (as a NixOS module) for user-level config. Targets `x86_64-linux` with nixpkgs unstable channel and NUR.

## Key Commands

```bash
# Rebuild and apply configuration
nixos-rebuild --flake ~/Documents/nixos-config switch --impure --sudo

# Update flake inputs then rebuild
nix flake update ~/Documents/nixos-config && nixos-rebuild --flake ~/Documents/nixos-config switch --impure --sudo

# Garbage collect old generations
sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system && nix-env --delete-generations +5 && sudo nix-collect-garbage && nix-collect-garbage
```

## Architecture

### Two-layer configuration

- **System level** (`configuration.nix`): NixOS system config, imports a desktop environment's `conf.nix`
- **User level** (`home.nix`): Home Manager config, imports a desktop environment's `home.nix` plus `apps/home.nix`

### Desktop environments (mutually exclusive)

The active DE is selected by which imports are uncommented in `configuration.nix` and `home.nix`:

- **`hyprland/`** — Hyprland (Wayland compositor). Currently active. System config in `conf.nix`, user config in `home.nix`. Sub-modules for waybar, walker, hyprlock, hyprpaper, wlogout, swaync, gtk theming, yazi, and greetd login manager. Wofi is present but currently disabled (commented out in `hyprland/home.nix`), replaced by walker (`apps/walker/`).
- **`gnome/`** — GNOME desktop. Currently commented out. Has dconf settings management.

### Apps (`apps/`)

Each app has its own directory with a `home.nix` for Home Manager config. Apps are toggled by commenting/uncommenting imports in `apps/home.nix`. Some apps also have a `shell.nix` for dev shells (e.g., minecraft). Apps that require system-level NixOS config (e.g., wireshark) also have a `conf.nix`, which is imported from `configuration.nix`.

### Theming

Dracula color palette is defined in `hyprland/colors.nix` as a Nix attribute set with hex, RGB, and rgba variants. Hyprland sub-modules import this file to stay consistent.

### Other files

- `pi4NixConfig.nix` — Standalone Raspberry Pi 4 config (SSH, WireGuard, Raspotify). Not part of the main flake.
- `backgrounds/shell.nix` — Dev shell for wallpaper-related work.
- Hardware config is at `/etc/nixos/hardware-configuration.nix` (not in repo, imported by path).

## Conventions

- `conf.nix` files contain NixOS system-level options (services, hardware, system packages)
- `home.nix` files contain Home Manager user-level options (programs, dotfiles, user packages)
- New apps should follow the `apps/<appname>/home.nix` pattern and be added to `apps/home.nix`
- Apps needing system-level config should also have `apps/<appname>/conf.nix` and be imported from `configuration.nix`
- The `--impure` flag is required because hardware-configuration.nix is imported by absolute path
- Hyprland shaders must use GLSL 3.20 ES (`#version 320 es`, `in`/`out` instead of `varying`/`gl_FragColor`, `texture()` instead of `texture2D()`)
- Night light uses hyprsunset (CTM-based, not captured in screenshots) toggled via waybar
- The current setup runs in a VM — GPU-dependent features (blur, screenshots in hyprlock, CTM color shifts) may not render visually. Use `hyprlock --verbose` to diagnose lock screen issues
- GTK3 apps may crash due to GTK3/GTK4 conflicts in the Hyprland session — prefer Qt variants when available (e.g., `wireshark-qt`). Qt platform theme must not be set to `gtk3` as it forces GTK3 lib loading; use `qtct`/`kvantum` instead
