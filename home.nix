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

  # Create aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuildOS = "nixos-rebuild --flake ~/Documents/nixos-config switch --impure --sudo";
      cleanOS = "sudo nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system && nix-env --delete-generations +2 --profile ~/.local/state/nix/profiles/home-manager && sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo journalctl --vacuum-size=50M";
      upgradeOS = "nix flake update --flake ~/Documents/nixos-config && nixos-rebuild --flake ~/Documents/nixos-config switch --impure --sudo";
    };
  };

  programs.git = {
    enable = true;
    settings.user.name = "Felix Söderman";
    settings.user.email = "felixsoderman+github@gmail.com";
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}
