{ ... }: {
  flake.nixosModules.ghostty = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ghostty ];
    hjem.users.felixcool200.xdg.config.files."ghostty/config".text = ''
      theme = Dracula
      # theme = CyberpunkScarletProtocol
      #custom-shader = ~/Documents/nixos-config/ghostty/ghostty-shaders/in-game-crt.glsl
    '';
    environment.sessionVariables.TERMINAL = "ghostty";
  };
}
