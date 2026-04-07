{ self, inputs, ... }: {
  flake.nixosModules.hyprland = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.systemdBootVmHome
      (self + "/hyprland/conf.nix")
    ];

    home-manager.backupFileExtension = "backup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.felixcool200.imports = [
      (self + "/hyprland/home.nix")
      (self + "/apps/walker/home.nix")
    ];
  };
}
