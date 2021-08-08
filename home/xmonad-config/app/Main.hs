import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh) -- Needed to export windows to rofi
import XMonad.Util.EZConfig (additionalKeysP)

main :: IO ()
main =
  xmonad $
    ewmh
      def
        { modMask = mod4Mask, -- Use Super instead of Alt
          terminal = "alacritty"
        }
      `additionalKeysP` [ ("M-r", spawn "rofi -show run -drun-show-actions"),
                          ("M-p", spawn "rofi -show window")
                        ]
