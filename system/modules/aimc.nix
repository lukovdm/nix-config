{ config, inputs, pkgs, ... }:
let
  tsDomain  = "krypton.ide-turtle.ts.net";
  # Tailscale serve does TLS termination and proxies to this local port.
  nginxPort = 8444;
in
{
  age.secrets.aimc-env = {
    file = ../../secrets/aimc-env.age;
    owner = "aimc";
  };

  services.aimc = {
    enable = true;
    package         = inputs.aimc.packages.${pkgs.system}.aimc;
    frontendPackage = inputs.aimc.packages.${pkgs.system}.aimc-frontend;
    hostname        = tsDomain;
    listenPort      = nginxPort;
    environmentFile = config.age.secrets.aimc-env.path;
    # No ssl.* — tailscale serve handles TLS
  };

  # Configure tailscale serve to proxy port 443 on the tailnet → nginx.
  # Runs once at boot after tailscaled is up.
  systemd.services.tailscale-serve = {
    description = "Configure tailscale serve for AIMC";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "tailscaled.service" "nginx.service" ];
    serviceConfig = {
      Type      = "oneshot";
      ExecStart = pkgs.writeShellScript "tailscale-serve-setup" ''
        ${pkgs.tailscale}/bin/tailscale serve --bg --set-path / http://localhost:${toString nginxPort}
      '';
    };
  };

  # No extra firewall rules needed — tailscale traffic bypasses the firewall
  # and nginx is localhost-only.
}
