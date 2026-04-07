{ self, ... }: {
  flake.nixosModules.ai = { pkgs, ... }:
  let self' = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = [ self'.ai-tools ];
  };
}
