const events = require("events");
const fs = require("fs");
const readline = require("readline");

function capitalizeFirstLetter(string) {
  return string[0].toUpperCase() + string.slice(1);
}

(async function processLineByLine() {
  try {
    const keymap = process.argv[2];
    if (!keymap) {
      throw new Error(`Missing keymap filename, please pass as first argument`);
    }
    if (!fs.existsSync(keymap)) {
      throw new Error(`Unable to find keymap file ${keymap}`);
    }
    let rl = readline.createInterface({
      input: fs.createReadStream(keymap),
      crlfDelay: Infinity,
    });

    let briefs = "matches:\n";
    let combos = "";
    let used = {};

    rl.on("line", (line) => {
      let [word, keys] = line.split(" ");
      if (used[keys]) {
        throw new Error(
          `Can't use combo '${keys}' for word '${word}' already used by ${used[keys]}`
        );
      }
      used[keys] = word;
      briefs += `  - trigger: "${keys}"
    replace: "${word}"
    word: true
  - trigger: "${keys.toUpperCase()}"
    replace: "${capitalizeFirstLetter(word)}"
    word: true
`;
      if (keys.length === 2) {
        const reverseKeys = keys.split("").reverse().join("");
        used[reverseKeys] = word;
        briefs += `  - trigger: "${reverseKeys}"
    replace: "${word}"
    word: true
  - trigger: "${reverseKeys.toUpperCase()}"
    replace: "${capitalizeFirstLetter(word)}"
    word: true
`;
      }
    });

    await events.once(rl, "close");

    rl = readline.createInterface({
      input: fs.createReadStream("../config/match/base.yml"),
      crlfDelay: Infinity,
    });

    await events.once(rl, "close");

    fs.writeFileSync("../config/match/briefs.yml", briefs, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
  } catch (err) {
    console.error(err);
  }
})();
