{ ... }: {
  flake.nixosModules.vim = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vim ];
    hjem.users.felixcool200.files.".vimrc".text = ''
      set tabstop=4
      set shiftwidth=4
      set expandtab
    '';
  };
}
