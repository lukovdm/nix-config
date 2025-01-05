# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") (lib.mkDefault pkgs.linuxPackages_latest);
  boot.kernelParams = [ "mem_sleep_default=deep" "nvme.noacpi=1" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
  '';

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/bbd0cdc3-5483-4fc4-9bd2-8fb0160ae951";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/C7BE-45C3";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/1ecb9365-6cc6-4c9a-94df-35889a7547b4"; }];

  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/9d455e69-da5a-41e2-81f7-0db1c4b741b2";
      preLVM = true;
      allowDiscards = true;
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.acpilight.enable = lib.mkDefault true;

  networking.hostName = "barium"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.wlp170s0.useDHCP = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.networkmanager.wifi.powersave = false;

  systemd.services.NetworkManager-wait-online.enable = false;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # high-resolution display
  #find new setting to fix this

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;
  security.pam.services.sddm = lib.mkIf (config.services.fprintd.enable) {
    text = ''
      auth 			[success=1 new_authtok_reqd=1 default=ignore]  	pam_unix.so try_first_pass likeauth nullok
      auth 			sufficient  	${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth      substack      login
      account   include       login
      password  substack      login
      session   include       login
    '';
  };

  security.pam.services.kde = lib.mkIf (config.services.fprintd.enable) {
    text = '' 
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth sufficient pam_unix.so nullok  likeauth try_first_pass
      auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok sha512

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
    '';
  };


  services.libinput.enable = true;
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
    ];
  };
}
