{ self, inputs, ... }: {
  flake.nixosConfigurations.systemd-boot-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hostSystemdBootVm ];
  };

  flake.nixosModules.hostSystemdBootVm = { ... }: {
    imports = [
      /etc/nixos/hardware-configuration.nix
      self.nixosModules.common
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "systemd-boot-vm";
  };
}
