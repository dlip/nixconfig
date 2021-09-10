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
import XMonad.Actions.GridSelect

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
      "alacritty"
      "alacritty -t scratchpad-alacritty"
      (title =? "scratchpad-alacritty")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    NS
      "htop"
      "alacritty -t scratchpad-htop -e htop"
      (title =? "scratchpad-htop")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    NS
      "qalculate"
      "qalculate-gtk"
      (title =? "Qalculate!")
      (customFloating $ W.RationalRect (0 / 1) (0 / 1) (1 / 1) (1 / 2)),
    NS
      "nnn"
      "alacritty -t scratchpad-nnn -e nnn"
      (title =? "scratchpad-nnn")
      nonFloating,
    NS
      "emacs"
      "emacs"
      (className =? "Emacs")
      nonFloating
  ]
  where
    role = stringProperty "WM_WINDOW_ROLE"

myLogHook xmobarProc = refocusLastLogHook <+> dynamicLogWithPP xmobarPP
  { ppLayout = const ""  -- wrap "(<fc=#4eb4fa>" "</fc>)"
  -- , ppSort = getSortByXineramaRule  -- Sort left/right screens on the left, non-empty workspaces after those
  , ppTitleSanitize = const ""  -- Also about window's title
  , ppVisible = wrap "(" ")"  -- Non-focused (but still visible) screen
  , ppCurrent = wrap "<fc=#d0d0d0>[</fc><fc=#4eb4fa>" "</fc><fc=#d0d0d0>]</fc>"-- Non-focused (but still visible) screen
  , ppOutput = hPutStrLn xmobarProc
  }

main :: IO ()
main =
  do
    xmobarProc <- spawnPipe "killall xmobar; xmobar"
    xmonad $
      docks $
        ewmh
          def
            { modMask = mod4Mask, -- Use Super instead of Alt
              terminal = "alacritty",
              manageHook = namedScratchpadManageHook scratchpads <+> manageDocks <+> manageHook def,
              layoutHook = myLayoutHook,
              handleEventHook = refocusLastWhen myPred <+> handleEventHook def <+> fullscreenEventHook,
              logHook = myLogHook xmobarProc,
              focusedBorderColor = "#4eb4fa",
              borderWidth = 2
            }
          `additionalKeysP` [ ("M-r", windows W.focusUp),
                              ("M-t", windows W.focusDown),
                              ("M-S-r", windows W.swapUp),
                              ("M-S-t", windows W.swapDown),
                              ("M-m", windows W.focusMaster),
                              ("M-S-m", windows W.swapMaster),
                              ("M-f", prevWS),
                              ("M-s", nextWS),
                              ("M-S-f", shiftToPrev >> prevWS),
                              ("M-S-s", shiftToNext >> nextWS),
                              ("M-g", toggleFocus),
                              ("M-,", sendMessage Shrink),
                              ("M-.", sendMessage Expand),
                              ("M-d", withFocused $ windows . W.sink),
                              ("M-o", goToSelected defaultGSConfig),
                              ("M-S-;", spawn "launch-default-programs"),
                              ("M-e", spawn "emoji-menu"),
                              ("M-w", spawn "rofi -show-icons -hover-select -me-select-entry '' -me-accept-entry MousePrimary -modi windowcd -show windowcd"),
                              ("M-S-w", spawn "rofi -show-icons -hover-select -me-select-entry '' -me-accept-entry MousePrimary -modi window -show window"),
                              ("M-p", spawn "rofi -hover-select -me-select-entry '' -me-accept-entry MousePrimary -show-icons -show combi -combi-modi 'drun,run' -modi combi"),
                              ("M-S-q", spawn "rofi -show power-menu -modi power-menu:power-menu"),
                              ("M-<Return>", namedScratchpadAction scratchpads "alacritty"),
                              ("M-S-<Return>", spawn "alacritty"),
                              ("M-l", spawn "lock-screen"),
                              ("M-M1-C-S-h", namedScratchpadAction scratchpads "htop"),
                              ("M-M1-C-S-f", namedScratchpadAction scratchpads "nnn"),
                              ("M-M1-C-S-<Return>", namedScratchpadAction scratchpads "qalculate"),
                              ("M-M1-C-S-b", spawn "update-wallpaper"),
                              ("M-M1-C-S-c", spawn "CM_LAUNCHER=rofi clipmenu"),
                              ("M-M1-C-S-e", namedScratchpadAction scratchpads "emacs"),
                              ("M-M1-C-S-n", spawn "networkmanager_dmenu"),
                              ("M-M1-C-S-v", spawn "vial"),
                              ("<Print>", spawn "flameshot gui"),
                              ("<XF86AudioPlay>", spawn "playerctl play-pause"),
                              ("<XF86AudioNext>", spawn "playerctl next"),
                              ("<XF86AudioPrev>", spawn "playerctl previous"),
                              ("<XF86AudioStop>", spawn "playerctl stop"),
                              ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5% && volnoti-show $(pamixer --get-volume) && play ~/Music/volume.mp3"),
                              ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5% && volnoti-show $(pamixer --get-volume) && play ~/Music/volume.mp3"),
                              ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ && volnoti-show $(pamixer --get-volume)"),
                              ("<XF86MonBrightnessUp>", spawn "brightnessctl set +5%"),
                              ("<XF86MonBrightnessDown>", spawn "brightnessctl set 5%-")
                            ]
