# IPFS package with built-in S3 datastore plugin

{ stdenv, buildGoModule, fetchurl, nixosTests }:

let
  version = "0.8.0";
  pkgs = import ./sources.nix;
in 
  buildGoModule {
    inherit version;

    pname = "ipfs";
    rev = "v${version}";

    src = pkgs.ipfs;

    subPackages = [ "cmd/ipfs" ];

    vendorSha256 = "1qifcp1mv2fim5csn8g5vdjm88i0sa4n4qzihylli48593mmj3zq";

    postInstall = ''
      install --mode=444 -D misc/systemd/ipfs.service $out/etc/systemd/system/ipfs.service
      install --mode=444 -D misc/systemd/ipfs-api.socket $out/etc/systemd/system/ipfs-api.socket
      install --mode=444 -D misc/systemd/ipfs-gateway.socket $out/etc/systemd/system/ipfs-gateway.socket
      substituteInPlace $out/etc/systemd/system/ipfs.service \
        --replace /usr/bin/ipfs $out/bin/ipfs
    '';
  }
