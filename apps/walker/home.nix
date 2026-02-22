{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.walker
    pkgs.elephant
  ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "elephant"
      "walker --gapplication-service"
    ];
    bind = [
      "$mod, S, exec, walker"
    ];
  };
}
