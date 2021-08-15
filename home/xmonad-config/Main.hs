-- Needed to export windows to rofi

import Graphics.X11.ExtraTypes.XF86
import System.IO (hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS (nextWS, prevWS, shiftToNext, shiftToPrev)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.StackSet (focusDown, focusUp)
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP)
import XMonad.Util.Run (spawnPipe)

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
              layoutHook = avoidStruts $ layoutHook def,
              logHook =
                dynamicLogWithPP
                  xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    }
            }
          `additionalKeys` [ ((0, xF86XK_MonBrightnessUp), spawn "light -A 10"),
                             ((0, xK_Print), spawn "flameshot gui"),
                             ((0, xF86XK_MonBrightnessDown), spawn "light -U 10"),
                             --  ((0, xF86XK_AudioPlay), spawn "playerctl play-pause"),
                             --  ((0, xF86XK_AudioNext), spawn "playerctl next"),
                             --  ((0, xF86XK_AudioPrev), spawn "playerctl previous"),
                             --  ((0, xF86XK_AudioStop), spawn "playerctl stop"),
                             ((0, xF86XK_AudioForward), spawn "playerctl position +5"),
                             ((0, xF86XK_AudioRewind), spawn "playerctl position -5"),
                             ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
                             ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
                             ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@")
                           ]
          `additionalKeysP` [ ("M-r", spawn "rofi -show drun"),
                              ("M-p", spawn "rofi -show window"),
                              ("M-c", spawn "CM_LAUNCHER=rofi clipmenu"),
                              ("M-l", spawn "xscreensaver-command -lock; xset dpms force off"),
                              ("M-t", spawn "alacritty"),
                              ("<XF86AudioPlay>", spawn "playerctl play-pause"),
                              ("<XF86AudioNext>", spawn "playerctl next"),
                              ("<XF86AudioPrev>", spawn "playerctl previous"),
                              ("<XF86AudioStop>", spawn "playerctl stop"),
                              ("M-<Home>", prevWS),
                              ("M-<End>", nextWS),
                              ("M-S-<Home>", shiftToPrev >> prevWS),
                              ("M-S-<End>", shiftToNext >> nextWS),
                              ("M-<Down>", windows focusDown),
                              ("M-<Up>", windows focusUp)
                            ]
