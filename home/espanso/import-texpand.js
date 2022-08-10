const events = require("events");
const fs = require("fs");
const readline = require("readline");

function translateWord(x) {
  switch (x) {
    case `"`:
      return `\\"`;
      break;
    case "_":
      return " ";
      break;
    default:
      return x;
  }
}

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

    let briefs = "Shortcut,Phrase,\n";
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
      const output = word.split("").map(translateWord).join("");
      if (keys !== output) {
        briefs += `${keys},${output},\n`;
        // briefs += `${capitalizeFirstLetter(keys)},${capitalizeFirstLetter(output)},\n`
      }
    });

    await events.once(rl, "close");

    fs.writeFileSync("texpand.csv", briefs, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
  } catch (err) {
    console.error(err);
  }
})();
