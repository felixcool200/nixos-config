{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GNOME applications
    gnome-software

    # GNOME extensions
    gnomeExtensions.dash-to-dock

    # Additional apps that work well with GNOME
    cheese
  ];

  # Brave browser command line args for GNOME
  programs.chromium.commandLineArgs = [
    "--disable-features=WebRtcAllowInputVolumeAdjustment"
  ];
}

