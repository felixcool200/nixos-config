{ self, inputs, ... }: {
  flake.nixosModules.common = { pkgs, ... }: {
    imports = [
      inputs.nur.modules.nixos.default

      # Desktop environment (uncomment one)
      self.nixosModules.hyprland
      #self.nixosModules.niri

      # Hjem (home directory manager)
      self.nixosModules.hjem

      # Apps
      self.nixosModules.wireshark
      self.nixosModules.bash
      self.nixosModules.fish
      self.nixosModules.git
      self.nixosModules.fonts
      self.nixosModules.lsp
      self.nixosModules.ai
      self.nixosModules.nvim
      self.nixosModules.tmux
      self.nixosModules.vim
      self.nixosModules.ghostty

      self.nixosModules.vscode
      self.nixosModules.brave
      self.nixosModules.helix
      self.nixosModules.spotify
      self.nixosModules.discord
      self.nixosModules.yazi
      self.nixosModules.gtk-theme
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    networking.networkmanager.enable = true;

    # Time zone and locale
    time.timeZone = "Europe/Stockholm";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };

    # Enable Flatpak
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    # Console keymap
    console.keyMap = "sv-latin1";

    # Enable printing
    services.printing.enable = true;

    # Enable touchpad support
    services.libinput.enable = true;

    # Default shell
    programs.fish.enable = true;

    # Define the user
    users.users.felixcool200 = {
      isNormalUser = true;
      description = "Felix Söderman";
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "wheel"
        "wireshark"
      ];
    };

    # System-wide packages
    environment.systemPackages = with pkgs; [
      vim
      wget
      htop
      flatpak
      gnumake
      gcc
      cmake
      ripgrep
      unzip
      xclip
    ];

    environment.sessionVariables.VISUAL = "nvim";

    # Set the system state version
    system.stateVersion = "25.05";
  };
}
