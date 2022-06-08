{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixago.url = "github:jmgilman/nixago";
    nixago.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixago, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Setup nixpkgs
        pkgs = import nixpkgs {
          inherit system;
        };

        # Define development tool configuration
        configs = [
          {
            name = "ghsettings"; # Name of the plugin
            mode = "copy"; # Maintain a local copy (instead of a symlink)
            configData = {
              repository = {
                name = "nixago-github-test";
                description = "A test repository for demonstrating Nixago";
                homepage = "https://github.com/jmgilman/nixago-github-test";
                topics = "nix, cue";
              };
            };
          }
        ];
      in
      rec {
        # Configure local development shell
        devShells = {
          default = pkgs.mkShell {
            shellHook = (nixago.lib.${system}.makeAll configs).shellHook;
          };
        };
      }
    );
}
