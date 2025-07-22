{ config, lib, pkgs, ... }:

{
  # GTK3 theme configuration with Dracula colors
  gtk = {
    enable = true;
    
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    
    cursorTheme = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 24;
    };
    
    font = {
      name = "Sans";
      size = 11;
    };
    
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = false;
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH_HORIZ";
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = false;
    };
  };
  
  # Qt theme to match GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "gtk2";
  };
  
  # Environment variables for consistent theming
  home.sessionVariables = {
    GTK_THEME = "Dracula";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };
}