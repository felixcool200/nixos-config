{ ... }: {

  flake.nixosModules.systemdBootVmHome = { ... }: {
    home-manager.users.felixcool200 = {
      home.username = "felixcool200";
      home.homeDirectory = "/home/felixcool200";
      home.stateVersion = "25.05";
      programs.home-manager.enable = true;
    };
  };

}
