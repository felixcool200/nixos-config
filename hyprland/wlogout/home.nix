{ config, pkgs, ... }:

{
  programs.wlogout = {
    enable = true;
    
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    
    style = ''
      * {
          background-image: none;
      }
      window {
          background-color: rgba(40, 42, 54, 0.9);
      }
      button {
          color: #F8F8F2;
          background-color: #44475A;
          border-style: solid;
          border-width: 2px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          margin: 5px;
          border-radius: 10px;
      }

      button:focus, button:active, button:hover {
          background-color: #6272A4;
          outline-style: none;
      }

      #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
    '';
  };
}