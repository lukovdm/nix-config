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
      model = "base";
      language = "en";
      beamSize = 5;
      uri = "tcp://0.0.0.0:10300";
    };

    openwakeword = {
      enable = true;
      # preloadModels was removed in wyoming-openwakeword 2.0; all bundled
      # wake words are available without preloading.
      uri = "tcp://0.0.0.0:10400";
    };
  };

  networking.firewall.allowedTCPPorts = [ 10200 10300 10400 ];
}
