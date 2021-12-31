{ config, pkgs, lib, ... }:
let
  inherit (lib) concatMapStrings;
  romsPath = "/media/games/roms";
  coresPath = "${pkgs.retroarch}/lib";
  systems = [
    rec {
      name = "3do";
      fullname = "3do";
      path = "${romsPath}/3do";
      extension = ".iso .ISO";
      command = ''retroarch -L ${coresPath}/4do_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "amiga";
      fullname = "Amiga";
      path = "${romsPath}/amiga";
      extension = ".adf .ADF";
      command = ''retroarch -L ${coresPath}/puae_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "atari2600";
      fullname = "Atari 2600";
      path = "${romsPath}/atari2600";
      extension = ".a26 .bin .rom .A26 .BIN .ROM";
      command = ''retroarch -L ${coresPath}/stella_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "atarist";
      fullname = "Atari ST, STE, Falcon";
      path = "${romsPath}/atarist";
      extension = ".st, .stx, .img, .rom";
      command = ''retroarch -L ${coresPath}/hatari_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "atari7800";
      fullname = "Atari 7800 ProSystem";
      path = "${romsPath}/atari7800";
      extension = ".a78 .bin .A78 .BIN";
      command = ''retroarch -L ${coresPath}/prosystem_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "atarijaguar";
      fullname = "Atari Jaguar";
      path = "${romsPath}/atarijaguar";
      extension = ".j64 .J64 .jag .JAG";
      command =
        ''retroarch -L ${coresPath}/virtualjaguar_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "atarilynx";
      fullname = "Atari Lynx";
      path = "${romsPath}/atarilynx";
      extension = ".lnx .LNX";
      command = ''retroarch -L ${coresPath}/handy_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "Dreamcast";
      fullname = "Sega Dreamcast";
      path = "${romsPath}/dreamcast";
      extension =
        " .mds, .MDS, .mdf, .MDF, .bin, .BIN, .cue, .CUE, .cdi, .CDI .gdi .GDI";
      command = ''
        %HOMEPATH%.emulationstationsystemsdreamcast
        ullDC.exe -config nullDC_GUI:Fullscreen=0 -config nullDC:Emulator.Autostart=1 -config ImageReader:LoadDefaultImage=1 -config ImageReader:DefaultImage="%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "fba";
      fullname = "Final Burn Alpha";
      path = "${romsPath}/fba/roms";
      extension = ".zip";
      command =
        ''retroarch -L ${coresPath}/fbalpha2012_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "gamegear";
      fullname = "Sega Gamegear";
      path = "${romsPath}/gamegear";
      extension = ".gg .bin .GG .BIN";
      command =
        ''retroarch -L ${coresPath}/genesis_plus_gx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "gb";
      fullname = "Game Boy";
      path = "${romsPath}/gb";
      extension = ".gb .GB";
      command = ''retroarch -L ${coresPath}/gambatte_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "gbc";
      fullname = "Game Boy Color";
      path = "${romsPath}/gbc";
      extension = ".gbc .GBC";
      command = ''retroarch -L ${coresPath}/gambatte_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "gba";
      fullname = "Game Boy Advance";
      path = "${romsPath}/gba";
      extension = ".gba .GBA";
      command = ''retroarch -L ${coresPath}/mgba_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "gc";
      fullname = "Nintendo GameCube";
      path = "${romsPath}/gc";
      extension = ".iso .ISO .gcm .GCM";
      command =
        ''%HOMEPATH%.emulationstationsystemsdolphinDolphin.exe -e "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "genesis";
      fullname = "Sega Genesis";
      path = "${romsPath}/genesis";
      extension = ".smd .bin .gen .md .sg .SMD .BIN .GEN .MD .SG";
      command =
        ''retroarch -L ${coresPath}/genesis_plus_gx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "mame";
      fullname = "MAME";
      path = "${romsPath}/mame";
      extension = "";
      command = ''retroarch -L ${coresPath}/mame_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "mastersystem";
      fullname = "Sega Master System";
      path = "${romsPath}/mastersystem";
      extension = ".sms .bin .SMS .BIN";
      command =
        ''retroarch -L ${coresPath}/genesis_plus_gx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "megadrive";
      fullname = "Sega Mega Drive / Genesis";
      path = "${romsPath}/megadrive";
      extension = ".smd .bin .gen .md .sg .SMD .BIN .GEN .MD .SG";
      command =
        ''retroarch -L ${coresPath}/genesis_plus_gx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "msx";
      fullname = "MSX";
      path = "${romsPath}/msx";
      extension = ".rom .mx1 .mx2 .col .dsk .ROM .MX1 .MX2 .COL .DSK";
      command = ''retroarch -L ${coresPath}/fmsx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "n64";
      fullname = "Nintendo 64";
      path = "${romsPath}/n64";
      extension = ".v64 .z64 .n64 .V64 .Z64 .N64";
      command =
        ''retroarch -L ${coresPath}/mupen64plus_next_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "nes";
      fullname = "Nintendo Entertainment System";
      path = "${romsPath}/nes";
      extension = "";
      command = ''retroarch -L ${coresPath}/fceumm_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "nds";
      fullname = "Nintendo DS";
      path = "${romsPath}/nds";
      extension = ".nds .NDS .7z";
      command = ''retroarch -L ${coresPath}/desmume_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "ngp";
      fullname = "Neo Geo Pocket";
      path = "${romsPath}/ngp";
      extension = ".ngp .ngc";
      command =
        ''retroarch -L ${coresPath}/mednafen_ngp_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "pc";
      fullname = "PC (x86)";
      path = "${romsPath}/pc";
      extension = ".sh .bat .com .exe .SH .BAT .COM .EXE";
      command = ''retroarch -L ${coresPath}/dosbox_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "pcfx";
      fullname = "PC-FX";
      path = "${romsPath}/pcfx";
      extension = ".cue .CUE";
      command =
        ''retroarch -L ${coresPath}/mednafen_pcfx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "psp";
      fullname = "Playstation Portable";
      path = "${romsPath}/psp";
      extension = ".iso .ISO .cso .CSO";
      command = ''retroarch -L ${coresPath}/ppsspp_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "psx";
      fullname = "Playstation";
      path = "${romsPath}/psx";
      extension = ".cue .CUE";
      command =
        ''retroarch -L ${coresPath}/mednafen_psx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "ps2";
      fullname = "Playstation 2";
      path = "${romsPath}/ps2";
      extension = ".iso .ISO .cue .CUE .BIN .bin .mds .MDS";
      command =
        ''%HOMEPATH%.emulationstationsystemspcsx2PCSX2pcsx2.exe "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "pcengine";
      fullname = "TurboGrafx 16 (PC Engine)";
      path = "${romsPath}/pcengine";
      extension = ".pce .zip .cue .PCE .ZIP .CUE";
      command =
        ''retroarch -L ${coresPath}/mednafen_pce_fast_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "scummvm";
      fullname = "ScummVM";
      path = "${romsPath}/scummvm";
      extension = ".bat .BAT";
      command = ''"%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "sega32x";
      fullname = "Sega 32x";
      path = "${romsPath}/sega32x";
      extension = ".32x .smd .bin .md .32X .SMD .BIN .MD";
      command = ''retroarch -L ${coresPath}/picodrive_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "segacd";
      fullname = "Sega CD";
      path = "${romsPath}/segacd";
      extension = ".cue";
      command = ''retroarch -L ${coresPath}/picodrive_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "saturn";
      fullname = "Sega Saturn";
      path = "${romsPath}/saturn";
      extension = ".iso .ISO";
      command = ''retroarch -L ${coresPath}/yabause_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "sg-1000";
      fullname = "Sega SG-1000";
      path = "${romsPath}/sg-1000";
      extension = ".sg .zip .bin .SG .ZIP .BIN";
      command =
        ''retroarch -L ${coresPath}/genesis_plus_gx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "snes";
      fullname = "Super Nintendo Entertainment System";
      path = "${romsPath}/snes";
      extension = ".smc .sfc .SMC .SFC";
      command =
        ''retroarch -L ${coresPath}/mednafen_snes_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "vectrex";
      fullname = "Vectrex";
      path = "${romsPath}/vectrex";
      extension = ".vec .gam .bin .VEC .GAM .BIN";
      command = ''retroarch -L ${coresPath}/vecx_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "videopac";
      fullname = "Odyssey 2 / Videopac";
      path = "${romsPath}/videopac";
      extension = ".bin .BIN";
      command = ''retroarch -L ${coresPath}/o2em_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "virtualboy";
      fullname = "Virtual Boy";
      path = "${romsPath}/virtualboy";
      extension = ".vb .VB";
      command =
        ''retroarch -L ${coresPath}/mednafen_vb_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "wii";
      fullname = "Nintendo Wii";
      path = "${romsPath}/wii";
      extension = ".iso .ISO";
      command = ''
        "%HOMEPATH%.emulationstationsystemsdolphindolphin.exe" -e "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "wonderswan";
      fullname = "Wonderswan";
      path = "${romsPath}/wonderswan";
      extension = ".ws .wsc";
      command =
        ''retroarch -L ${coresPath}/mednafen_wswan_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
    rec {
      name = "zxspectrum";
      fullname = "ZX Spectrum";
      path = "${romsPath}/zxspectrum";
      extension =
        "sna .szx .z80 .tap .tzx .gz .udi .mgt .img .trd .scl .dsk SNA .SZX .Z80 .TAP .TZX .GZ .UDI .MGT .IMG .TRD .SCL .DSK";
      command = ''retroarch -L ${coresPath}/fuse_libretro.so "%ROM_RAW%"'';
      platform = name;
      theme = name;
    }
  ];

  mkSystem = { name, fullname, path, extension, command, platform, theme }: ''
    <system>
    <name>${name}</name>
    <fullname>${fullname}</fullname>
    <path>${path}</path>
    <extension>${extension}</extension>
    <command>${command}</command>
    <platform>${platform}</platform>
    <theme>${theme}</theme>
    </system>
  '';
in
{
  home.packages = with pkgs; [
    retroarch
    # emulationstation # Issue building
  ];

  home.file.".emulationstation/es_systems.cfg".text = ''
    <systemList>
      ${concatMapStrings mkSystem systems}    </systemList>
  '';
  nixpkgs.config.retroarch = {
    # enableBeetleLynx = true;
    # enableBeetlePCEFast = true;
    # enableBeetlePCFX = true;
    # enableBeetlePSX = true;
    # enableBeetlePSXHW = true;
    # enableBeetleSNES = true;
    # # enableBeetleSaturn = true;
    # enableBeetleSaturnHW = true;
    # enableBeetleSuperGrafx = true;
    # enableDolphin = true;
    enableGenesisPlusGX = true;
    # enableMAME = true;
    # enableMBGA = true;
    # enableMGBA = true;
    # enableMupen64Plus = true;
    # enablePCSXRearmed = true;
    # enableParallelN64 = true;
    # enableQuickNES = true;
    # enableSnes9x = true;
    # enableVbaM = true;

    # enableAtari800 = true;
    # enableBeetleGBA = true;
    # enableBeetleLynx = true;
    # enableBeetleNGP = true;
    # enableBeetlePCEFast = true;
    # enableBeetlePCFX = true;
    # enableBeetlePSX = true;
    enableBeetlePSXHW = true;
    # enableBeetleSaturn = true;
    # enableBeetleSaturnHW = true;
    enableBeetleSNES = true;
    # enableBeetleSuperGrafx = true;
    # enableBeetleWswan = true;
    # enableBeetleVB = true;
    # enableBlueMSX = true;
    # enableBsnesMercury = true;
    # enableCitra = true;
    enableDesmume = true;
    # enableDesmume2015 = true;
    # enableDolphin = true;
    # enableDOSBox = true;
    # enableEightyOne = true;
    enableFBAlpha2012 = true;
    # enableFBNeo = true;
    # enableFceumm = true;
    # enableFlycast = true;
    # enableFMSX = true;
    # enableFreeIntv = true;
    enableGambatte = true;
    # enableGenesisPlusGX = true;
    # enableGpsp = true;
    # enableGW = true;
    # enableHandy = true;
    # enableHatari = true;
    # enableMAME = true;
    # enableMAME2000 = true;
    # enableMAME2003 = true;
    # enableMAME2003Plus = true;
    # enableMAME2010 = true;
    # enableMAME2015 = true;
    # enableMAME2016 = true;
    # enableMesen = true;
    # enableMeteor = true;
    enableMGBA = true;
    enableMupen64Plus = true;
    # enableNeoCD = true;
    # enableNestopia = true;
    # enableNP2kai = true;
    # enableO2EM = true;
    # enableOpera = true;
    # enableParallelN64 = true;
    # enablePCSXRearmed = true;
    enablePicodrive = true;
    # enablePlay = true;
    # enablePPSSPP = true;
    # enablePrboom = true;
    # enableProSystem = true;
    # enableQuickNES = true;
    # enableSameBoy = true;
    # enableScummVM = true;
    # enableSMSPlusGX = true;
    # enableSnes9x = true;
    # enableSnes9x2002 = true;
    # enableSnes9x2005 = true;
    # enableSnes9x2010 = true;
    # enableStella = true;
    # enableStella2014 = true;
    # enableTGBDual = true;
    # enableThePowderToy = true;
    # enableTIC80 = true;
    # enableVbaNext = true;
    # enableVbaM = true;
    # enableVecx = true;
    # enableVirtualJaguar = true;
    # enableYabause = true;
  };
}
