{ config, pkgs, ... }:

{
  imports = [
    ./nvim/home.nix
    ./tmux/home.nix
    ./vim/home.nix
    ./ghostty/home.nix
    ./minecraft/home.nix
    ./vscode/home.nix
    ./brave/home.nix
    ./spotify/home.nix
    ./discord/home.nix
  ];
}