{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Dracula";
      # theme = "CyberpunkScarletProtocol";
      # custom-shader = "~/Documents/nixos-config/ghostty/ghostty-shaders/in-game-crt.glsl";
    };
  };

  home.sessionVariables = {
    TERMINAL = lib.mkForce "ghostty";
  };
}