{
  description = "ZMK Build";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      zmk-python = pkgs.python3.withPackages (ps:
        with ps; [
          setuptools
          pip
          west
          # BASE: required to build or create images with zephyr
          #
          # While technically west isn't required it's considered in base since it's
          # part of the recommended workflow

          # used by various build scripts
          pyelftools

          # used by dts generation to parse binding YAMLs, also used by
          # twister to parse YAMLs, by west, zephyr_module,...
          pyyaml

          # YAML validation. Used by zephyr_module.
          pykwalify

          # used by west_commands
          canopen
          packaging
          progress
          psutil

          # for ram/rom reports
          anytree

          # intelhex used by mergehex.py
          intelhex

          west
        ]);

      gnuarmemb = pkgs.pkgsCross.arm-embedded.buildPackages.gcc;

      buildInputs = with pkgs; [
        gcc
        ninja
        dfu-util
        autoconf
        bzip2
        ccache
        libtool
        cmake
        xz
        dtc
        zmk-python
        gnuarmemb
      ];

      build = {
        side ? "left",
        shield ? "cradio",
        board ? "nice_nano_v2",
        keymap ? "default",
        zmkDir ? "./zmk",
        zephyrDir ? "./zephyr",
        configDir ? "./config",
      }:
        pkgs.writeShellApplication {
          name = "build";
          runtimeInputs = buildInputs;
          checkPhase = "";
          text = ''
            # cd config
            # node ../../../briefs/import-zmk.js ../../../briefs/briefs-canary.tsv
            # cd ..
            source ${zephyrDir}/zephyr-env.sh
            west build -p -s ${zmkDir}/app -b ${board} -d build/shield_${side} -- -DSHIELD=${shield}_${side} -DKEYMAP=${keymap} -DZMK_CONFIG=$PWD/${configDir}
            echo 'press enter then reset'
            read
            sleep 5
            # west flash -d build/shield_${side}
            echo 'copying firmware'
            systemctl --user restart udiskie
            sleep 1
            cp build/shield_${side}/zephyr/zmk.uf2 /run/media/dane/NICENANO/
            echo 'done'
          '';
        };
      buildright = pkgs.writeShellScriptBin "buildright" ''
        ${(build {side = "right";})}/bin/build
      '';
      buildreset = pkgs.writeShellScriptBin "buildreset" ''
        ${(build {
          shield = "settings";
          side = "reset";
        })}/bin/build
      '';
      init = pkgs.writeShellScriptBin "init" ''
         git clone https://github.com/zmkfirmware/zmk.git
        west init -l config
      '';
      update = pkgs.writeShellScriptBin "update" ''
        west update
        west zephyr-export
      '';
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = buildInputs ++ [(build {}) buildright buildreset init update];
        nativeBuildInputs = [pkgs.bashInteractive];
        ZEPHYR_TOOLCHAIN_VARIANT = "gnuarmemb";
        GNUARMEMB_TOOLCHAIN_PATH = pkgs.gcc-arm-embedded;
      };
    });
}
