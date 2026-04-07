{ self, ... }: {
  flake.nixosModules.lsp = { pkgs, ... }:
  let self' = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = [ self'.lsp-tools ];
  };
}
