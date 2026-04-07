{ self, ... }: {
  flake.nixosModules.wireshark = { ... }: {
    imports = [
      (self + "/apps/wireshark/conf.nix")
    ];
  };
}
