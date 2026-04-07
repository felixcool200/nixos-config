{ ... }: {
  flake.nixosModules.lsp = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      lua-language-server
      llvmPackages.clang-tools
      pyright
      nil
      rustup
      zls
    ];
  };
}
