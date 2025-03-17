{ config, pkgs, lib, ... }:

{
  # Install Neovim
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    # Set Neovim to use the Lua config file
    extraConfig = lib.fileContents ./neovim.lua;

    # Install necessary LSP servers and tools
    extraPackages = with pkgs; [
      llvmPackages.clang-unwrapped  # Correct way to install clangd
    ];
  };
}

