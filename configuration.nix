{ config, pkgs, lib, ... }:

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
 
   imports =
    [ /etc/nixos/hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/vda";
  #boot.loader.grub.useOSProber = true;
  
  networking.hostName = "nixos";
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

  # X11 and GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "se";

  # Console keymap
  console.keyMap = "sv-latin1";

  # Enable printing
  services.printing.enable = true;

  # Enable sound with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support
  services.libinput.enable = true;

  # Define the user
  users.users.felixcool200 = {
    isNormalUser = true;
    description = "Felix Söderman";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
  };

  # Allow Wireshark to capture traffic
  programs.wireshark.enable = true;

  # Remove unwanted GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    simple-scan totem yelp geary seahorse
    gnome-text-editor gnome-tour gnome-calculator gnome-calendar
    gnome-characters gnome-clocks gnome-contacts gnome-font-viewer
    gnome-logs gnome-maps gnome-music gnome-weather
    gnome-disk-utility pkgs.gnome-connections
  ];

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim wget htop wireshark git
  ];

  # Set the system state version
  system.stateVersion = "24.11";
}

