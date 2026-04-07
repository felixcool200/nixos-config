{ self, ... }: {
  flake.nixosModules.vim = { pkgs, ... }:
  let self' = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = [ self'.wrapped-vim ];
  };
}
