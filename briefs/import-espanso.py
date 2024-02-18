import csv

expand_trigger = ",;"
seen = {}
output = "matches:\n"


def add_brief(word, trigger):
    if trigger in seen:
        raise Exception(f'Error: already used trigger "{trigger}" for word "{word}"')
    global output
    output += (
        f'  - trigger: "{trigger}{expand_trigger}"\n'
        f'    replace: "{word} "\n'
        f"    propagate_case: true\n"
        f'    uppercase_style: "capitalize_words"\n'
        f'  - trigger: "{trigger}.{expand_trigger}"\n'
        f'    replace: "{word}. "\n'
        f"    propagate_case: true\n"
        f'    uppercase_style: "capitalize_words"\n'
    )
    seen[trigger] = word


with open("briefs/briefs-espanso.txt") as file:
    file = csv.reader(file, delimiter="\t")
    for line in file:
        if len(line) > 1:
            add_brief(line[0], line[1])

with open("home/espanso/config/match/briefs.yml", "w") as file:
    file.write(output)
