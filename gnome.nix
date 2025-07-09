{ config, pkgs, lib, ... }:

{


  # X11 and GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "se";


  # Remove unwanted GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    simple-scan totem yelp geary seahorse
    gnome-text-editor gnome-tour gnome-calculator gnome-calendar
   gnome-characters gnome-clocks gnome-contacts gnome-font-viewer
    gnome-logs gnome-maps gnome-music gnome-weather
    gnome-disk-utility pkgs.gnome-connections
  ];

  # Enable sound with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
