{ pkgs, ... }:
let
  colors = import ../colors.nix;
in

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
          "wlr/taskbar"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "network"
          "pulseaudio"
          "custom/nightlight"
          "custom/notification"
          "tray"
          #"hyprland/language"
          "custom/weather"
          # "hyprland/window"
          "custom/power"
        ];

        "wlr/taskbar" = {
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = [
            "foot"
          ];
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };

        "hyprland/window" = {
          max-length = 128;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#f8f8f2' size='x-large'><b>{}</b></span>";
              days = "<span color='#6272a4' size='large'>{}</span>";
              weeks = "<span color='#8be9fd' size='large'><b>W{}</b></span>";
              weekdays = "<span color='#bd93f9' size='large'><b>{}</b></span>";
              today = "<span color='#ff79c6' size='x-large'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
          interval = 1;
        };

        tray = {
          spacing = 4;
          icon-size = 16;
          show-passive-items = true;
        };

        "custom/weather" = {
          exec = pkgs.writeShellScript "weather-script" ''
            LOCATION="Stockholm"
            req=$(${pkgs.coreutils}/bin/timeout 10 ${pkgs.curl}/bin/curl -s "wttr.in/$LOCATION?format=%t|%l+(%c%f)+%h,+%C" 2>/dev/null)

            if [ $? -ne 0 ] || [ -z "$req" ]; then
                echo '{"text":"🌐 --°", "tooltip":"Weather data unavailable"}'
                exit 0
            fi

            bar=$(echo "$req" | ${pkgs.gawk}/bin/awk -F "|" '{print $1}')
            tooltip=$(echo "$req" | ${pkgs.gawk}/bin/awk -F "|" '{print $2}')

            if [ -n "$bar" ] && [ -n "$tooltip" ]; then
                echo "{\"text\":\"🌤️ $bar\", \"tooltip\":\"$tooltip\"}"
            else
                echo '{"text":"🌐 --°", "tooltip":"Weather data unavailable"}'
            fi
          '';
          return-type = "json";
          format = "{}";
          tooltip = true;
          interval = 900;
        };

        #"hyprland/language" = {
        # format-se = "[se]";
        # format-en = "[us]";
        # on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
        #};

        network = {
          interval = 5;
          format-wifi = "󰖩 {signalStrength}%";
          format-ethernet = "󰈀 Connected";
          format-linked = "󰈁 No IP";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "󰖩 {essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
          tooltip-format-ethernet = "󰈀 {ifname}\n{ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
          #on-click = "nm-connection-editor";
          #on-click-right = "nmcli device wifi rescan";
        };

        pulseaudio = {
          format = " {volume}%";
          format-muted = " Muted";
          format-bluetooth = " {volume}%";
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          scroll-step = 5;
          tooltip = true;
          tooltip-format = "{desc} {volume}%";
        };

        "custom/nightlight" = {
          format = "{}";
          exec = pkgs.writeShellScript "nightlight-status" ''
            # Check if night mode file exists
            if [ -f /tmp/hypr_night_mode ]; then
              echo "🌙"  # Night mode
            else
              echo "☀️"  # Day mode
            fi
          '';
          on-click = pkgs.writeShellScript "nightlight-toggle" ''
            # Toggle between normal and night mode using blue light shader
            if [ -f /tmp/hypr_night_mode ]; then
              # Switch to day mode
              hyprctl keyword decoration:screen_shader ""
              rm -f /tmp/hypr_night_mode
            else
              # Switch to night mode - apply blue light filter shader
              hyprctl keyword decoration:screen_shader "/home/felixcool200/Documents/nixos-config/hyprland/shaders/blue-light-filter.glsl"
              touch /tmp/hypr_night_mode
            fi
          '';
          interval = 2;
          tooltip = true;
          tooltip-format = "🌙 Night Mode | ☀️ Day Mode";
        };

        "custom/power" = {
          format = "⏻";
          on-click = "wlogout";
          tooltip = false;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "🔔";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "🔕";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "🔔";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "🔕";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
    };

    style = ''
      @define-color background-darker ${colors.backgroundDarker};
      @define-color background ${colors.background};
      @define-color selection ${colors.currentLine};
      @define-color foreground ${colors.foreground};
      @define-color comment ${colors.comment};
      @define-color cyan ${colors.cyan};
      @define-color green ${colors.green};
      @define-color orange ${colors.orange};
      @define-color pink ${colors.pink};
      @define-color purple ${colors.purple};
      @define-color red ${colors.red};
      @define-color yellow ${colors.yellow};

      ${builtins.readFile ./style.css}
    '';
  };

}
