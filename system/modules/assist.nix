{ config, ... }:
{
  services.wyoming = {
    piper.servers.piper = {
      enable = true;
      voice = "en_GB-semaine-medium";
      speaker = 3;
    };

    faster-whisper.servers.whisper = {
      enable = true;
      model = "medium-int8";
    };

    openwakeword = {
      enable = true;
      preloadModels = "hey_jarvis";
    };
  };

  networking.firewall.allowedTCPPorts = [ 10200 10300 10400 ];
}
