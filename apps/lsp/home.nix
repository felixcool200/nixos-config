{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lua-language-server
    llvmPackages.clang-tools
    pyright
    nil
    rustup
    zls
  ];
}
