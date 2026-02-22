# Hyprlock configuration - Dracula themed
let
  colors = import ../colors.nix;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        immediate_render = true;
      };

      # Smooth animations with bezier curves
      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
        ];
        animation = [
          "fadeIn, 1, 3, easeOutQuint"
          "fadeOut, 1, 3, easeInOutCubic"
          "inputFieldDots, 1, 2, easeInOutCubic"
          "inputFieldColors, 1, 1, easeInOutCubic"
        ];
      };

      background = [
        {
          # Using solid color instead of screenshot to avoid crash
          # path = "screenshot";
          path = "";
          color = "rgb(${colors.backgroundRgb})";
          blur_passes = 0;
          blur_size = 0;

        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(${colors.foregroundRgb})";
          inner_color = "rgb(${colors.backgroundRgb})";
          outer_color = "rgb(${colors.purpleRgb})";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2; # 0 -
          fail_timeout = 100; # milliseconds (default: 2000)
          fail_transition = 15; # milliseconds (default: 300)
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "rgb(${colors.foregroundRgb})";
          font_size = 55;
          font_family = "Monospace";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          text = "Hi there, $USER";
          color = "rgb(${colors.purpleRgb})";
          font_size = 20;
          font_family = "Monospace";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hypridle configuration
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300; # 5 minutes
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600; # 10 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod, L, exec, loginctl lock-session"
    ];
  };
}
