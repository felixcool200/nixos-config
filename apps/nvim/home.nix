{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Extra packages for config
    #luajit
    #luajitPackages.luarocks
    lua5_1
    lua51Packages.luarocks
    tree-sitter
    nodejs # Optional: for some treesitter grammars
    fd # Optional: for Telescope warnings
  ];

  # Install Neovim
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    # Set Neovim to use the Lua config file
    #extraConfig = lib.fileContents ./neovim.lua;
    initLua = lib.fileContents ./init.lua;
    # Install necessary LSP servers and tools
    #extraPackages = with pkgs; [
    #  llvmPackages.clang-unwrapped
    #];
  };
}
