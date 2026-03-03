{ config, inputs, pkgs, ... }:
{
  age.secrets.aimc-env = {
    file = ../../secrets/aimc-env.age;
    owner = "aimc";
  };

  services.aimc = {
    enable = true;
    package         = inputs.aimc.packages.${pkgs.system}.aimc;
    frontendPackage = inputs.aimc.packages.${pkgs.system}.aimc-frontend;
    listenPort      = 8083;
    environmentFile = config.age.secrets.aimc-env.path;
  };

  networking.firewall.allowedTCPPorts = [ 8083 ];
}
