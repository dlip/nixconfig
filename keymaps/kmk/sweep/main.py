# Replicates default Ferris keymap from QMK
# Credit: Pierre Chevalier, 2020
# https://github.com/qmk/qmk_firmware/tree/master/keyboards/ferris/keymaps/default

import board

from kb import KMKKeyboard

from kmk.keys import KC
from kmk.modules.holdtap import HoldTap
from kmk.modules.layers import Layers
from kmk.modules.split import Split, SplitType
from kmk.hid import HIDModes

keyboard = KMKKeyboard()
keyboard.debug_enabled = True

# Note: Ensure drives are named SWEEPL/R
split = Split(
    split_type=SplitType.BLE,
)

layers = Layers()
holdtap = HoldTap()


keyboard.modules = [layers, holdtap, split]

# Cleaner key names
_______ = KC.TRNS
XXXXXXX = KC.NO


htops = dict(prefer_hold=False, tap_interrupted=True)

# Mod-taps
R_ALT = KC.HT(KC.R, KC.LALT, **htops)
S_GUI = KC.HT(KC.S, KC.LGUI, **htops)
T_CTL = KC.HT(KC.T, KC.LCTRL, **htops)

N_CTL = KC.HT(KC.N, KC.LCTRL, **htops)
E_GUI = KC.HT(KC.E, KC.LGUI, **htops)
I_ALT = KC.HT(KC.I, KC.LALT, **htops)


# # Layer tap for other home row keys
# S_L5 = KC.LT(5, KC.S)
# D_L1 = KC.LT(1, KC.D)
# F_L3 = KC.LT(3, KC.F)
# J_L4 = KC.LT(4, KC.J)
# K_L2 = KC.LT(2, KC.K)
# L_L6 = KC.LT(6, KC.L)
# SPC_L7 = KC.LT(7, KC.SPC)

# fmt: off
# flake8: noqa
keyboard.keymap = [
    [  # BASE
       KC.Q,   KC.W,   KC.E,    KC.F,    KC.P,    KC.J,    KC.L,    KC.U,     KC.Y,  KC.COLN,
       KC.A,  R_ALT,  S_GUI,   T_CTL,    KC.G,    KC.M,   N_CTL,   E_GUI,    I_ALT,     KC.O,
       KC.Z,   KC.X,   KC.C,    KC.D,    KC.V,    KC.K,    KC.H, KC.COMM,   KC.DOT,  KC.QUOT,
                                KC.A, KC.SPC,  KC.B,  KC.C,
    ],
    # [  # NAVIGATION
    # _______, _______, KC.PGUP, _______, _______, _______, _______, _______, _______, _______,
    # KC.LEFT,   KC.UP, KC.DOWN, KC.RGHT, _______, _______, KC.LGUI, CTL_ALT,  KC.MEH, KC.HYPR,
    # _______, KC.HOME, KC.PGDN,  KC.END, _______, _______, _______, _______, _______, _______,
    #                            _______, _______, _______, _______,
    # ],
    # [  # 5 NUMBERS
    # _______, _______, _______, _______, _______, _______, KC.F7, KC.F8, KC.F9, KC.F10,
    # _______, _______, _______, _______, _______, _______, KC.F4, KC.F5, KC.F6, KC.F11,
    # _______, _______, _______, _______, _______, _______, KC.F1, KC.F2, KC.F3, KC.F12,
    #                            _______, _______, _______, _______,
    # ],
    # [  # 5 FUNCTION
    # _______, _______, _______, _______, _______, _______, KC.F7, KC.F8, KC.F9, KC.F10,
    # _______, _______, _______, _______, _______, _______, KC.F4, KC.F5, KC.F6, KC.F11,
    # _______, _______, _______, _______, _______, _______, KC.F1, KC.F2, KC.F3, KC.F12,
    #                            _______, _______, _______, _______,
    # ],
    # [  # LEFT SYMBOLS
    # _______, KC.COLN, KC.LABK, KC.RABK, KC.SCLN, _______, _______, _______, _______, _______,
    # KC.LCBR, KC.RCBR, KC.LPRN, KC.RPRN,   KC.AT, _______, _______,  KC.EQL, KC.PLUS, KC.PERC,
    # _______, KC.EXLM, KC.LBRC, KC.RBRC, _______, _______, _______, _______, _______, _______,
    #                            _______, _______, _______, _______,
    # ],
]

if __name__ == "__main__":
    print("Starting Ferris Sweep")
    keyboard.go(
        hid_type=HIDModes.USB, 
        secondary_hid_type=HIDModes.BLE,
        # ble_name='Ferris Sweep KMK'
    )
