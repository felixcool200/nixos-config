{ self, inputs, ... }: {
  flake.nixosConfigurations.systemd-boot-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.systemdBootVmConfiguration
    ];
  };
}
