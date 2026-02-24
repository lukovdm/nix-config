{ config, pkgs, ... }:
let
  caCert    = ../../resources/cyberghost/cyberghost-ca.crt;
  clientCrt = ../../resources/cyberghost/cyberghost-client.crt;

  # Script called by OpenVPN after the tunnel is up.
  # Adds a second routing table (table 100) that routes everything via tun0.
  # Transmission uses this table via an ip rule matching its uid.
  upScript = pkgs.writeShellScript "openvpn-up" ''
    # $route_vpn_gateway and $dev are set by OpenVPN
    TRANS_UID=$(${pkgs.coreutils}/bin/id -u transmission)
    ${pkgs.iproute2}/bin/ip route add default via $route_vpn_gateway dev $dev table 100
    ${pkgs.iproute2}/bin/ip rule add uidrange $TRANS_UID-$TRANS_UID lookup 100 priority 100
  '';

  downScript = pkgs.writeShellScript "openvpn-down" ''
    TRANS_UID=$(${pkgs.coreutils}/bin/id -u transmission)
    ${pkgs.iproute2}/bin/ip rule del uidrange $TRANS_UID-$TRANS_UID lookup 100 priority 100 || true
    ${pkgs.iproute2}/bin/ip route flush table 100 || true
  '';
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
      script-security 2
      remote-cert-tls server
      route-delay 5
      verb 4

      ca ${caCert}
      cert ${clientCrt}
      key ${config.age.secrets.cyberghost-client-key.path}

      # Do NOT redirect the whole system default gateway through VPN.
      # We handle routing for Transmission only via policy routing (up/down scripts).
      pull-filter ignore "redirect-gateway"

      up ${upScript}
      down ${downScript}
    '';
  };

  # Kill switch via iptables: Transmission may only send traffic via tun0 or loopback.
  # The loopback rule must be appended BEFORE the tun0 restriction rule.
  networking.firewall.extraCommands = ''
    iptables -A OUTPUT -m owner --uid-owner transmission -o lo    -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission -o tun0  -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner transmission           -j REJECT
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D OUTPUT -m owner --uid-owner transmission -o lo    -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission -o tun0  -j ACCEPT || true
    iptables -D OUTPUT -m owner --uid-owner transmission           -j REJECT || true
  '';

  # Register routing table 100 for VPN policy routing
  environment.etc."iproute2/rt_tables.d/vpn.conf".text = ''
    100 vpn
  '';

  # Ensure tun device and policy routing are available
  boot.kernelModules = [ "tun" ];
}

