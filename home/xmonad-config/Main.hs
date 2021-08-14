-- Needed to export windows to rofi

import System.IO (hPutStrLn)
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe)

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $
    docks $
      ewmh
        def
          { modMask = mod4Mask, -- Use Super instead of Alt
            terminal = "alacritty",
            manageHook = manageDocks <+> manageHook def,
            layoutHook = avoidStruts $ layoutHook def,
            logHook =
              dynamicLogWithPP
                xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  }
          }
        `additionalKeysP` [ ("M-r", spawn "rofi -show drun"),
                            ("M-p", spawn "rofi -show window")
                          ]
