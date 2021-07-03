{ pkgs, ... }:

{
	programs.home-manager.enable = true;
	home.username = "khushraj";
	home.homeDirectory = "/home/khushraj";

	imports = [
		./programs/chromium.nix      # Web browser
		./programs/dunst.nix         # Notifications daemon
		./programs/fish.nix          # Shell
		./programs/git.nix           # Veqrsion control
		./programs/gtk.nix           # GTK Configuration
		./programs/i3status-rust.nix # Statusbar information
		./programs/kitty.nix         # Terminal emulator
		./programs/picom.nix         # Display compositor
		./programs/rofi.nix          # Application launcher
		./programs/starship.nix      # Shell prompt
	];

	# TODO
	# - Fix: chromium-widevine
	# - Add: android-sdk-platform-tools, bootstrap-studio, docker,
	#   docker-compose, dprint, howdy, polkit, prisma-studio, run-js
	# - Make: grub-silent, possibly with plymouth (?)
	home.packages = with pkgs; [
		# Two-factor authentication app
		(authy.overrideAttrs (oa: { meta = oa.meta // { priority = 6; }; }))
		etcher                  # Disk image flasher
		b3sum                   # BLAKE3 hashing tool 
		bitwarden               # Password manager
		bottom                  # Terminal-based task viewer
		calibre                 # Ebook library
		discord                 # Communications app
		du-dust                 # Terminal-based storage space viewer
		efibootmgr              # EFI boot entry manager
		electrum                # Bitcoin wallet
		fd                      # File finder
		flameshot               # Screenshot tool
		gcc                     # Compiler
		gimp                    # Image editor
		gitkraken               # Git GUI client
		gnome.cheese            # Camera application
		gnome.geary             # Email client
		gnome.nautilus          # File system explorer
		google-chrome           # Browser
		grex                    # Regex maker
		handbrake               # Audio-video encoder
		hyperfine               # Benchmarking tool
		imagemagick             # Terminal-based photo modifier
		insomnia                # REST client
		jdk                     # Java development kit 
		libreoffice             # Office suite
		lm_sensors              # Hardware sensors. Required for i3status-rust
		neofetch                # Terminal-based system-info viewer
		notion                  # Document manager / Collaboration
		obsidian                # Document organiser
		p7zip                   # Compression tool
		procs                   # Terminal job viewer
		qbittorrent             # Torrent client
		rclone                  # Cloud sync tool
		ripgrep                 # File-content searcher
		rustup                  # Rust toolchain manager
		sd                      # stdin filterer
		signal-desktop          # Communications app
		simplescreenrecorder    # Screen recorder
		slack                   # Communications app
		speedtest-cli           # Network speed measurer
		spotify                 # Music app
		tealdeer                # Manual summarizer
		teams                   # Video call app
		teamviewer              # Remote desktop app
		tdesktop                # Communications app
		viu                     # Terminal image viewer
		vlc                     # Audio/video player
		yaru-theme              # GTK Theme
		youtube-dl              # Multimedia scraper
		zoom-us                 # Video call app
	];

	# Temp
	programs.bat.enable = true; # File contents viewer
	programs.exa.enable = true; # File lister
	programs.firefox.enable = true; # Web browser
	programs.firefox.package = pkgs.firefox-devedition-bin;
	programs.gh.enable = true; # GitHub client
	programs.obs-studio.enable = true; # Advanced screen recorder
	programs.vscode.enable = true; # Code editor
	
	home.stateVersion = "21.05";
}
