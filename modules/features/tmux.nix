{ ... }: {
  flake.nixosModules.tmux = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.tmux ];
    hjem.users.felixcool200.xdg.config.files."tmux/tmux.conf".text = ''
      # Set prefix to Ctrl+s
      set -g prefix C-s
      unbind C-b
      bind C-s send-prefix

      # Enable mouse support
      set -g mouse on

      # Use vim-style copy mode
      # setw -g mode-keys vi

      # Split panes
      bind | split-window -h
      bind - split-window -v
    '';
  };
}
