{ pkgs, config, lib, ... }: {

  environment.systemPackages = with pkgs; [
    iwgtk
  ];

  sops.secrets = {
    "wg-zw-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg-dvb-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg-hole-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
  };

  networking = {
    hostName = "kirchhoff";
    hostId = "045d0684";
    enableIPv6 = true;
    useDHCP = true;
    interfaces.enp1s0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    useNetworkd = true;

    wireguard.enable = true;

    wireless.iwd = {
      enable = true;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [ "1.1.1.1" ];
  };

  # workaround for networkd waiting for shit
  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
    "" # clear old command
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  systemd.network = {
    enable = true;

    # wait-online.ignoredInterfaces = [ "wlan0" "enp53s0" ];

    # Interfaces on the machine
    netdevs."10-james" = {
      netdevConfig = {
        Name = "james";
        Kind = "bond";
      };
      bondConfig = {
        Mode = "active-backup";
        PrimaryReselectPolicy = "always";
        MIIMonitorSec = "1s";
      };
    };
    networks."10-ether-bond" = {
      matchConfig.Name = "enp1s0";
      networkConfig = {
        Bond = "james";
        PrimarySlave = true;
      };
    };
    networks."10-wlan-bond" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        Bond = "james";
      };
    };
    networks."10-james-bond" = {
      matchConfig.Name = "james";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
        Domains = [
          "~."
        ];
      };
    };

    # Wireguard
    # Dump-dvb
    netdevs."30-wg-dumpdvb" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-dumpdvb";
        Description = "dvb.solutions enterprise network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg-dvb-seckey".path;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "WDvCObJ0WgCCZ0ORV2q4sdXblBd8pOPZBmeWr97yphY=";
            Endpoint = "academicstrokes.com:51820";
            AllowedIPs = [ "10.13.37.0/24" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."30-wg-dumpdvb" = {
      matchConfig.Name = "wg-dumpdvb";
      networkConfig = {
        Address = "10.13.37.2/24";
        IPv6AcceptRA = true;
      };
      routes = [
        { routeConfig = { Gateway = "10.13.37.1"; Destination = "10.13.37.0/24"; }; }
      ];
    };

    # shithole
    netdevs."10-wg-hole" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-hole";
        Description = "hole enterprise network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg-hole-seckey".path;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "WR3vczOpFNXm7LvQ+TBtajLsL+gKdwuiTUYUf8xm1Hg=";
            Endpoint = "88.198.121.105:51820";
            AllowedIPs = [ "10.66.66.0/24" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."10-wg-hole" = {
      matchConfig.Name = "wg-hole";
      networkConfig = {
        Address = "10.66.66.10/24";
        IPv6AcceptRA = true;
      };
      routes = [
        { routeConfig = { Gateway = "10.66.66.1"; Destination = "10.66.66.1/24"; }; }
      ];
    };

    # zentralwerk
    netdevs."10-wg-zentralwerk" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-zentralwerk";
        Description = "Tunnel to the best basement in Dresden";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg-zw-seckey".path;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "PG2VD0EB+Oi+U5/uVMUdO5MFzn59fAck6hz8GUyLMRo=";
            Endpoint = "81.201.149.152:1337";
            AllowedIPs = [ "172.20.72.0/21" "172.22.90.0/24" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."10-wg-zentralwerk" = {
      matchConfig.Name = "wg-zentralwerk";
      networkConfig = {
        Address = "172.20.76.227/21";
        IPv6AcceptRA = true;
        DNS = "172.20.73.8";
        Domains = [
          "~c3d2.de"
          "~zentralwerk.org"
        ];
      };

      routes = [
        {
          routeConfig = {
            Gateway = "172.20.72.1";
            Destination = "172.20.72.0/21";
          };
        }
        {
          routeConfig = {
            Gateway = "172.20.72.1";
            Destination = "172.20.90.0/24";
          };
        }
      ];
    };
  };
}
