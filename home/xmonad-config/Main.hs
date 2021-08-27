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
import XMonad.Layout.Accordion
import XMonad.Layout.Decoration (ModifiedLayout)
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Spacing (Border (Border), Spacing, spacingRaw)
import XMonad.Layout.Spiral (spiral)
import XMonad.Layout.Tabbed
import XMonad.StackSet (focusDown, focusUp)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (spawnPipe)
import XMonad.Layout.TwoPane
import XMonad.Layout.TwoPanePersistent

mySpacing :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

myTabTheme =
  def
    { fontName = "xft:FiraCode Nerd Font:bold:size=11:antialias=true:hinting=true",
      activeColor = "#4eb4fa",
      inactiveColor = "#313846",
      activeBorderColor = "#4eb4fa",
      inactiveBorderColor = "#282c34",
      activeTextColor = "#313846",
      inactiveTextColor = "#d0d0d0",
      activeBorderWidth = 2,
      inactiveBorderWidth = 2
    }

myLayoutHook = avoidStruts (layoutTabbed ||| layoutTwoPanePersist)
  where
    layoutTabbed = noBorders $ tabbed shrinkText myTabTheme
    layoutTwoPane = mySpacing 4 $ TwoPane (3/100) (1/2)
    layoutTwoPanePersist = mySpacing 4 $ TwoPanePersistent Nothing (3/100) (1/2)
    layoutFull = noBorders Full
    layoutTall = mySpacing 4 $ Tall 1 (3 / 100) (1 / 2)
    layoutSpiral = spiral (125 % 146)
    layoutGrid = Grid
    layoutMirror = Mirror (Tall 1 (3 / 100) (3 / 5))

myPred = refocusingIsActive <||> isFloat

scratchpads =
  [ NS
      "htop"
      "alacritty -e htop"
      (title =? "htop")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    NS
      "nnn"
      "alacritty --class nnn -e nnn"
      (resource =? "nnn")
      nonFloating
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
              manageHook = namedScratchpadManageHook scratchpads <+> manageDocks <+> manageHook def,
              layoutHook = myLayoutHook,
              handleEventHook = refocusLastWhen myPred <+> handleEventHook def <+> fullscreenEventHook,
              logHook =
                refocusLastLogHook
                  <+> dynamicLogWithPP
                    xmobarPP
                      { ppOutput = hPutStrLn xmproc
                      }
            }
          `additionalKeysP` [ ("M-r", windows W.focusUp),
                              ("M-t", windows W.focusDown),
                              ("M-S-r", windows W.swapUp),
                              ("M-S-t", windows W.swapDown),
                              ("M-f", prevWS),
                              ("M-s", nextWS),
                              ("M-S-f", shiftToPrev >> prevWS),
                              ("M-S-s", shiftToNext >> nextWS),
                              ("M-g", toggleFocus),
                              ("M-d", withFocused $ windows . W.sink),
                              ("M-<F8>", namedScratchpadAction scratchpads "htop"),
                              ("M-<F9>", namedScratchpadAction scratchpads "nnn"),
                              ("M-n", spawn "rofi -hover-select -me-select-entry '' -me-accept-entry MousePrimary -show run"),
                              ("M-e", spawn "rofi -show-icons -hover-select -me-select-entry '' -me-accept-entry MousePrimary -show drun"),
                              ("M-p", spawn "rofi -show-icons -hover-select -me-select-entry '' -me-accept-entry MousePrimary -show window"),
                              ("M-.", spawn "emoji-menu"),
                              ("M-c", spawn "CM_LAUNCHER=rofi clipmenu"),
                              ("M-l", spawn "lock-screen"),
                              ("M-m", spawn "networkmanager_dmenu"),
                              ("M-w", spawn "update-wallpaper"),
                              ("M-S-;", spawn "launch-default-programs"),
                              ("M-<Return>", spawn "alacritty"),
                              ("<Print>", spawn "flameshot gui"),
                              ("<XF86AudioPlay>", spawn "playerctl play-pause"),
                              ("<XF86AudioNext>", spawn "playerctl next"),
                              ("<XF86AudioPrev>", spawn "playerctl previous"),
                              ("<XF86AudioStop>", spawn "playerctl stop"),
                              ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
                              ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
                              ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@"),
                              ("<XF86MonBrightnessUp>", spawn "brightnessctl set +5%"),
                              ("<XF86MonBrightnessDown>", spawn "brightnessctl set 5%-")
                            ]
