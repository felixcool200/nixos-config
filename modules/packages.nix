{ self, inputs, ... }: {
  perSystem = { system, ... }: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    wrap = inputs.wrappers.lib.wrapPackage;
    colors = import (self + "/hyprland/colors.nix");
  in {
    packages = {

      # ── Editor / terminal wrappers ──────────────────────────────

      wrapped-helix = let
        config = (pkgs.formats.toml { }).generate "config.toml" {
          theme = "dracula";
          editor.cursor-shape = { insert = "bar"; normal = "block"; select = "underline"; };
        };
      in wrap {
        inherit pkgs;
        package = pkgs.helix;
        flags."--config" = "${config}";
      };

      wrapped-tmux = let
        config = pkgs.writeText "tmux.conf" ''
          # Set prefix to Ctrl+s
          set -g prefix C-s
          unbind C-b
          bind C-s send-prefix

          # Enable mouse support
          set -g mouse on

          # Split panes
          bind | split-window -h
          bind - split-window -v
        '';
      in wrap {
        inherit pkgs;
        package = pkgs.tmux;
        flags."-f" = "${config}";
      };

      wrapped-vim = let
        config = pkgs.writeText "vimrc" ''
          set tabstop=4
          set shiftwidth=4
          set expandtab
        '';
      in wrap {
        inherit pkgs;
        package = pkgs.vim;
        flags."-u" = "${config}";
      };

      wrapped-nvim = wrap {
        inherit pkgs;
        package = pkgs.neovim;
        runtimeInputs = with pkgs; [ lua5_1 lua51Packages.luarocks tree-sitter nodejs fd ];
      };

      wrapped-vscode = pkgs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          bbenoist.nix
          ms-python.python
          ms-vscode.cpptools
          ziglang.vscode-zig
        ];
      };

      # ── Tool bundles ────────────────────────────────────────────

      lsp-tools = pkgs.symlinkJoin {
        name = "lsp-tools";
        paths = with pkgs; [ lua-language-server llvmPackages.clang-tools pyright nil rustup zls ];
      };

      ai-tools = pkgs.symlinkJoin {
        name = "ai-tools";
        paths = [ pkgs.claude-code ];
      };

      # ── Hyprland desktop wrappers ──────────────────────────────

      wrapped-waybar = let
        weatherScript = pkgs.writeShellScript "weather-script" ''
          LOCATION="Stockholm"
          req=$(${pkgs.coreutils}/bin/timeout 10 ${pkgs.curl}/bin/curl -s "wttr.in/$LOCATION?format=%t|%l+(%c%f)+%h,+%C" 2>/dev/null)

          if [ $? -ne 0 ] || [ -z "$req" ]; then
              echo '{"text":"󰖟 --°", "tooltip":"Weather data unavailable"}'
              exit 0
          fi

          bar=$(echo "$req" | ${pkgs.gawk}/bin/awk -F "|" '{print $1}')
          tooltip=$(echo "$req" | ${pkgs.gawk}/bin/awk -F "|" '{print $2}')

          if [ -n "$bar" ] && [ -n "$tooltip" ]; then
              echo "{\"text\":\"󰖙 $bar\", \"tooltip\":\"$tooltip\"}"
          else
              echo '{"text":"󰖟 --°", "tooltip":"Weather data unavailable"}'
          fi
        '';

        nightlightStatus = pkgs.writeShellScript "nightlight-status" ''
          if ${pkgs.procps}/bin/pgrep -x hyprsunset > /dev/null; then
            echo "󰖔"
          else
            echo "󰖙"
          fi
        '';

        nightlightToggle = pkgs.writeShellScript "nightlight-toggle" ''
          if ${pkgs.procps}/bin/pgrep -x hyprsunset > /dev/null; then
            ${pkgs.procps}/bin/pkill -x hyprsunset
          else
            ${pkgs.hyprsunset}/bin/hyprsunset -t 2600 &
          fi
        '';

        config = pkgs.writeText "waybar-config" (builtins.toJSON {
          layer = "top"; position = "top"; height = 38; spacing = 4;
          margin-top = 6; margin-left = 10; margin-right = 10;
          modules-left = [ "hyprland/workspaces" "wlr/taskbar" ];
          modules-center = [ "clock" ];
          modules-right = [
            "network" "pulseaudio" "custom/nightlight"
            "custom/notification" "tray" "custom/weather" "custom/power"
          ];
          "wlr/taskbar" = { on-click = "activate"; on-click-middle = "close"; ignore-list = [ "foot" ]; };
          "hyprland/workspaces" = { on-click = "activate"; on-scroll-up = "hyprctl dispatch workspace e-1"; on-scroll-down = "hyprctl dispatch workspace e+1"; };
          "hyprland/window".max-length = 128;
          clock = {
            format = "{:%Y-%m-%d  %H:%M:%S}"; tooltip = true;
            tooltip-format = "<big><b>{:%A %B %d, %Y}</b></big>\n\n<tt>{calendar}</tt>";
            calendar = {
              mode = "month"; weeks-pos = "right"; on-scroll = 1;
              format = {
                months = "<span color='${colors.purple}' size='large'><b>{}</b></span>";
                days = "<span color='${colors.comment}'>{}</span>";
                weeks = "<span color='${colors.cyan}'><b>W{}</b></span>";
                weekdays = "<span color='${colors.foreground}'><b>{}</b></span>";
                today = "<span color='${colors.pink}'><b><u>{}</u></b></span>";
              };
            };
            actions = { on-scroll-up = "shift_up"; on-scroll-down = "shift_down"; };
            interval = 1;
          };
          tray = { spacing = 4; icon-size = 16; show-passive-items = true; };
          "custom/weather" = { exec = "${weatherScript}"; return-type = "json"; format = "{}"; tooltip = true; interval = 900; };
          network = {
            interval = 5;
            format-wifi = "󰖩 {signalStrength}%"; format-ethernet = "󰈀 Connected";
            format-linked = "󰈁 No IP"; format-disconnected = "󰖪 Disconnected";
            format-alt = "{ifname}: {ipaddr}/{cidr}"; tooltip-format = "{ifname} via {gwaddr}";
            tooltip-format-wifi = "󰖩 {essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
            tooltip-format-ethernet = "󰈀 {ifname}\n{ipaddr}/{cidr}"; tooltip-format-disconnected = "Disconnected";
          };
          pulseaudio = {
            format = " {volume}%"; format-muted = " Muted"; format-bluetooth = " {volume}%";
            on-click = "pavucontrol"; on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
            scroll-step = 5; tooltip = true; tooltip-format = "{desc} {volume}%";
          };
          "custom/nightlight" = { format = "{}"; exec = "${nightlightStatus}"; on-click = "${nightlightToggle}"; interval = 2; tooltip = true; tooltip-format = "Toggle night light"; };
          "custom/power" = { format = "󰐥"; on-click = "wlogout"; tooltip = false; };
          "custom/notification" = {
            tooltip = false; format = "{icon}";
            format-icons = {
              notification = "󰂞"; none = "󰂚"; dnd-notification = "󰂛"; dnd-none = "󰂛";
              inhibited-notification = "󰂞"; inhibited-none = "󰂚";
              dnd-inhibited-notification = "󰂛"; dnd-inhibited-none = "󰂛";
            };
            return-type = "json"; exec-if = "which swaync-client"; exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw"; on-click-right = "swaync-client -d -sw"; escape = true;
          };
        });

        style = pkgs.writeText "waybar-style.css" ''
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

          ${builtins.readFile (self + "/hyprland/waybar/style.css")}
        '';
      in wrap {
        inherit pkgs;
        package = pkgs.waybar;
        flags = { "--config" = "${config}"; "--style" = "${style}"; };
      };

      wrapped-hyprlock = let
        config = pkgs.writeText "hyprlock.conf" ''
          general {
              hide_cursor = true
              immediate_render = true
          }
          animations {
              enabled = true
              bezier = easeOutQuint, 0.23, 1, 0.32, 1
              bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
              bezier = linear, 0, 0, 1, 1
              animation = fadeIn, 1, 3, easeOutQuint
              animation = fadeOut, 1, 3, easeInOutCubic
              animation = inputFieldDots, 1, 2, easeInOutCubic
              animation = inputFieldColors, 1, 1, easeInOutCubic
          }
          background {
              path =
              color = rgb(${colors.backgroundRgb})
              blur_passes = 0
              blur_size = 0
          }
          input-field {
              size = 200, 50
              position = 0, -80
              monitor =
              dots_center = true
              fade_on_empty = false
              font_color = rgb(${colors.foregroundRgb})
              inner_color = rgb(${colors.backgroundRgb})
              outer_color = rgb(${colors.purpleRgb})
              outline_thickness = 5
              placeholder_text = Password...
              shadow_passes = 2
              fail_timeout = 100
              fail_transition = 15
          }
          label {
              text = $TIME
              color = rgb(${colors.foregroundRgb})
              font_size = 55
              font_family = Monospace
              position = 0, 80
              halign = center
              valign = center
          }
          label {
              text = Hi there, $USER
              color = rgb(${colors.purpleRgb})
              font_size = 20
              font_family = Monospace
              position = 0, 0
              halign = center
              valign = center
          }
        '';
      in wrap {
        inherit pkgs;
        package = pkgs.hyprlock;
        flags."--config" = "${config}";
      };

      wrapped-hypridle = let
        config = pkgs.writeText "hypridle.conf" ''
          general {
              lock_cmd = pidof hyprlock || hyprlock
              before_sleep_cmd = loginctl lock-session
              after_sleep_cmd = hyprctl dispatch dpms on
          }
          listener {
              timeout = 300
              on-timeout = loginctl lock-session
          }
          listener {
              timeout = 600
              on-timeout = hyprctl dispatch dpms off
              on-resume = hyprctl dispatch dpms on
          }
        '';
      in wrap {
        inherit pkgs;
        package = pkgs.hypridle;
        flags."--config" = "${config}";
      };

      wrapped-hyprpaper = let
        config = pkgs.writeText "hyprpaper.conf" ''
          ipc = on
          splash = false
          preload = /home/felixcool200/Documents/nixos-config/backgrounds/gnome-map-d.png
          wallpaper = ,/home/felixcool200/Documents/nixos-config/backgrounds/gnome-map-d.png
        '';
      in wrap {
        inherit pkgs;
        package = pkgs.hyprpaper;
        flags."--config" = "${config}";
      };

      # swaync: writeShellScriptBin — wrapPackage would also wrap
      # swaync-client with daemon flags, breaking it
      wrapped-swaync = let
        config = pkgs.writeText "swaync-config.json" (builtins.toJSON {
          positionX = "right"; positionY = "top";
          control-center-margin-top = 10; control-center-margin-bottom = 10;
          control-center-margin-right = 10; control-center-margin-left = 10;
          control-center-width = 400;
          notification-2fa-action = false; notification-inline-replies = false;
          notification-icon-size = 48;
          notification-body-image-height = 100; notification-body-image-width = 200;
          timeout = 10; timeout-low = 5; timeout-critical = 0;
          widgets = [ "title" "dnd" "notifications" ];
          widget-config = {
            title = { text = "Notifications"; clear-all-button = true; button-text = "Clear All"; };
            dnd = { text = "Do Not Disturb"; };
          };
          categories.spotify.timeout = 5;
          notification-visibility.spotify = { state = "transient"; urgency = "Low"; app-name = "Spotify"; };
        });
        style = pkgs.writeText "swaync-style.css" ''
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

          ${builtins.readFile (self + "/hyprland/swaync/style.css")}
        '';
        wrapper = pkgs.writeShellScriptBin "swaync" ''
          exec ${pkgs.swaynotificationcenter}/bin/swaync --config ${config} --style ${style} "$@"
        '';
      in pkgs.symlinkJoin {
        name = "wrapped-swaync";
        paths = [ wrapper pkgs.swaynotificationcenter ];
      };

      wrapped-wlogout = let
        layoutEntries = [
          { label = "lock"; action = "hyprlock"; text = "Lock"; keybind = "l"; }
          { label = "hibernate"; action = "systemctl hibernate"; text = "Hibernate"; keybind = "h"; }
          { label = "logout"; action = "hyprctl dispatch exit"; text = "Logout"; keybind = "e"; }
          { label = "shutdown"; action = "systemctl poweroff"; text = "Shutdown"; keybind = "s"; }
          { label = "suspend"; action = "systemctl suspend"; text = "Suspend"; keybind = "u"; }
          { label = "reboot"; action = "systemctl reboot"; text = "Reboot"; keybind = "r"; }
        ];
        layout = pkgs.writeText "wlogout-layout"
          (builtins.concatStringsSep "\n" (map builtins.toJSON layoutEntries));
        css = pkgs.writeText "wlogout-style.css" ''
          * { background-image: none; }
          window { background-color: rgba(40, 42, 54, 0.9); }
          button {
              color: #F8F8F2; background-color: #44475A;
              border-style: solid; border-width: 2px;
              background-repeat: no-repeat; background-position: center; background-size: 25%;
              margin: 5px; border-radius: 10px;
          }
          button:focus, button:active, button:hover { background-color: #6272A4; outline-style: none; }
          #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
          #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
          #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
          #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }
          #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
          #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
        '';
      in wrap {
        inherit pkgs;
        package = pkgs.wlogout;
        flags = { "--layout" = "${layout}"; "--css" = "${css}"; };
      };

    };
  };
}
