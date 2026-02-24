{ config, pkgs, ... }:
let
  caCert    = ../../resources/cyberghost/cyberghost-ca.crt;
  clientCrt = ../../resources/cyberghost/cyberghost-client.crt;
in
{
  age.secrets.cyberghost-auth = {
    file = ../../secrets/cyberghost-auth.age;
    owner = "root";
    mode = "0400";
  };
  age.secrets.cyberghost-client-key = {
    file = ../../secrets/cyberghost-client-key.age;
    owner = "root";
    mode = "0400";
  };

  services.openvpn.servers.cyberVPN = {
    autoStart = true;

    # Called by the NixOS openvpn module after tunnel is up.
    # Args: $1=dev $2=tun-mtu $3=link-mtu $4=ifconfig-local $5=ifconfig-netmask $6=init
    # iproute2 is already in PATH by the module wrapper.
    up = ''
      DEV="$1"
      LOCAL_IP="$4"
      TRANS_UID=$(id -u transmission)
      # Derive gateway: prefer pushed route-gateway env vars, fall back to
      # computing x.y.z.1 from the tunnel's local IP (subnet topology).
      if [ -n "''${route_gateway_1:-}" ]; then
        GW="''${route_gateway_1}"
      elif [ -n "''${route_vpn_gateway:-}" ]; then
        GW="''${route_vpn_gateway}"
      elif [ -n "''${ifconfig_remote:-}" ]; then
        GW="''${ifconfig_remote}"
      else
        # subnet topology: gateway is always x.y.z.1
        PREFIX=''${LOCAL_IP%.*}
        GW="''${PREFIX}.1"
      fi
      echo "openvpn-up: dev=$DEV local=$LOCAL_IP gw=$GW" | systemd-cat -t openvpn-cyberVPN
      ip route add default via "$GW" dev "$DEV" table 100
      # Route by fwmark instead of UID so only marked (new outbound) packets
      # use the VPN table — reply packets are not marked and use main table.
      ip rule add fwmark 0x9091 lookup 100 priority 100
    '';

    down = ''
      ip rule del fwmark 0x9091 lookup 100 priority 100 || true
      ip route flush table 100 || true
    '';

    config = ''
      client
      remote 87-1-lv.cg-dialup.net 443
      dev tun
      proto udp
      auth-user-pass ${config.age.secrets.cyberghost-auth.path}

      resolv-retry infinite
      persist-key
      persist-tun
      nobind

      data-ciphers AES-256-GCM:AES-128-GCM:AES-256-CBC
      data-ciphers-fallback AES-256-CBC

      auth SHA256
      ping 5
      explicit-exit-notify 2
      remote-cert-tls server
      route-delay 5
      verb 4

      ca ${caCert}
      cert ${clientCrt}
      key ${config.age.secrets.cyberghost-client-key.path}

      # Do NOT redirect the whole system default gateway through VPN.
      # Transmission routing is handled via policy routing in the up script.
      pull-filter ignore "redirect-gateway"
    '';
  };

  # Mark new outbound connections from Transmission so they use the VPN routing table.
  # Reply packets are not marked and use the main table, so the web UI works.
  # The kill switch (REJECT) still applies to all non-VPN, non-local internet traffic.
  networking.firewall.extraCommands = ''
    iptables -t mangle -A OUTPUT -m owner --uid-owner transmission -m conntrack --ctstate NEW -j MARK --set-mark 0x9091
    iptables -A OUTPUT -m owner --uid-owner transmission -o lo          -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission -o tun0        -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission -d 10.0.0.0/8  -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission -d 172.16.0.0/12 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission -d 192.168.0.0/16 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission -d 100.64.0.0/10 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission                -j REJECT
  '';
  networking.firewall.extraStopCommands = ''
    iptables -t mangle -D OUTPUT -m owner --uid-owner transmission -m conntrack --ctstate NEW -j MARK --set-mark 0x9091 || true
    iptables -D OUTPUT -m owner --uid-owner transmission -o lo          -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission -o tun0        -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission -d 10.0.0.0/8  -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission -d 172.16.0.0/12 -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission -d 192.168.0.0/16 -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission -d 100.64.0.0/10 -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission                -j REJECT || true
  '';

  # Register routing table 100 for VPN policy routing
  environment.etc."iproute2/rt_tables.d/vpn.conf".text = ''
    100 vpn
  '';
}

