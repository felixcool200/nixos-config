{ config, pkgs, ... }:

{
  # SwayNotificationCenter configuration
  services.swaync = {
    enable = true;

    settings = {
      # Position and layout
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";

      # Control center settings
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 0;
      control-center-width = 400;
      control-center-height = 600;

      # Notification settings
      notification-2fa-action = true;
      notification-inline-replies = true;
      notification-icon-size = 48;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-window-width = 400;

      # Timing
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      # Behavior
      fit-to-screen = true;
      relative-timestamps = true;
      newest-first = true;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;

      # Keyboard shortcuts
      keyboard-shortcuts = true;

      # Widgets configuration
      widgets = [
        "title"
        "dnd"
        "notifications"
        "mpris"
        "volume"
        "brightness"
        "buttons-grid"
      ];

      # Widget settings
      widget-config = {
        title = {
          text = "Notification Center";
          clear-all-button = true;
          button-text = "Clear All";
        };

        dnd = {
          text = "Do Not Disturb";
        };

        mpris = {
          image-size = 64;
          image-radius = 8;
          blur = false;
        };

        volume = {
          label = "Volume";
          show-per-app = false;
          expand-button = false;
        };

        brightness = {
          label = "Brightness";
          min = 0;
          max = 100;
        };

        buttons-grid = {
          actions = [
            {
              label = "󰖩";
              command = "nm-connection-editor";
              tooltip = "Network Settings";
            }
            {
              label = "󰂯";
              command = "blueman-manager";
              tooltip = "Bluetooth Settings";
            }
            {
              label = "󰕾";
              command = "pavucontrol";
              tooltip = "Audio Settings";
            }
            {
              label = "󰍹";
              command = "wdisplays";
              tooltip = "Display Settings";
            }
            {
              label = "󰌾";
              command = "hyprlock";
              tooltip = "Lock Screen";
            }
            {
              label = "⏻";
              command = "wlogout";
              tooltip = "Power Menu";
            }
          ];
        };
      };

      # Categories
      categories = {
        "email" = {
          timeout = 0;
          urgency = "Normal";
        };
        "im" = {
          timeout = 10;
          urgency = "Normal";
          script = null;
        };
        "network" = {
          timeout = 5;
          urgency = "Normal";
        };
        "volume" = {
          timeout = 3;
          urgency = "Low";
        };
        "battery" = {
          timeout = 0;
          urgency = "Critical";
        };
      };

      # Notification visibility
      notification-visibility = {
        "spotify" = {
          state = "muted";
          urgency = "Low";
          app-name = "Spotify";
        };
        "discord" = {
          state = "enabled";
          urgency = "Normal";
          app-name = "discord";
        };
      };

      # Scripts
      scripts = {
        example-script = {
          exec = "echo 'Example notification script'";
          urgency = "Normal";
          run-on = "action";
        };
      };
    };

    # Custom CSS styling
    style = builtins.readFile ./style.css;
  };

  # Install required packages
  home.packages = with pkgs; [
    swaynotificationcenter
    libnotify # For notify-send
    # For button actions
    networkmanagerapplet
    blueman
    pavucontrol
    wdisplays
  ];

  # The swaync service is automatically managed by the services.swaync module
  # No need to define it manually
}
