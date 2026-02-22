{ ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuildOS = "nixos-rebuild --flake ~/Documents/nixos-config switch --impure --sudo";
      cleanOS = "sudo nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system && nix-env --delete-generations +2 --profile ~/.local/state/nix/profiles/home-manager && sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo journalctl --vacuum-size=50M";
      upgradeOS = "nix flake update --flake ~/Documents/nixos-config && nixos-rebuild --flake ~/Documents/nixos-config switch --impure --sudo";
    };
  };
}
