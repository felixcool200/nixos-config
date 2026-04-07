{ ... }: {
  flake.nixosModules.yazi = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.yazi ];

    # Shell wrapper that changes directory on exit (equivalent to HM enableBashIntegration)
    programs.bash.interactiveShellInit = ''
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };
}
