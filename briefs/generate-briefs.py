import csv
import logging
import sys

log = logging.getLogger(__name__)
log.addHandler(logging.StreamHandler(sys.stdout))
log.setLevel(logging.DEBUG)

used = {}
limit = 100
line_no = 0
min_chars = 3
min_improvement = 40
keyboard_layout = """
wlypkzfou'
crstbxneia
qjvdgmh/,.
"""


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


def find_brief(word):
    log.debug(f"=== {word} ===")
    if len(word) < min_chars:
        log.debug(f"rejected: minimum chars less than {min_chars}")
        return None

    combinations = find_combinations(word)
    combinations.sort(key=len)
    for brief in combinations:
        log.debug(brief)
        if not brief in used:
            improvement = ((len(word) - len(brief)) / len(word)) * 100
            if improvement > min_improvement:
                log.debug(improvement)
                used[brief] = word
                return brief
            else:
                log.debug(f"rejected: improvement insufficient: {improvement}")
                return None
        else:
            log.debug("rejected: already used")

    return None


with open("briefs/english-data.txt") as file:
    while True:
        line_no += 1
        if line_no > limit:
            break
        word = file.readline()
        if not word:
            break
        word = word.strip()
        brief = find_brief(word)
        if brief:
            log.info(f"{word}\t{brief}")
        else:
            log.debug("dropped: no brief found")
