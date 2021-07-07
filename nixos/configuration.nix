{ config, pkgs, lib, ... }:

{
	imports = [
		./auth.nix
		./hardware-configuration.nix
	];

	# Boot
	boot.loader = {
		efi.canTouchEfiVariables = true;
		grub = {
			enable = true;
			copyKernels = true;
			device = "nodev";
			efiSupport = true;
		};
	};

	# Time
	time.timeZone = "Asia/Kolkata";

	# Network
	services.openssh.enable = true;
	networking = {
		useDHCP = false;
		interfaces.enp4s0.useDHCP = true;
		hostName = "btw-khushraj-uses-nix";
	};

	# X11
	services.xserver = {
		enable = true;
		libinput = {
			enable = true;
			mouse.naturalScrolling = true;
		};
		displayManager.lightdm = {
			enable = true;
			background = builtins.path { name = "background-image"; path = /home/khushraj/.background-image; };
			greeters.enso = {
				enable = true;
				blur = true;
				cursorTheme = {
					name = "Yaru";
					package = pkgs.yaru-theme;
				};
			};
		};
		desktopManager.session = [
			{
				name = "home-manager";
				start = ''
					${pkgs.runtimeShell} $HOME/.xsession &
					waitPID=$!
				'';
			}
		];
	};

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
	security.sudo.wheelNeedsPassword = false;
	users = {
		mutableUsers = false;
		users.khushraj = {
			isNormalUser = true;
			home = "/home/khushraj";
			description = "Khushraj Rathod";
			extraGroups = [ "wheel" ];
		};	
	};

	# Programs
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"Oracle_VM_VirtualBox_Extension_Pack"
	];

	## Virtualbox
	users.extraGroups.vboxusers.members = [ "khushraj" ];
	virtualisation.virtualbox.host = {
		enable = true;
		enableExtensionPack = true;
	};

	## PostgreSQL
	services.postgresql = {
		enable = true;
		package = pkgs.postgresql_13;
	};

	# environment.systemPackages = with pkgs; [];

	# Misc
	nix.autoOptimiseStore = true;
	## State version, do not change with OS upgrade
	system.stateVersion = "21.05";
}
