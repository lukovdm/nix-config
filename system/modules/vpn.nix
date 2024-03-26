{ config, ... }: {
  services.openvpn.servers = {
    cyberVPN = { config = '' config /home/luko/cybervpn/openvpn.ovpn ''; };
  };
}

