{ self, inputs, ... }: {
  flake.nixosModules.gnome = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.systemdBootVmHome
      (self + "/gnome/conf.nix")
    ];

    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.felixcool200.imports = [
      (self + "/gnome/home.nix")
    ];
  };
}
