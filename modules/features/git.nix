{ ... }: {
  flake.nixosModules.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      config = {
        user.name = "Felix Söderman";
        user.email = "felixsoderman+github@gmail.com";
      };
    };
  };
}
