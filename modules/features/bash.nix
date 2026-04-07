{ ... }: {
  flake.nixosModules.bash = { config, ... }: {
    programs.bash.shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuildOS = "nixos-rebuild --flake ~/Documents/nixos-config#${config.networking.hostName} switch --impure --sudo";
      cleanOS = "sudo nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo journalctl --vacuum-size=50M";
      upgradeOS = "nix flake update --flake ~/Documents/nixos-config && nixos-rebuild --flake ~/Documents/nixos-config#${config.networking.hostName} switch --impure --sudo";
      minecraft = "nix develop ~/Documents/nixos-config#minecraft --command bash -c 'unset LD_LIBRARY_PATH; prismlauncher'";
    };
  };
}
