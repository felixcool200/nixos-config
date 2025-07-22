{ config, ... }:

{
  # Hyprpaper configuration using home-manager
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
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

