{ config, ... }:
{
  services.wyoming = {
    piper.servers.piper = {
      enable = true;
      voice = "en_GB-semaine-medium";
      speaker = 3;
      uri = "tcp://0.0.0.0:10200";
    };

    faster-whisper.servers.whisper = {
      enable = true;
      model = "tiny";
      language = "en";
      uri = "tcp://0.0.0.0:10300";
    };

    openwakeword = {
      enable = true;
      preloadModels = [
        "hey_jarvis"
        "hey_mycroft"
      ];
      uri = "tcp://0.0.0.0:10400";
    };
  };

  networking.firewall.allowedTCPPorts = [ 10200 10300 10400 ];
}
