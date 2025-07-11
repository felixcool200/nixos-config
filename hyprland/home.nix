{ pkgs, ... }:

{
  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ./waybar/config.json);
    };
    style = builtins.readFile ./waybar/style.css;
  };

  # Install the wittr.sh script
  home.file.".config/waybar/wittr.sh" = {
    source = ./waybar/wittr.sh;
    executable = true;
  };

  # Wofi configuration
  programs.wofi = {
    enable = true;
    style = builtins.readFile ./wofi/style.css;
  };

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
      kb_layout = "se"; # Swedish
    };

    # Monitor resolution
    monitor = [
      # Format: "name,resolution@refresh,position,scale"
      "Virtual-1,1920x1080@60,0x0,1"
      #",preferred,auto,1"
    ];

    "$mod" = "SUPER";

    # Autostart applications
    exec-once = [
      "waybar"
    ];

    bind =
      [
        # Window management
        "$mod, q, killactive"
        "$mod, c, killactive"
        "$mod, v, togglefloating"
        "$mod, f, fullscreen"
        "$mod, p, pseudo"
        "$mod, j, togglesplit"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Resize windows
        "$mod CTRL, left, resizeactive, -20 0"
        "$mod CTRL, right, resizeactive, 20 0"
        "$mod CTRL, up, resizeactive, 0 -20"
        "$mod CTRL, down, resizeactive, 0 20"
        "$mod CTRL, h, resizeactive, -20 0"
        "$mod CTRL, l, resizeactive, 20 0"
        "$mod CTRL, k, resizeactive, 0 -20"
        "$mod CTRL, j, resizeactive, 0 20"

        # Applications
        "$mod, F, exec, brave"
        "$mod, return, exec, kitty"
        "$mod, S, exec, wofi --show drun"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );
  };

  # Plugins
  #  wayland.windowManager.hyprland.plugins = [
  #    inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
  #    "/absolute/path/to/plugin.so"
  #    ];
}
