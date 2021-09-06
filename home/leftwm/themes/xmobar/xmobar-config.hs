Config
    { font        = "xft:FiraCode Nerd Font Mono:size=13:bold:antialias=true:hinting=true"
    , additionalFonts = [ "xft:FontAwesome:pixelsize=14:antialias=true:hinting=true",
                          "xft:FiraCode Nerd Font Mono:size=24:normal:antialias=true:hinting=true" ]
    , borderColor = "#4eb4fa"
    , border      = BottomB
    , borderWidth = 2
    , allDesktops = True
    , bgColor     = "#313846"
    , fgColor     = "#d0d0d0"
    , position    = TopSize C 100 30
    , commands    =
        [ Run Cpu ["-t", "<fn=2></fn> <fc=#4eb4fa><total>%</fc>"
          , "-L", "80"
          , "-H", "90"
          , "-n", "#e4b63c"
          , "-h", "#fa4e4e"
        ] 10
        , Run DynNetwork
          [ "-S", "True"
          , "-L", "3145728"
          , "-H", "6291456"
          , "-n", "#e4b63c"
          , "-h", "#fa4e4e"
          , "-t", "<fn=2></fn> <fc=#4eb4fa><rx></fc> <fn=2></fn> <fc=#4eb4fa><tx></fc>"
          ] 10
        , Run Memory
          [ "-t","<fn=2></fn> <fc=#4eb4fa><usedratio>%</fc>"
          , "-L", "80"
          , "-H", "90"
          , "-n", "#e4b63c"
          , "-h", "#fa4e4e"
          ] 10
        , Run Date "<fc=#4eb4fa>%a %d %b %Y %H:%M:%S </fc>" "date" 10
        , Run UnsafeStdinReader
        , Run Battery
          [ "-t", "<fc=#d0d0d0><acstatus></fc>"
          , "-L", "20"
          , "-H", "85"
          , "-l", "#fa4e4e"
          , "-n", "#e4b63c"
          , "-h", "#7cac7a"
          , "--" -- battery specific options
          -- discharging status
          , "-o"  , "<fn=1>\xf242</fn> <left>% <fc=#d0d0d0>(<timeleft>)</fc>"
          -- AC "on" status
          , "-O"  , "<fn=1>\xf1e6</fn> <left>%"
          -- charged status
          , "-i"  , "<fn=1>\xf1e6</fn> <left>%"
          , "--off-icon-pattern", "<fn=1>\xf1e6</fn>"
          , "--on-icon-pattern", "<fn=1>\xf1e6</fn>"
          ] 10
        --- https://www.icao.int/safety/iStars/Pages/Weather-Conditions.aspx
        , Run WeatherX "YSSY"
          [ ("", "")
           , ("clear", "")
           , ("sunny", "")
           , ("mostly clear", "")
           , ("mostly sunny", "")
           , ("partly sunny", "")
           , ("fair", "")
           , ("cloudy","")
           , ("overcast","")
           , ("partly cloudy", "杖")
           , ("mostly cloudy", "")
           , ("considerable cloudiness", "")]
          [ "-t", "<fn=2><skyConditionS></fn> <tempC>°"
          , "-L", "10"
          , "-H", "20"
          , "-l", "#d0d0d0"
          , "-n", "#d0d0d0"
          , "-h", "#d0d0d0"
          ] 36000
        , Run DiskIO [("/", "<fc=#4eb4fa><total>/s</fc>")] [ ] 10
        , Run DiskU
          [("/", "<fc=#4eb4fa><used>/<size></fc>")]
          [ "-L", "80"
          , "-H", "90"
          , "-m", "1"
          , "-p", "3"
          , "-n", "#e4b63c"
          , "-h", "#fa4e4e"
          ] 20
        ]
    , sepChar     = "%"
    , alignSep    = "}{"
    , template    = " <fn=2></fn> %UnsafeStdinReader% %cpu% %memory% <fn=2></fn> %disku% %diskio% %dynnetwork% %battery% }{ %date% %YSSY%<fn=2></fn> "
    }