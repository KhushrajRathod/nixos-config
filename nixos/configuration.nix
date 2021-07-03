{ config, pkgs, ... }:

{
	imports = [
		./auth.nix
		./hardware-configuration.nix
	];

	# Boot
	boot.loader.grub = {
		enable = true;
		copyKernels = true;
		device = "nodev";
		efiSupport = true;
		useOSProber = true;
	};
	boot.loader.efi.canTouchEfiVariables = true;

	# Time
	time.timeZone = "Asia/Kolkata";

	# Network
	networking.useDHCP = false;
	networking.interfaces.enp4s0.useDHCP = true;
	networking.hostName = "btw-khushraj-uses-nix";
	services.openssh.enable = true;

	# X11
	services.xserver.enable = true;
	services.xserver.windowManager.i3.enable = true;
	services.xserver.windowManager.i3.package = pkgs.i3-gaps;
	services.xserver.windowManager.i3.configFile = ./external/i3-config;
	services.xserver.windowManager.i3.extraPackages = with pkgs; [];
	services.xserver.libinput.mouse.naturalScrolling = true; #FIXME
	programs.dconf.enable = true;

	# Printing
	services.printing.enable = true;

	# Sound
	sound.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		pulse.enable = true;	
	};

	# Accounts
	users.mutableUsers = false;
	users.users.khushraj = {
		isNormalUser = true;
		home = "/home/khushraj";
		description = "Khushraj Rathod";
		extraGroups = [ "wheel" ];
		shell = pkgs.fish;
	};
	security.sudo.wheelNeedsPassword = false;

	# Programs
	nixpkgs.config.allowUnfree = true;
	
	## GPG
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};
	
	## Keyring
	services.gnome.gnome-keyring.enable = true;
	security.pam.services.lightdm.enableGnomeKeyring = true;
	programs.seahorse.enable = true;
	
	## Virtualbox
	virtualisation.virtualbox.host.enable = true;
	virtualisation.virtualbox.host.enableExtensionPack = true;
	users.extraGroups.vboxusers.members = [ "khushraj" ];

	## PostgreSQL
	services.postgresql.enable = true;
	services.postgresql.package = pkgs.postgresql_13;

	# environment.systemPackages = with pkgs; [];

	# Fonts
	fonts.fonts = with pkgs; [
		noto-fonts
		noto-fonts-cjk
		noto-fonts-extra
		noto-fonts-emoji
		font-awesome
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
	];

	# State version, do not change with OS upgrade
	system.stateVersion = "21.05";
}
