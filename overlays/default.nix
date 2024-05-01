inputs @ {
  kmonad,
  # , poetry2nix
  actual-server,
  envy-sh,
  emoji-menu,
  power-menu,
  kanata,
  keyd,
  helix,
  sops-nix,
  nix-on-droid,
  mac-app-util,
  steel,
  # vscodeNodeDebug2,
  nixvim,
  # nixpkgs-wayland,
  hyprland,
  hyprcursor-catppuccin,
  ...
}: [
  kmonad.overlays.default
  nix-on-droid.overlays.default
  helix.overlays.default
  #nixpkgs-wayland.overlay
  # poetry2nix.overlay
  # packages
  (final: prev: {
    inherit sops-nix mac-app-util nixvim;
    actualServer = final.callPackage ./actualServer {
      src = actual-server;
      nodejs = final.nodejs-16_x;
    };
    waybar = final.callPackage ./waybar {};
    # vscodeNodeDebug2 = final.callPackage ./vscodeNodeDebug2 {src = vscodeNodeDebug2;};
    envy-sh = envy-sh.defaultPackage.${final.system};
    emoji-menu = final.writeShellScriptBin "emoji-menu" (builtins.readFile "${emoji-menu}/bin/emoji-menu");
    # myEspanso = final.callPackage ./espanso {};
    hyprland = hyprland.packages.${final.system}.hyprland;
    hyprcursor-catppuccin = hyprcursor-catppuccin.packages.${final.system}.hyprcursor-catppuccin;
    power-menu = final.writeShellScriptBin "power-menu" (builtins.readFile "${power-menu}/rofi-power-menu");
    nnn = prev.nnn.overrideAttrs (oldAttrs: {
      makeFlags = oldAttrs.makeFlags ++ ["O_NERD=1"];
    });
    rofimoji = prev.rofimoji.overrideAttrs (oldAttrs: {
      rofi = final.rofi-wayland;
    });
    kanata = final.callPackage ./kanata {src = kanata;};
    # helix = helix.packages.${final.system}.default;
    keyd = prev.keyd.overrideAttrs (oldAttrs: {
      src = keyd;
      buildInputs = [final.git final.systemd];
      installPhase = ''
        mkdir -p $out/bin/
        mkdir -p $out/share/keyd/layouts/
        mkdir -p $out/share/man/man1/
        mkdir -p $out/share/doc/keyd/examples/
        mkdir -p $out/share/libinput/

        install -m755 bin/* $out/bin
        install -m644 docs/*.md $out/share/doc/keyd/
        install -m644 examples/* $out/share/doc/keyd/examples/
        install -m644 layouts/* $out/share/keyd/layouts
        install -m644 data/*.1.gz $out/share/man/man1/
        install -m644 data/keyd.compose $out/share/keyd/
      '';
      postPatch = ''
        substituteInPlace Makefile \
          --replace /usr ""
      '';
    });

    myNodePackages = final.callPackage ./nodePackages {};
    # myPythonPackages = final.callPackage ./pythonPackages { };
    # skyscraper = final.callPackage ./skyscraper { };
    # solang = final.callPackage ./solang { };
    steel = steel.defaultPackage.${final.system};
    # juliusSpeech = final.callPackage ./juliusSpeech { };
    talon = final.callPackage ./talon {};
    # inherit (final.callPackages "${openvpn-aws}/derivations/openvpn.nix" { }) openvpn_aws;
  })
  # Repos with no build step
  (final: prev: prev.lib.filterAttrs (k: v: prev.lib.hasPrefix "repo" k) inputs)
  # vim plugins
  (final: prev: {
    vimPlugins =
      prev.vimPlugins
      // builtins.listToAttrs (map
        (input: let
          name = final.lib.removePrefix "vimplugin-" input;
        in {
          inherit name;
          value = final.vimUtils.buildVimPlugin {
            inherit name;
            pname = name;
            src = builtins.getAttr input inputs;
          };
        })
        (builtins.attrNames (final.lib.filterAttrs (k: v: final.lib.hasPrefix "vimplugin" k) inputs)));
  })
]
