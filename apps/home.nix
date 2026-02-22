{ config, pkgs, ... }:

{
  imports = [
    ./bash/home.nix
    ./git/home.nix
    ./fonts/home.nix
    ./lsp/home.nix
    ./ai/home.nix
    ./nvim/home.nix
    ./tmux/home.nix
    ./vim/home.nix
    ./ghostty/home.nix
    ./minecraft/home.nix
    ./vscode/home.nix
    ./brave/home.nix
    ./helix/home.nix
    ./spotify/home.nix
    ./discord/home.nix
  ];
}
