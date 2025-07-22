{
  # Wofi configuration
  programs.wofi = {
    enable = true;
    style = builtins.readFile ./style.css;
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod, S, exec, pkill wofi || wofi --show drun"
    ];
  };
}
