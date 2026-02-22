{ pkgs, lib, ... }:
{
  # Use greetd with tuigreet instead of SDDM
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--cmd start-hyprland"
          "--asterisks"
          "--remember"
          "--theme 'time=lightmagenta;container=darkgray;border=magenta;title=magenta;greet=lightcyan;prompt=lightmagenta;input=lightgray;action=lightblue;button=yellow;text=white'"
        ];
        user = "greeter";
      };
    };
  };
}
