{
  # Hyprlock configuration - Dracula themed
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          # Using solid color instead of screenshot to avoid crash
          # path = "screenshot";
          path = "";
          color = "rgb(40, 42, 54)"; # Dracula background color
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(f8f8f2)";
          inner_color = "rgb(282a36)";
          outer_color = "rgb(bd93f9)";
          outline_thickness = 5;
          placeholder_text = "<span foreground='##f8f8f2'>Password...</span>";
          shadow_passes = 2;
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "rgb(f8f8f2)";
          font_size = 55;
          font_family = "Monospace";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          text = "Hi there, $USER";
          color = "rgb(bd93f9)";
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
