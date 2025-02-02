{ config, pkgs, lib, ... }:

let
  repoUrl = "https://github.com/YOUR-USERNAME/YOUR-REPO.git";
  configPath = "/run/raspotify-config";  # Uses RAM instead of SD card
  configFile = "${configPath}/raspotify.conf";
in
{
  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    # Add your public SSH key here
    authorizedKeys = {
      # This will add the key for the user `root`, you can change the username if needed.
      root = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+lV5lXrnUyT7PJ4HKlBp9Sj+HTTcag6c7CBGXQH5Mk6LCAnGnpy29dbKe8BVTgFAECBPWIQPlc4Z2BKqVkfwPMWxfRBo+pLRkZzNNbHoIGIUoggZy28XjoebL941T6Hhxb6ynYJChWIy0tIGkk1l/UqeByjV63GRASzPHXiKDFqf9ALSQk1vyI5Wq3IWPjG6lij3rPXOdAiVHSWAM/L7QMA5GciggNPDfJb06ZM6hat1itw5WritbXQUVbw5dfDGgkZ3LwPHjpQIVAjYF8woRIE0on1AeOOkVVnN8t2smSF+1lu041q3FHLEgkWaJhkGnoxowf2vlkSN1yajETIvR"
      ];
    };
  };

  # Enable WireGuard VPN server
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.100.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/private.key";
      peers = [
        {
          publicKey = "MdeKkejpnFnAS0u+C8vFtr98CBeTrRlo9VlDDjdAhCs=";
          allowedIPs = [ "0.0.0.0/0" ];
        }
      ];
    };
  };

  # Enable Raspotify
  services.raspotify = {
    enable = true;
    extraArgs = "--config ${configFile}";
  };

  hardware.pulseaudio.enable = true;  # Enable audio output

  environment.systemPackages = with pkgs; [ git wireguard-tools ];

  systemd.tmpfiles.rules = [
    "d '${configPath}' 0755 raspotify raspotify - -"  # Ensure directory exists with correct ownership
  ];

  systemd.services.fetch-raspotify-config = {
    description = "Fetch Raspotify Config from GitHub";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "raspotify.service" ];  # Ensure it runs before raspotify starts
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        if [ ! -d "${configPath}/.git" ]; then
          git clone --depth 1 ${repoUrl} ${configPath}
        else
          git -C ${configPath} pull
        fi
        chown -R raspotify:raspotify ${configPath}
      '';
      User = "raspotify";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
