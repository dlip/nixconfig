{pkgs ? import <nixpkgs> {}}: let
  TERMUX_PREFIX = builtins.getEnv "PREFIX";
  TERMUX_HOME = builtins.getEnv "HOME";

  # Tweak due to difference between Android NDK and Gnu
  termux_patch_include_endian = builtins.toFile "endian-patch.patch" ''
    diff --git a/CMakeLists.txt b/CMakeLists.txt
    index 004e509..0ac05a5 100644
    --- a/CMakeLists.txt
    +++ b/CMakeLists.txt
    @@ -9,6 +9,8 @@ add_library(termux-api SHARED termux-api.c)
     add_executable(termux-api-broadcast termux-api-broadcast.c)
     target_link_libraries(termux-api-broadcast termux-api)

    +set(CMAKE_C_FLAGS "''${CMAKE_C_FLAGS} -lbsd -lpthread")
    +
     # TODO: get list through regex or similar
     set(script_files
       scripts/termux-api-start
    diff --git a/termux-api.c b/termux-api.c
    index d6d8b5b..c07214f 100644
    --- a/termux-api.c
    +++ b/termux-api.c
    @@ -8,13 +8,14 @@
     #include <stdio.h>
     #include <stdlib.h>
     #include <string.h>
    -#include <sys/endian.h>
     #include <sys/socket.h>
     #include <sys/stat.h>
     #include <sys/types.h>
     #include <sys/un.h>
     #include <time.h>
     #include <unistd.h>
    +#include <bsd/stdlib.h> // arc4random
    +#include <arpa/inet.h> // htons

     #include "termux-api.h"

  '';

  termux-api = pkgs.stdenv.mkDerivation rec {
    pname = "termux-api";
    version = "v0.57";
    src = pkgs.fetchgit {
      url = "https://github.com/termux/termux-api-package";
      rev = version;
      sha256 = "1x9h67f6zbpq3yvz7mzsi0x898ak24kdk0fcrqa0xzjsbaqalc7y";
    };
    buildInputs = with pkgs; [cmake libbsd];
    patches = [termux_patch_include_endian];
    # Fix the shebangs
    preConfigure = ''
      for s in scripts/* termux-callback.in; do
        sed -i '1c#!${pkgs.runtimeShell}' "$s"
      done
    '';
  };

  termux-am-socket = pkgs.stdenv.mkDerivation rec {
    pname = "termux-am-socket";
    version = "1.01";
    src = pkgs.fetchgit {
      url = "https://github.com/termux/termux-am-socket";
      rev = version;
      sha256 = "1jbckqqrwz04q5hcwfpqwk3zba6n6igbxqy0n5b4f8z8af361ijd";
    };
    buildInputs = with pkgs; [cmake];
    inherit TERMUX_HOME;
  };

  am = pkgs.linkFarm "am" [
    {
      name = "bin/am";
      path = "${termux-am-socket}/bin/termux-am";
    }
  ];

  termux-packages_src = pkgs.fetchgit {
    url = "https://github.com/termux/termux-packages";
    rev = "bootstrap-2022.01.02-r1";
    sha256 = "0i85awzswd4n5mj0w47564igzh0jn5apmi1kwygnff86q09ydrag";
  };

  termux-tools =
    # Tools not installed:
    #   chsh login motd motd-playstore pkg su termux-change-repo termux-info
    #   termux-backup termux-restore termux-fix-shebang termux-reset
    pkgs.stdenv.mkDerivation rec {
      name = "termux-tools";
      src = termux-packages_src;
      propagatedBuildInputs = [am];
      phases = ["unpackPhase" "installPhase" "fixupPhase"];
      installPhase = ''
        for tool in \
          dalvikvm termux-open termux-open-url termux-reload-settings \
          termux-wake-lock termux-wake-unlock termux-setup-storage
        do
          out_tool=$out/bin/$tool
          install -Dm700 "packages/termux-tools/$tool" "$out_tool"
          substituteInPlace "$out_tool" \
            --subst-var TERMUX_PREFIX \
            --subst-var TERMUX_HOME
        done
      '';
      inherit TERMUX_PREFIX TERMUX_HOME;
    };
in [termux-api termux-am-socket am termux-tools]
