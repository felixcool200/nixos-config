{ config, ... }:

{
  # Hyprpaper configuration using home-manager
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = [
        "${config.home.homeDirectory}/Documents/nixos-config/backgrounds/gnome-map-d.png"
      ];

      wallpaper = [
        ",${config.home.homeDirectory}/Documents/nixos-config/backgrounds/gnome-map-d.png"
      ];
    };
  };
}

