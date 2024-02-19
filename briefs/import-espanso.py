import csv

expand_trigger = ",;"
alt_suffix_1 = "q"
alt_suffix_2 = "j"
seen = {}
output = "matches:\n"
line_no = 0


def add_brief(word, trigger):
    global output
    if trigger in seen:
        raise Exception(
            f'Error line {line_no}: already used trigger "{trigger}" for word "{seen[trigger]}"'
        )
    output += (
        f'  - trigger: "{trigger}{expand_trigger}"\n'
        f'    replace: "{word} "\n'
        f"    propagate_case: true\n"
        f'    uppercase_style: "capitalize_words"\n'
        f'  - trigger: "{trigger}.{expand_trigger}"\n'
        f'    replace: "{word}. "\n'
        f"    propagate_case: true\n"
        f'    uppercase_style: "capitalize_words"\n'
        f'  - trigger: "{trigger},{expand_trigger}"\n'
        f'    replace: "{word}, "\n'
        f"    propagate_case: true\n"
        f'    uppercase_style: "capitalize_words"\n'
        f'  - trigger: "{trigger};{expand_trigger}"\n'
        f'    replace: "{word}; "\n'
        f"    propagate_case: true\n"
        f'    uppercase_style: "capitalize_words"\n'
    )
    seen[trigger] = word


with open("briefs/briefs-espanso.txt") as file:
    file = csv.reader(file, delimiter="\t")
    for line in file:
        line_no += 1
        if len(line) > 1 and line[1]:
            add_brief(line[0], line[1])
        if len(line) > 2 and line[2]:
            add_brief(line[2], f"{line[1]}{alt_suffix_1}")
        if len(line) > 3 and line[3]:
            add_brief(line[3], f"{line[1]}{alt_suffix_2}")

with open("home/espanso/config/match/briefs.yml", "w") as file:
    file.write(output)

with open("briefs/training.txt", "w") as file:
    index = 0
    words = ""
    briefs = ""
    for brief, word in seen.items():
        if brief[-1] == alt_suffix_1 or brief[-1] == alt_suffix_2:
            continue
        words += f"{word} "
        briefs += brief + (" " * (len(word) + 1 - len(brief)))
        index += 1
        if index % 10 == 0:
            file.write(words.rstrip())
            file.write("\n")
            file.write(briefs.rstrip())
            file.write("\n")
            words = ""
            briefs = ""
