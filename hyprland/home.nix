{
  imports = [
    ./hyprlock/home.nix
    ./hyprpaper/home.nix
    ./waybar/home.nix
    ./wofi/home.nix
    ./gtk/home.nix
    ./wlogout/home.nix
    ./swaync/home.nix
    ./yazi/home.nix
  ];

  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

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

    # Cursor configuration
    env = [
      "HYPRCURSOR_THEME,Bibata-Modern-Classic"
      "HYPRCURSOR_SIZE,24"
    ];

    # Dracula theme configuration
    general = {
      "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
      "col.inactive_border" = "rgba(44475aaa)";
      "col.nogroup_border" = "rgba(282a36dd)";
      "col.nogroup_border_active" = "rgb(bd93f9) rgb(44475a) 90deg";
      border_size = 2;
      gaps_in = 3; # Default 5
      gaps_out = 6; # Default 10
    };

    decoration = {
      rounding = 10;
      rounding_power = 4.0;
      active_opacity = "0.9";
      inactive_opacity = "0.6";
      shadow = {
        enabled = true;
        range = 4;
        color = "rgba(1E202966)";
        render_power = 2;
        scale = 0.97;
      };
    };

    group = {
      groupbar = {
        "col.active" = "rgb(bd93f9) rgb(44475a) 90deg";
        "col.inactive" = "rgba(282a36dd)";
      };
    };

    misc = {
      disable_hyprland_logo = true;
    };

    # Window rules
    windowrule = [
      "bordercolor rgb(ff5555),xwayland:1" # check if window is xwayland
    ];

    # Autostart applications
    exec-once = [
      "waybar"
      "hypridle"
      "sleep 2 && nm-applet --indicator"
      "hyprctl setcursor Bibata-Modern-Classic 24"
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
        ", Print, exec, grimblast copy area"

        # Audio controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Clipboard controls
        #"CTRL, C, exec, wl-copy"
        #"CTRL, V, exec, wl-paste"

        # Lock screen

        # Workspace navigation with Ctrl+Alt+Arrow
        "CTRL ALT, left, workspace, -1"
        "CTRL ALT, right, workspace, +1"
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
