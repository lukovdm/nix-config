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

      # Do NOT redirect the whole system's default gateway through VPN.
      # Transmission will bind directly to tun0.
      pull-filter ignore "redirect-gateway"
      route-nopull
    '';
  };

  # Ensure tun device is available
  boot.kernelModules = [ "tun" ];
}

