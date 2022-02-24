{ config, pkgs, lib, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  swapDevices = [ ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.video.hidpi.enable = true;

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.checkJournalingFS = false; 
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Amsterdam";

  networking = {
    hostName = "workstation";
    useDHCP = false;
    interfaces = {
      ens33.useDHCP = true;
    };
    firewall.enable = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = false;
  users.users.root.initialPassword = "root";
  users.users.iverberk = {
    isNormalUser = true;
    home = "/home/iverberk";
    extraGroups = [ "docker" "wheel" ];
    hashedPassword = "$6$DyxPEvfKC1DIJSHi$55MPT4YlT9Qq8jlIpYRnf6.BWe38FRR0KpdXBjZe33sYlCi/7251jBjbA3KuS7b3D53gzDA4JhfuSIpws7tTG1";
  };

  security.sudo.wheelNeedsPassword = false;

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;
    autoRepeatDelay = 150;
    autoRepeatInterval = 30;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager = {
      i3.enable = true;
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.vmware.guest.enable = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";

  environment.systemPackages = with pkgs; [ 
    gnumake
    killall
    xclip
    gtkmm3
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
