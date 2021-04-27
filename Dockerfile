FROM nixos/nix


RUN nix-env -iA nixpkgs.git nixpkgs.nixUnstable &&\
    mkdir -p ~/.config/nix &&\
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

RUN mkdir /work
WORKDIR /work
ADD . /work
RUN nix run .#root.activationPackage
