{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
}:

let
  goEnv = pkgs.mkGoEnv { pwd = ./.; };
  builtPackage = pkgs.callPackage ./. {};
in
pkgs.mkShell {
  packages = [
    goEnv
    # TODO: unsure if this is lousy for go development or what
    builtPackage
    pkgs.gomod2nix
    pkgs.terraform
  ];
}
