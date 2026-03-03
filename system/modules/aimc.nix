{ config, inputs, pkgs, ... }:
let
  tsDomain = "krypton.ide-turtle.ts.net";
  certDir  = "/var/lib/tailscale-certs";
in
{
  age.secrets.aimc-env = {
    file = ../../secrets/aimc-env.age;
    owner = "aimc";
  };

  # Provision and auto-renew the Tailscale TLS certificate.
  # Runs at boot and weekly; restarts nginx on renewal.
  systemd.services.tailscale-cert = {
    description = "Provision Tailscale TLS certificate for ${tsDomain}";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "tailscaled.service" "network-online.target" ];
    wants       = [ "network-online.target" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "tailscale-cert" ''
        mkdir -p ${certDir}
        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file ${certDir}/${tsDomain}.crt \
          --key-file  ${certDir}/${tsDomain}.key \
          ${tsDomain}
        chown root:tailscale-certs ${certDir}/${tsDomain}.key
        chmod 640 ${certDir}/${tsDomain}.key
        systemctl reload nginx || true
      '';
    };
  };

  systemd.timers.tailscale-cert = {
    wantedBy  = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  services.aimc = {
    enable = true;
    package         = inputs.aimc.packages.${pkgs.system}.aimc;
    frontendPackage = inputs.aimc.packages.${pkgs.system}.aimc-frontend;
    hostname        = tsDomain;
    ssl.certFile    = "${certDir}/${tsDomain}.crt";
    ssl.keyFile     = "${certDir}/${tsDomain}.key";
    environmentFile = config.age.secrets.aimc-env.path;
  };

  # Only HTTPS is needed; nginx handles the redirect from 80 → 443 via forceSSL
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Allow nginx to read the private key
  users.groups.tailscale-certs = { };
  users.users.nginx.extraGroups = [ "tailscale-certs" ];
}
