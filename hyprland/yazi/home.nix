{ pkgs, ... }:
let
  colors = import ../colors.nix;
in
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}

