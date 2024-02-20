import csv
import logging
import sys
import json

log = logging.getLogger(__name__)
log.addHandler(logging.StreamHandler(sys.stdout))
log.setLevel(logging.DEBUG)

used = {}
seen = {}
limit = 0
line_no = 0
min_chars = 3
min_improvement = 40
banned_suffixes = "qj"
# avoid same finger bigrams (sequences which use the same key in a row)
avoid_sfb = True
layout_qwerty = """
qwertyuiop
asdfghjkl;
zxcvbnm,./
"""
layout_colemak = """
qwfpgjluy;
arstdhneio
zxcvbkm,./
"""
layout_colemak_dh = """
qwfpbjluy;
arstgmneio
zxcdvkh,./
"""
layout_canary = """
wlypkzfou'
crstbxneia
qjvdgmh/,.
"""
keyboard_layout = layout_canary
keyboard_finger_maping = """
1234455678
1234455678
1234455678
"""
keyboard_layout_map = {}
for i in range(0, len(keyboard_layout)):
    keyboard_layout_map[keyboard_layout[i]] = keyboard_finger_maping[i]


def find_combinations(s, prefix="", index=0):
    """
    Recursively find every combination of letters in a string from left to right
    starting with the first character.

    Args:
    - s: The input string.
    - prefix: The current combination being built.
    - index: The current index in the string.

    Returns:
    - result: A list containing all combinations starting with the first character
              and excluding the empty string, sorted by shortest string first.
    """
    result = []
    if index == len(s):
        if prefix:
            result.append(prefix)
        return result

    # Include the current character only if it's the first character or part of a previous combination
    if index == 0 or prefix:
        result.extend(find_combinations(s, prefix + s[index], index + 1))

    # Exclude the current character
    result.extend(find_combinations(s, prefix, index + 1))

    return result


def has_sfb(brief):
    for i in range(0, len(brief) - 1):
        if keyboard_layout_map[brief[i]] == keyboard_layout_map[brief[i + 1]]:
            return True
    return False


def find_brief(word):
    log.debug(f"=== {word} ===")
    if len(word) < min_chars:
        log.debug(f"rejected: minimum chars less than {min_chars}")
        return None
    if word in seen:
        log.debug(f"rejected: already seen")
        return None
    for c in word:
        if c not in keyboard_layout:
            log.debug(f"rejected: letter '{c}' not in keyboard layout")
            return None

    seen[word] = True
    combinations = find_combinations(word)
    combinations.sort(key=len)
    sfb_option = None
    for brief in combinations:
        log.debug(brief)
        if not brief in used:
            if len(brief) > 1 and brief[-1] in banned_suffixes:
                log.debug(f"rejected: '{brief[-1]}' is a banned suffix")
                continue
            improvement = ((len(word) - len(brief)) / len(word)) * 100
            if improvement > min_improvement:
                if avoid_sfb and has_sfb(brief):
                    if not sfb_option:
                        sfb_option = brief
                    log.debug(f"avoided: has sfb. improvement: {improvement}")
                    continue
                log.debug(f"selected: improvement: {improvement}")
                used[brief] = word
                return brief
            else:
                log.debug(f"rejected: improvement insufficient: {improvement}")
                if sfb_option:
                    log.debug(f"fallback to sfb option: {sfb_option}")
                    used[sfb_option] = word
                    return sfb_option
                return None
        else:
            log.debug("rejected: already used")

    log.debug("dropped: no brief found")
    return None


with open("briefs/english-data.txt") as file:
    verb_data = {}
    with open("briefs/verbs-conjugations.json") as verbs_file:
        data = json.load(verbs_file)
        for verb in data:
            if "verb" in verb and "participle" in verb and "gerund" in verb:
                verb_data[
                    verb["verb"]
                ] = f"\t{verb['participle'][0]}\t{verb['gerund'][0]}"

    output = ""
    while True:
        line_no += 1
        if limit > 0 and line_no > limit:
            break
        word = file.readline()
        if not word:
            break
        word = word.strip()
        brief = find_brief(word)

        if brief:
            alternate = ""
            if word in verb_data:
                alternate = verb_data[word]
            line = f"{word}\t{brief}{alternate}"
            log.info(line)
            output += line + "\n"

    with open("briefs/briefs-espanso.txt", "w") as file:
        file.write(output)
