{ ... }: {
  flake.nixosModules.gtk-theme = { pkgs, ... }:
  let
    gtk3Settings = ''
      [Settings]
      gtk-theme-name=Dracula
      gtk-icon-theme-name=Dracula
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=24
      gtk-font-name=Sans 11
      gtk-application-prefer-dark-theme=true
      gtk-decoration-layout=appmenu:none
      gtk-enable-animations=true
      gtk-primary-button-warps-slider=false
      gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
    '';

    gtk4Settings = ''
      [Settings]
      gtk-theme-name=Dracula
      gtk-icon-theme-name=Dracula
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=24
      gtk-font-name=Sans 11
      gtk-application-prefer-dark-theme=true
      gtk-decoration-layout=appmenu:none
      gtk-enable-animations=true
      gtk-primary-button-warps-slider=false
    '';
  in {
    environment.systemPackages = with pkgs; [
      dracula-theme
      dracula-icon-theme
      bibata-cursors
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
    ];

    # GTK settings via hjem (per-user config)
    hjem.users.felixcool200.xdg.config.files = {
      "gtk-3.0/settings.ini".text = gtk3Settings;
      "gtk-4.0/settings.ini".text = gtk4Settings;
    };

    # Qt theming
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    # GTK theme environment variable
    environment.sessionVariables.GTK_THEME = "Dracula";
  };
}
