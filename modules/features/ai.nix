{ ... }: {
  flake.nixosModules.ai = { pkgs, ... }: {
    environment.systemPackages = [
      #pkgs.gemini-cli
      pkgs.claude-code
    ];
  };
}
