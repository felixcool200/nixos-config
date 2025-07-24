# Wofi configuration
let
  colors = import ../colors.nix;
in
{
  programs.wofi = {
    enable = true;
    style = ''
      @define-color background ${colors.background};
      @define-color currentLine ${colors.currentLine};
      @define-color foreground ${colors.foreground};
      @define-color purple ${colors.purple};

      ${builtins.readFile ./style.css}
    '';
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod, S, exec, pkill wofi || wofi --show drun"
    ];
  };
}
