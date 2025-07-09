{ config, pkgs, ... }:

{


  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";

    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

# Usage
  wayland.windowManager.hyprland.settings = {

     # Keyboard layout
  input = {
    kb_layout = "se";  # Swedish
  };

  # Monitor resolution
  monitor = [
    # Format: "name,resolution@refresh,position,scale"
      "Virtual-1,1920x1080@60,0x0,1"
      #",preferred,auto,1"
  ];

    "$mod" = "SUPER";
    bind =
      [
        "$mod, c, exec, killactive"
        "$mod, F, exec, brave"
        "$mod, S, exec, rofi -show drun -show-icons"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
  };

# Plugins
#  wayland.windowManager.hyprland.plugins = [
#    inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
#    "/absolute/path/to/plugin.so"
#    ];
}
