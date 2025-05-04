{ config, pkgs, lib, ... }:

{
  # Nerd font for nvim config
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    # LSP
    lua-language-server
    llvmPackages.clang-tools
  ];

  # Install Neovim
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    # Set Neovim to use the Lua config file
    #extraConfig = lib.fileContents ./neovim.lua;
    extraLuaConfig = lib.fileContents ./neovim.lua;
    # Install necessary LSP servers and tools
    #extraPackages = with pkgs; [
    #  llvmPackages.clang-unwrapped
    #];
  };
}

