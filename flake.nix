{	
	inputs = {
		nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		nixos-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
		nixos-unstable-lagging.url = "github:nixos/nixpkgs/3a5f01cf1a0d7374395bfb2f67d021362cc71373";
		nixos-unstable-leading.url = "github:nixos/nixpkgs/35e24243c386a31c6693b51b55a9767f08e9c205";
		nixos-system.url = "github:nixos/nixpkgs/6500b4580c2a1f3d0f980d32d285739d8e156d92";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixos-unstable";
		};
		android-nixpkgs = {
			url = "github:tadfisher/android-nixpkgs";
			inputs.nixpkgs.follows = "nixos-unstable";
		};
	};

	outputs = { nixos-unstable, nixos-unstable-lagging, nixos-unstable-leading, nixos-system, nixos-unstable-small, home-manager, android-nixpkgs, ... }@inputs:
		let
			config = {
				allowUnfree = true;
				permittedInsecurePackages = [ "electron-19.1.9" "xrdp-0.9.9" ];
			};

			userDetails = rec {
				username = "khushraj";
				name = "Khushraj Rathod";
				email = "khushraj.rathod@gmail.com";
				homeDirectory = "/home/${username}";
				desktopHostname = "${username}s-desktop";
			};

			mkConfig = type: machineModule: system:
				let
					sources = {
						pkgs = import nixos-unstable { inherit system config; };
						system = import nixos-system { inherit system config; };
						unstable-small = import nixos-unstable-small { inherit system config; };
						lagging = import nixos-unstable-lagging { inherit system config; };
						leading = import nixos-unstable-leading { inherit system config; };
					};
				in
					if type == "system" then mkSystemConfig machineModule system sources
					else mkHomeConfig machineModule sources;

			mkSystemConfig = machineModule: system: sources:
				nixos-system.lib.nixosSystem {
					specialArgs = { inherit inputs userDetails; } // builtins.removeAttrs sources ["pkgs"];
					modules = [
						machineModule
						{
							# Used to make nix-index work with flakes, sets nixPath to flake output rather than a nix-channel
							nix.nixPath = [ "nixpkgs=${nixos-unstable}" ];
							nixpkgs.hostPlatform = system;
						}
					];
				};

			mkHomeConfig = machineModule: sources: 
				home-manager.lib.homeManagerConfiguration {
					inherit (sources) pkgs;
					modules = [
						machineModule
						{
							home = {
								inherit (userDetails) username homeDirectory;
							};
						}	
					];

					extraSpecialArgs = { inherit inputs userDetails; } // builtins.removeAttrs sources ["pkgs"];
				};
		in {
			nixosConfigurations."${userDetails.desktopHostname}" = mkConfig "system" ./os/os.nix "x86_64-linux";
			homeConfigurations."${userDetails.username}@${userDetails.desktopHostname}" = mkConfig "home" ./home/desktop.nix "x86_64-linux";
			homeConfigurations."${userDetails.username}@eternity" = mkConfig "home" ./home/eternity.nix "aarch64-linux";
		};
}
