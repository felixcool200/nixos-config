{ pkgs, ... }:

{

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

  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

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
    waybar
    hyprlock
    wofi
    kitty
    wl-clipboard
    xdg-desktop-portal-hyprland
    dunst
    libnotify
  ];

}
