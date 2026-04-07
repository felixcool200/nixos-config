{ self, ... }: {
  flake.nixosModules.tmux = { pkgs, ... }:
  let self' = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = [ self'.wrapped-tmux ];
  };
}
