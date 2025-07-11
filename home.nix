{ pkgs, ... }:

{
  # Import dconf settings from an external file
  imports = [
    ./apps/nvim/home.nix
    ./apps/tmux/home.nix
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
    ghostty

    # Programming
    # zig

    # Extra apps
    prismlauncher # https://wiki.nixos.org/wiki/Prism_Launcher#Advanced
    spotify
    discord

    gnumake
    gcc
    cmake
    ripgrep
    unzip
    xclip

    # Syncthing to sync folders
    # syncthing

    # VSCode
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

  # Brave Browser
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
      "--enable-extensions"
      "--load-extension"
    ];
  };

  # Alternative: Install Brave directly in packages if chromium module doesn't work
  # home.packages = with pkgs; [ brave ];

  #  custom-shader = ${toString ./ghostty/ghostty-shaders/starfield.glsl}
  home.file.".config/ghostty/config".text = ''
    config-file = ${toString ./apps/ghostty/config}
  '';

  # Vim config
  programs.vim = {
    enable = true;
    settings = {
      tabstop = 4; # Set tab width to 4 spaces
      shiftwidth = 4; # Indentation width to 4 spaces
      expandtab = true; # Convert tabs to spaces
    };
  };

  # Set environment variables
  home.sessionVariables = {
    #TERMINAL = "ghostty";
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
      cleanOS = "sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system && nix-env --delete-generations +5 && sudo nix-collect-garbage && nix-collect-garbage";
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
