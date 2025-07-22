{ pkgs, lib, ... }:
{
  # Use greetd with tuigreet instead of SDDM
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.concatStringsSep " " [
          "${pkgs.greetd.tuigreet}/bin/tuigreet"
          "--time"
          "--cmd Hyprland"
          "--asterisks"
          "--theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'"
        ];
        user = "greeter";
      };
    };
  };
}
