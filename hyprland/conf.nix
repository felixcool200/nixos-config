{ pkgs, ... }:

{
  imports = [
    ./greetd/conf.nix
  ];

  # Enabling hyprlnd on NixOS
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # if needed
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Ensure polkit is available for nm-applet
  security.polkit.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Optional system packages
  environment.systemPackages = with pkgs; [
    kitty # Default terminal
    wl-clipboard # Clipboard utility

    # Notifications
    dunst
    libnotify

    # Network management
    networkmanagerapplet
  ];

}
