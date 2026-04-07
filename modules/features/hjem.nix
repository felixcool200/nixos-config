{ inputs, ... }: {
  flake.nixosModules.hjem = { ... }: {
    imports = [ inputs.hjem.nixosModules.default ];
    hjem.clobberByDefault = true;
    hjem.users.felixcool200.enable = true;
  };
}
