{ ... }: {
  flake.nixosModules.ghostty = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ghostty ];
    hjem.users.felixcool200.xdg.config.files."ghostty/config".text = ''
      theme = Dracula
      custom-shader = ~/Documents/nixos-config/ghostty/shaders/cursor_tail.glsl
    '';
    environment.sessionVariables.TERMINAL = "ghostty";
  };
}
