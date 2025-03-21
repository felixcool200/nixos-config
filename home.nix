{ config, pkgs, ... }:

{

  # Import dconf settings from an external file
  imports = [
    ./dconf/dconf.nix
  ];

  home.username = "felixcool200";
  home.homeDirectory = "/home/felixcool200";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    flatpak gnome-software zig ghostty bitwarden-desktop google-chrome cheese
    gnomeExtensions.dash-to-dock

    prismlauncher #https://wiki.nixos.org/wiki/Prism_Launcher#Advanced
    spotify discord

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

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
    ];
    #commandLineArgs = [
    #  "--disable-features=WebRtcAllowInputVolumeAdjustment"
    #];
  };

  #  custom-shader = ${toString ./ghostty/ghostty-shaders/starfield.glsl}
  home.file.".config/ghostty/config".text = ''
    config-file = ${toString ./ghostty/config}
  '';

  # Set environment variables
  home.sessionVariables = {
    TERMINAL = "ghostty";
    VISUAL = "vim";
    EDITOR = "vim";
  };

  # Create aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuildOS = "nixos-rebuild --flake ~/Documents/nixos-config switch --impure --use-remote-sudo";
    };
  };

  programs.git = {
    enable = true;
    userName = "Felix Söderman";
    userEmail = "felixsoderman+github@gmail.com";
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}

