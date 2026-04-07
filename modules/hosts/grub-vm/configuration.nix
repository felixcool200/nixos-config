{ self, inputs, ... }: {
  flake.nixosConfigurations.grub-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hostGrubVm ];
  };

  flake.nixosModules.hostGrubVm = { ... }: {
    imports = [
      /etc/nixos/hardware-configuration.nix
      self.nixosModules.common
    ];

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";

    networking.hostName = "grub-vm";
  };
}
