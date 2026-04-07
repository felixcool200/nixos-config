{ ... }: {
  flake.nixosModules.helix = { pkgs, ... }:
  let
    helixConfig = (pkgs.formats.toml { }).generate "config.toml" {
      theme = "dracula";
      editor = {
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  in {
    environment.systemPackages = [ pkgs.helix ];
    hjem.users.felixcool200.xdg.config.files."helix/config.toml".source = helixConfig;
  };
}
