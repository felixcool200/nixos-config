{
  config,
  lib,
  pkgs,
  ...
}:

let
  colors = import ../colors.nix;
in
{
  services.swaync = {
    enable = true;
    settings = {
      # Basic positioning
      positionX = "right";
      positionY = "top";

      # Control center dimensions
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      control-center-width = 400;

      # Notification behavior
      notification-2fa-action = false;
      notification-inline-replies = false;
      notification-icon-size = 48;
      notification-body-image-height = 100;
      notification-body-image-width = 200;

      # Timeouts
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      # Simple widgets - title, dnd button, and notifications
      widgets = [
        "title"
        "dnd"
        "notifications"
      ];

      # Widget configuration
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };

      # Categories
      categories = {
        spotify = {
          timeout = 5;
        };
      };

      # Visibility
      notification-visibility = {
        spotify = {
          state = "transient";
          urgency = "Low";
          app-name = "Spotify";
        };
      };
    };

    # Apply simple CSS style with color variables
    style = ''
      @define-color background ${colors.background};
      @define-color currentLine ${colors.currentLine};
      @define-color foreground ${colors.foreground};
      @define-color comment ${colors.comment};
      @define-color cyan ${colors.cyan};
      @define-color green ${colors.green};
      @define-color orange ${colors.orange};
      @define-color pink ${colors.pink};
      @define-color purple ${colors.purple};
      @define-color red ${colors.red};
      @define-color yellow ${colors.yellow};

      ${builtins.readFile ./style_simple.css}
    '';
  };

  # Required packages
  home.packages = with pkgs; [
    swaynotificationcenter
    libnotify
  ];
}

