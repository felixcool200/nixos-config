{ self, ... }: {
  flake.nixosModules.hyprland = { pkgs, ... }:
  let
    self' = self.packages.${pkgs.stdenv.hostPlatform.system};
    colors = import (self + "/hyprland/colors.nix");

    # Workspace binds (1-9)
    workspaceBinds = builtins.concatStringsSep "\n" (
      builtins.concatLists (
        builtins.genList (i:
          let ws = i + 1; in [
            "bind = $mod, code:1${toString i}, workspace, ${toString ws}"
            "bind = $mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      )
    );

    hyprlandConf = ''
      # Keyboard layout
      input {
          kb_layout = se
      }

      # Monitor resolution
      monitor = Virtual-1,1920x1080@60,0x0,1

      $mod = SUPER

      # Cursor configuration
      env = HYPRCURSOR_THEME,Bibata-Modern-Classic
      env = HYPRCURSOR_SIZE,24

      # General (Dracula theme)
      general {
          col.active_border = rgb(44475a) rgb(bd93f9) 90deg
          col.inactive_border = rgba(44475aaa)
          col.nogroup_border = rgba(282a36dd)
          col.nogroup_border_active = rgb(bd93f9) rgb(44475a) 90deg
          border_size = 2
          gaps_in = 3
          gaps_out = 6
      }

      decoration {
          rounding = 10
          rounding_power = 4.0
          active_opacity = 0.9
          inactive_opacity = 0.6
          shadow {
              enabled = true
              range = 4
              color = rgba(1E202966)
              render_power = 2
              scale = 0.97
          }
      }

      group {
          groupbar {
              col.active = rgb(bd93f9) rgb(44475a) 90deg
              col.inactive = rgba(282a36dd)
          }
      }

      misc {
          disable_hyprland_logo = true
      }

      # Window rules
      windowrule = border_color rgb(ff5555), match:xwayland 1

      # Autostart applications
      exec-once = waybar
      exec-once = hypridle
      exec-once = hyprpaper
      exec-once = swaync
      exec-once = sleep 2 && nm-applet --indicator
      exec-once = hyprctl setcursor Bibata-Modern-Classic 24
      exec-once = elephant
      exec-once = walker --gapplication-service

      # Window management
      bind = $mod, q, killactive
      bind = $mod, c, killactive
      bind = $mod, v, togglefloating
      bind = $mod, f, fullscreen
      bind = $mod, p, pseudo
      bind = $mod, j, togglesplit

      # Move focus
      bind = $mod, left, movefocus, l
      bind = $mod, right, movefocus, r
      bind = $mod, up, movefocus, u
      bind = $mod, down, movefocus, d
      bind = $mod, h, movefocus, l
      bind = $mod, l, movefocus, r
      bind = $mod, k, movefocus, u
      bind = $mod, j, movefocus, d

      # Move windows
      bind = $mod SHIFT, left, movewindow, l
      bind = $mod SHIFT, right, movewindow, r
      bind = $mod SHIFT, up, movewindow, u
      bind = $mod SHIFT, down, movewindow, d
      bind = $mod SHIFT, h, movewindow, l
      bind = $mod SHIFT, l, movewindow, r
      bind = $mod SHIFT, k, movewindow, u
      bind = $mod SHIFT, j, movewindow, d

      # Resize windows
      bind = $mod CTRL, left, resizeactive, -20 0
      bind = $mod CTRL, right, resizeactive, 20 0
      bind = $mod CTRL, up, resizeactive, 0 -20
      bind = $mod CTRL, down, resizeactive, 0 20
      bind = $mod CTRL, h, resizeactive, -20 0
      bind = $mod CTRL, l, resizeactive, 20 0
      bind = $mod CTRL, k, resizeactive, 0 -20
      bind = $mod CTRL, j, resizeactive, 0 20

      # Applications
      bind = $mod, F, exec, brave
      bind = $mod, return, exec, kitty
      bind = , Print, exec, grimblast copy area

      # Audio controls
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      # Lock screen
      bind = $mod, L, exec, loginctl lock-session

      # Walker (app launcher)
      bind = $mod, S, exec, walker

      # Workspace navigation
      bind = CTRL ALT, left, workspace, -1
      bind = CTRL ALT, right, workspace, +1

      # Workspace binds (1-9)
      ${workspaceBinds}
    '';

  in {
    imports = [
      (self + "/hyprland/conf.nix")
    ];

    environment.systemPackages = [
      # Wrapped desktop apps (config baked in)
      self'.wrapped-waybar
      self'.wrapped-hyprlock
      self'.wrapped-hypridle
      self'.wrapped-hyprpaper
      self'.wrapped-swaync
      self'.wrapped-wlogout
      # Plain packages
      pkgs.grimblast
      pkgs.walker
      pkgs.elephant
      pkgs.libnotify
      pkgs.inter
    ];

    environment.sessionVariables.EDITOR = "nvim";

    # Only hyprland.conf + screenshot.desktop remain in hjem
    # (Hyprland can't be wrapped — greetd starts it via start-hyprland)
    hjem.users.felixcool200 = {
      xdg.config.files."hypr/hyprland.conf".text = hyprlandConf;
      files.".local/share/applications/screenshot.desktop".text = ''
        [Desktop Entry]
        Name=Screenshot
        Comment=Take a screenshot of a selected area
        Exec=grimblast copy area
        Terminal=false
        Type=Application
        Categories=Utility;
      '';
    };
  };
}
