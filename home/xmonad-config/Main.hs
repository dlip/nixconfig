-- Needed to export windows to rofi

import Data.Ratio ((%))
import Graphics.X11.ExtraTypes.XF86
import System.IO (hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS (nextWS, prevWS, shiftToNext, shiftToPrev)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Layout.Grid
import XMonad.Layout.Spacing (spacingRaw)
import XMonad.Layout.Spiral (spiral)
import XMonad.StackSet (focusDown, focusUp)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe)

myLayoutHook = avoidStruts (layoutFull ||| layoutTall ||| layoutSpiral ||| layoutGrid ||| layoutMirror)
  where
    layoutFull = Full
    layoutTall = Tall 1 (3 / 100) (1 / 2)
    layoutSpiral = spiral (125 % 146)
    layoutGrid = Grid
    layoutMirror = Mirror (Tall 1 (3 / 100) (3 / 5))

main :: IO ()
main =
  do
    xmproc <- spawnPipe "killall xmobar; xmobar"
    xmonad $
      docks $
        ewmh
          def
            { modMask = mod4Mask, -- Use Super instead of Alt
              terminal = "alacritty",
              manageHook = manageDocks <+> manageHook def,
              layoutHook = myLayoutHook,
              logHook =
                dynamicLogWithPP
                  xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    }
            }
          `additionalKeysP` [ ("M-r", spawn "rofi -show drun"),
                              ("M-p", spawn "rofi -show window"),
                              ("M-c", spawn "CM_LAUNCHER=rofi clipmenu"),
                              ("M-l", spawn "lock-screen"),
                              ("M-n", spawn "networkmanager_dmenu"),
                              ("M-w", spawn "update-wallpaper"),
                              ("M-;", spawn "launch-default-programs"),
                              ("M-<Return>", spawn "alacritty"),
                              ("<XF86AudioPlay>", spawn "playerctl play-pause"),
                              ("<XF86AudioNext>", spawn "playerctl next"),
                              ("<XF86AudioPrev>", spawn "playerctl previous"),
                              ("<XF86AudioStop>", spawn "playerctl stop"),
                              ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
                              ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
                              ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@"),
                              ("<XF86MonBrightnessUp>", spawn "brightnessctl set +5%"),
                              ("<XF86MonBrightnessDown>", spawn "brightnessctl set 5%-"),
                              ("<Print>", spawn "flameshot gui"),
                              ("M-<Home>", prevWS),
                              ("M-<End>", nextWS),
                              ("M-S-<Home>", shiftToPrev >> prevWS),
                              ("M-S-<End>", shiftToNext >> nextWS),
                              ("M-<Down>", windows focusDown),
                              ("M-<Up>", windows focusUp)
                            ]
