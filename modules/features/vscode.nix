{ self, ... }: {
  flake.nixosModules.vscode = { pkgs, ... }:
  let self' = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = [ self'.wrapped-vscode ];
  };
}
