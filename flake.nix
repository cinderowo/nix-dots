{
  description = "a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    niri.url = "github:sodiboo/niri-flake";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    musnix.url = "github:musnix/musnix";
  };



  outputs = { self, nixpkgs, unstable-nixpkgs, home-manager, niri, stylix, nix-flatpak, musnix, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      # unstablepkgs = unstable-nixpkgs.legacyPackages.${system};
      unstablepkgs = import unstable-nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {

    
      nixosConfigurations = {
        uwu = lib.nixosSystem {
          specialArgs = { inherit inputs; inherit unstablepkgs; };
          inherit system;
          
          modules = [
            ./configuration.nix

            stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak

            musnix.nixosModules.musnix
            
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };
      };
      homeConfigurations = {
        nixos = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit unstablepkgs;
          modules = [
            ./hm/home.nix
          ];
        };
      };
    };
}
