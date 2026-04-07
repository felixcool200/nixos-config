{ self, ... }: {
  flake.nixosModules.nvim = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      neovim
      lua5_1
      lua51Packages.luarocks
      tree-sitter
      nodejs
      fd
    ];
    hjem.users.felixcool200.xdg.config.files."nvim/init.lua".source = self + "/apps/nvim/init.lua";
  };
}
