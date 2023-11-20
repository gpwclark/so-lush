{ pkgs ? import <nixpkgs> { } }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "sl-sh";
  version = "0.9.70";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
       "sl-console-0.10.1" = "sha256-vsmqQFaVKGB4/pa0flHTcj4aCxIdRgtw336+nHGOWhM=";
       "sl-liner-0.7.0" = "sha256-+cHY4UlVmL2BbPkh17QFI/pzOs+xBQm+s1nCRU4T5YI=";
       "sl-sh-proc-macros-0.3.1" = "sha256-YsayyIVc1WBba8hdxqFyBCLQuQPuayVKNnZp9iXYZS8=";
     };
  };
  src = pkgs.fetchFromGitHub {
    owner = "gpwclark";
    repo = "sl-sh";
    rev = "d7b3c7dc6163feb66e882ea05eaf8d7b5cf4ddc7";
    sha256 = "sha256-l2JqAJe6e8j4MB7qo2hOnCrXSWXS4m1QVgWwIwLU6OA=";
  };
}
