# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
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
    { device = "/dev/disk/by-uuid/bbd0cdc3-5483-4fc4-9bd2-8fb0160ae951";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C7BE-45C3";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1ecb9365-6cc6-4c9a-94df-35889a7547b4"; }
    ];

  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/9d455e69-da5a-41e2-81f7-0db1c4b741b2";
      preLVM = true;
      allowDiscards = true;
    };
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";

  hardware.acpilight.enable = lib.mkDefault true;

  networking.hostName = "barium"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.wlp170s0.useDHCP = true;
  networking.networkmanager.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # high-resolution display
  hardware.video.hidpi.enable = true;

  services.fprintd.enable = true;
  services.xserver.libinput.enable = true;
  hardware.bluetooth.enable = true;
}
