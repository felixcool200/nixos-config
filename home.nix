{ config, pkgs, ... }:

{

  # Enable dconf support in Home Manager
  programs.dconf.enable = true;

  # Import dconf settings from an external file
  imports = [
    /etc/nixos/dconf/dconf.nix
  ];

  home.username = "felixcool200";
  home.homeDirectory = "/home/felixcool200";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    flatpak gnome-software zig ghostty bitwarden-desktop google-chrome cheese
    gnomeExtensions.dash-to-dock

    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        dracula-theme.theme-dracula
        bbenoist.nix
        ms-python.python
        ms-vscode.cpptools
        ziglang.vscode-zig
      ];
    })
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    # Install extensions for the current user
    profiles.default = {
      id = 0;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons or {}; [
        ublock-origin
        bitwarden
      ];
    };
  };

  home.file.".bashrc".source = "/etc/nixos/bashrc";

  home.file.".config/ghostty/config".source = "/etc/nixos/ghostty/config";

  # Set environment variables
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };

  programs.git = {
    enable = true;
    userName = "Felix Söderman";
    userEmail = "felixsoderman@gmail.com";
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}

