{ ... }: {
  flake.nixosModules.vscode = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          bbenoist.nix
          ms-python.python
          ms-vscode.cpptools
          ziglang.vscode-zig
        ];
      })
    ];
  };
}
