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
    # $dev and $ifconfig_local are set by OpenVPN.
    # iproute2 is already in PATH by the module wrapper.
    up = ''
      TRANS_UID=$(id -u transmission)
      # Derive gateway from the pushed route-gateway option.
      # $route_vpn_gateway may be empty when redirect-gateway is filtered;
      # $route_gateway_1 is set from the server's pushed "route-gateway" option.
      # Last resort: use the tun peer address ($ifconfig_remote for p2p, or
      # derive the .1 address from $ifconfig_local for subnet topology).
      if [ -n "''${route_gateway_1}" ]; then
        GW="''${route_gateway_1}"
      elif [ -n "''${route_vpn_gateway}" ]; then
        GW="''${route_vpn_gateway}"
      elif [ -n "''${ifconfig_remote}" ]; then
        GW="''${ifconfig_remote}"
      else
        # subnet topology: gateway is x.y.z.1
        GW=$(echo "''${ifconfig_local}" | awk -F. '{print $1"."$2"."$3".1"}')
      fi
      echo "openvpn-up: dev=$dev gw=$GW" | systemd-cat -t openvpn-cyberVPN
      ip route add default via "$GW" dev "$dev" table 100
      ip rule add uidrange "$TRANS_UID"-"$TRANS_UID" lookup 100 priority 100
    '';

    down = ''
      TRANS_UID=$(id -u transmission)
      ip rule del uidrange $TRANS_UID-$TRANS_UID lookup 100 priority 100 || true
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

  # Kill switch via iptables: Transmission may only send traffic via tun0 or loopback.
  networking.firewall.extraCommands = ''
    iptables -A OUTPUT -m owner --uid-owner transmission -o lo   -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission -o tun0 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission          -j REJECT
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D OUTPUT -m owner --uid-owner transmission -o lo   -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission -o tun0 -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission          -j REJECT || true
  '';

  # Register routing table 100 for VPN policy routing
  environment.etc."iproute2/rt_tables.d/vpn.conf".text = ''
    100 vpn
  '';
}

