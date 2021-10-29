{ dockerTools, pkgs }:
with pkgs; dockerTools.buildLayeredImage {
  name = "push-nix-store-docker-image";
  tag = "latest";
  contents = [
    coreutils
    skopeo
    cacert
    nixUnstable
    (writeScriptBin "entrypoint" ''
      #!${runtimeShell}
      set -euo pipefail
      mkdir -p /var/tmp
      nix --experimental-features nix-command store cat --store $1 $2 | skopeo --insecure-policy copy docker-archive:/dev/stdin docker://$3
    '')
  ];
  config.Entrypoint = [ "entrypoint" ];
}

