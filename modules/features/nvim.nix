{ self, ... }: {
  flake.nixosModules.nvim = { pkgs, ... }:
  let self' = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = [ self'.wrapped-nvim ];
    hjem.users.felixcool200.xdg.config.files."nvim/init.lua".source = self + "/modules/features/nvim/init.lua";
  };
}
