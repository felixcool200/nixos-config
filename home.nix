{ pkgs, ... }:

{
  # Import dconf settings from an external file
  imports = [
    ./apps/home.nix
    ./hyprland/home.nix
  ];

  home.username = "felixcool200";
  home.homeDirectory = "/home/felixcool200";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [

    # Installing extra software outside of configuration.
    flatpak
    #gnome-software

    # Terminal

    # Extra apps
    #prismlauncher # https://wiki.nixos.org/wiki/Prism_Launcher#Advanced

    # Programming
    #zig

    gnumake
    gcc
    cmake
    ripgrep
    unzip
    xclip

    # Syncthing to sync folders
    # syncthing

  ];




  # Set environment variables
  home.sessionVariables = {
    VISUAL = "nvim";
    #EDITOR = "nvim";
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}
