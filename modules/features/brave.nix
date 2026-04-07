{ ... }: {
  flake.nixosModules.brave = { pkgs, lib, ... }:
  let
    extensionPolicy = builtins.toJSON {
      ExtensionInstallForcelist = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx" # ublock origin
        "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx" # bitwarden
      ];
    };
  in {
    environment.systemPackages = [ pkgs.brave ];

    # Brave browser policies for extensions
    environment.etc."brave/policies/managed/extensions.json".text = extensionPolicy;

    # Command-line flags for brave
    hjem.users.felixcool200.xdg.config.files."brave-flags.conf".text = ''
      --disable-features=WebRtcAllowInputVolumeAdjustment
      --enable-extensions
    '';
  };
}
