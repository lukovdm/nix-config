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

  # ---------------------------------------------------------------------------
  # TODO: VPN + kill switch for Transmission — disabled until kill switch is fixed
  #
  # CURRENT STATUS:
  #   - VPN connects successfully (CyberGhost Latvia, tun0 up, IP ~10.x.x.x)
  #   - Policy routing works: uidrange 70-70 lookup table 100 routes
  #     Transmission outbound via tun0. Verified with ifconfig.me returning VPN IP.
  #
  # KNOWN ISSUE — stale iptables rules across rebuilds:
  #   extraCommands only APPENDs rules on each activation, never removes old ones.
  #   After several rebuild iterations the OUTPUT chain accumulated duplicate and
  #   conflicting rules from previous attempts. This caused port 9091 (web UI) to
  #   be unreachable because reply packets hit a REJECT before the ACCEPT.
  #   Root cause: nixos-rebuild switch does not flush extraCommands rules between
  #   activations — only a reboot or manual flush gives a clean state.
  #
  # NEXT SESSION PLAN:
  #   1. Reboot krypton first to get a clean iptables state.
  #   2. Uncomment the config below and rebuild.
  #   3. Verify with:
  #        sudo -u transmission curl https://ifconfig.me  # should return VPN IP
  #        curl http://192.168.1.13:9091/                 # should return 401
  #        sudo systemctl stop openvpn-cyberVPN
  #        sudo -u transmission curl --max-time 5 https://ifconfig.me  # should fail
  # ---------------------------------------------------------------------------

  # services.openvpn.servers.cyberVPN = {
  #   autoStart = true;
  #   up = ''
  #     DEV="$1"
  #     LOCAL_IP="$4"
  #     TRANS_UID=$(id -u transmission)
  #     if [ -n "''${route_gateway_1:-}" ]; then
  #       GW="''${route_gateway_1}"
  #     elif [ -n "''${route_vpn_gateway:-}" ]; then
  #       GW="''${route_vpn_gateway}"
  #     elif [ -n "''${ifconfig_remote:-}" ]; then
  #       GW="''${ifconfig_remote}"
  #     else
  #       PREFIX=''${LOCAL_IP%.*}
  #       GW="''${PREFIX}.1"
  #     fi
  #     echo "openvpn-up: dev=$DEV local=$LOCAL_IP gw=$GW" | systemd-cat -t openvpn-cyberVPN
  #     ip route add default via "$GW" dev "$DEV" table 100
  #     ip rule add uidrange "$TRANS_UID"-"$TRANS_UID" lookup 100 priority 100
  #   '';
  #   down = ''
  #     TRANS_UID=$(id -u transmission)
  #     ip rule del uidrange "$TRANS_UID"-"$TRANS_UID" lookup 100 priority 100 || true
  #     ip route flush table 100 || true
  #   '';
  #   config = ''
  #     client
  #     remote 87-1-lv.cg-dialup.net 443
  #     dev tun
  #     proto udp
  #     auth-user-pass ''${config.age.secrets.cyberghost-auth.path}
  #     resolv-retry infinite
  #     persist-key
  #     persist-tun
  #     nobind
  #     data-ciphers AES-256-GCM:AES-128-GCM:AES-256-CBC
  #     data-ciphers-fallback AES-256-CBC
  #     auth SHA256
  #     ping 5
  #     explicit-exit-notify 2
  #     remote-cert-tls server
  #     route-delay 5
  #     verb 4
  #     ca ''${caCert}
  #     cert ''${clientCrt}
  #     key ''${config.age.secrets.cyberghost-client-key.path}
  #     pull-filter ignore "redirect-gateway"
  #   '';
  # };
  # networking.firewall.extraCommands = ''
  #   iptables -A OUTPUT -m owner --uid-owner transmission -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  #   iptables -A OUTPUT -m owner --uid-owner transmission -o lo   -j ACCEPT
  #   iptables -A OUTPUT -m owner --uid-owner transmission -o tun0 -j ACCEPT
  #   iptables -A OUTPUT -m owner --uid-owner transmission         -j REJECT
  # '';
  # networking.firewall.extraStopCommands = ''
  #   iptables -D OUTPUT -m owner --uid-owner transmission -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT || true
  #   iptables -D OUTPUT -m owner --uid-owner transmission -o lo   -j ACCEPT || true
  #   iptables -D OUTPUT -m owner --uid-owner transmission -o tun0 -j ACCEPT || true
  #   iptables -D OUTPUT -m owner --uid-owner transmission         -j REJECT || true
  # '';
  # environment.etc."iproute2/rt_tables.d/vpn.conf".text = "100 vpn\n";
}
