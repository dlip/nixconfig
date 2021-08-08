import XMonad
import XMonad.Util.EZConfig (additionalKeysP)

main :: IO ()
main =
  xmonad $
    def
      { modMask = mod4Mask, -- Use Super instead of Alt
        terminal = "alacritty"
        -- more changes
      }
      `additionalKeysP` [ ("M-r", spawn "rofi -show run -drun-show-actions")
                        ]
