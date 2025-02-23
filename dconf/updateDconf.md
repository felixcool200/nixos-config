## Update dconf
Run dconf2nix to convert the current dconf to a nixfile

    dconf dump / > dconf-settings.dconf
    nix run nixpkgs#dconf2nix -- -i dconf-settings.dconf -o dconf.nix
    git add  dconf-settings.dconf dconf.nix
    git commit -m "Updated dconf"
    git push