-- Needed to export windows to rofi

import Data.Ratio ((%))
import Graphics.X11.ExtraTypes.XF86
import System.IO (hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS (nextWS, prevWS, shiftToNext, shiftToPrev)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.RefocusLast
  ( isFloat,
    refocusLastLogHook,
    refocusLastWhen,
    refocusingIsActive,
    toggleFocus,
  )
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Spacing (spacingRaw)
import XMonad.Layout.Spiral (spiral)
import XMonad.StackSet (focusDown, focusUp)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (spawnPipe)

myLayoutHook = avoidStruts (layoutFull ||| layoutTall ||| layoutSpiral ||| layoutGrid ||| layoutMirror)
  where
    layoutFull = noBorders Full
    layoutTall = Tall 1 (3 / 100) (1 / 2)
    layoutSpiral = spiral (125 % 146)
    layoutGrid = Grid
    layoutMirror = Mirror (Tall 1 (3 / 100) (3 / 5))

myPred = refocusingIsActive <||> isFloat

scratchpads =
  [ -- run htop in term, top half, perfect fit.
    NS
      "ttyload"
      "xterm -e ttyload"
      (title =? "ttyload")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    -- run htop in term, top half, perfect fit.
    NS
      "htop"
      "xterm -e htop"
      (title =? "htop")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    -- run alsamixer in term, bottom half of screen space around edge.
    NS
      "alsamixer"
      "xterm -e alsamixer"
      (title =? "alsamixer")
      (customFloating $ W.RationalRect (1 / 100) (49 / 100) (98 / 100) (1 / 2)),
    -- run emacs bottom half of screen space around edge.
    NS
      "emacs"
      "emacs"
      (className =? "Emacs")
      (customFloating $ W.RationalRect (1 / 100) (49 / 100) (98 / 100) (1 / 2)),
    -- drop-down terminal    like yeahconsole/tilda/guake/yakuake
    NS
      "xterm"
      "xterm -e tmux"
      (title =? "tmux")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    -- drop-down terminalMK2
    --    NS "tmux" "terminology -e tmux" (className =? "terminology")
    --        (customFloating $ W.RationalRect (0/1) (0/1) (1/1) (1/2)) ,
    -- pop bigbrowser
    NS
      "firefox"
      "firefox"
      (className =? "Firefox")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    -- pop-in terminal chat    like above, but one for chat.
    NS
      "chat"
      "iirc"
      (title =? "chat")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 2) (1 / 2))
  ]
  where
    role = stringProperty "WM_WINDOW_ROLE"

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
              manageHook = manageDocks <+> namedScratchpadManageHook scratchpads <+> manageHook def,
              layoutHook = myLayoutHook,
              handleEventHook = refocusLastWhen myPred <+> handleEventHook def <+> fullscreenEventHook,
              logHook =
                refocusLastLogHook
                  <+> dynamicLogWithPP
                    xmobarPP
                      { ppOutput = hPutStrLn xmproc
                      }
            }
          `additionalKeysP` [ ("M-r", spawn "rofi -hover-select -me-select-entry '' -me-accept-entry MousePrimary -show run"),
                              ("M-d", spawn "rofi -show-icons -hover-select -me-select-entry '' -me-accept-entry MousePrimary -show drun"),
                              ("M-p", spawn "rofi -show-icons -hover-select -me-select-entry '' -me-accept-entry MousePrimary -show window"),
                              ("M-.", spawn "emoji-menu"),
                              ("M-f", toggleFocus),
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
                              ("M-<Up>", windows focusUp),
                              ("M-<F8>", namedScratchpadAction scratchpads "htop")
                            ]
