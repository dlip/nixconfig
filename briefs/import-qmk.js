const events = require("events");
const fs = require("fs");
const readline = require("readline");

function translateKeys(x) {
  switch (x) {
    case "R":
      return "KC_ALT_R";
    case "S":
      return "KC_GUI_S";
    case "T":
      return "KC_CTL_T";
    case "N":
      return "KC_CTL_N";
    case "E":
      return "KC_GUI_E";
    case "I":
      return "KC_ALT_I";
    default:
      return `KC_${x}`;
  }
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

    let briefs = "";
    let used = {};
    let header = true;

    rl.on("line", (line) => {
      if (header) {
        header = false;
        return;
      }
      let [keys, sword, lword, rword] = line.split("\t");
      if (!keys) {
        return;
      }
      let index = keys.split("").sort().join("");
      if (used[index]) {
        throw new Error(
          `Can't use combo '${keys}' for word '${sword}' already used by ${used[index]}`,
        );
      }

      function addWord(word, modifier = "") {
        if (!word) {
          return;
        }
        used[index] = word;
        const macro = "m_" + word.split("").map(translateKeys).join("");
        const inputs = (keys + modifier)
          .toUpperCase()
          .split("")
          .map(translateKeys);
        const name = `b_${word}`.replaceAll("@", "at").replaceAll(".", "dot");
        briefs += `SUBS(${name}, "${word} ", KC_BSPC, ${inputs.join(", ")})\n`;
      }

      addWord(sword);
    });

    await events.once(rl, "close");
    fs.writeFileSync("briefs.def", briefs, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
  } catch (err) {
    console.error(err);
  }
})();
