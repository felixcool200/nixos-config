{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    settings = {
      tabstop = 4; # Set tab width to 4 spaces
      shiftwidth = 4; # Indentation width to 4 spaces
      expandtab = true; # Convert tabs to spaces
    };
  };
}