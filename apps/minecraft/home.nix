{ config, pkgs, ... }:

{
  programs.bash.shellAliases = {
    minecraft = "nix-shell ${toString ./shell.nix} --run 'unset LD_LIBRARY_PATH; prismlauncher'";
  };
}