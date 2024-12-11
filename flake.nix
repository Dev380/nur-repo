{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    systems = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "armv6l-linux"
      "armv7l-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in rec {
    legacyPackages = (
      forAllSystems (
        system: (
          with {
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
              overlays = [(import rust-overlay)];
            };
          };
            import ./default.nix {inherit pkgs;}
        )
      )
    );
    packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
    ciJobs = let
      lib = nixpkgs.lib;
      isBuildable = platform: p: ((!p.meta.broken) && (lib.meta.availableOn {system = platform;} p));
      isCacheable = p: !(p.preferLocalBuild or false);

      filterNurAttrs = with lib;
        platform: attrs:
          filterAttrs (_: v: isDerivation v && isBuildable platform v && isCacheable v) attrs;
    in
      lib.attrsets.genAttrs systems (name: (filterNurAttrs name packages."${name}"));
  };
}
