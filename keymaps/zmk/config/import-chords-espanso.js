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
      input: fs.createReadStream("chords4.txt"),
      crlfDelay: Infinity,
    });

    let macros = "";
    let combos = "";
    let used = {};

    rl.on("line", (line) => {
      let [word, keys] = line.split(" ");
      let index = keys.split("").sort().join("");
      if (used[index]) {
        throw new Error(
          `Can't use combo '${keys}' for word '${word}' already used by ${used[index]}`
        );
      }
      used[index] = word;
      const output = word.split("").map(translateWord).join("");
      macros += `  - trigger: "${keys};"
    replace: "${output} "
`;
    });

    await events.once(rl, "close");

    rl = readline.createInterface({
      input: fs.createReadStream(keymap),
      crlfDelay: Infinity,
    });

    let output = "";
    let mode = "normal";
    let foundMacros = false;
    rl.on("line", (line) => {
      if (mode === "normal") {
        output += line + "\n";
        if (line.includes("MACROS START")) {
          mode = "macros";
        }
      } else if (mode === "macros") {
        if (line.includes("MACROS END")) {
          foundMacros = true;
          output += macros + "\n" + line + "\n";
          mode = "normal";
        }
      }
    });
    console.log(output);

    await events.once(rl, "close");

    if (!foundMacros) {
      throw new Error(`Unable to find MACROS START/END, please add the comments to your keymap:
          # MACROS START
          # MACROS END
      `);
    }
    fs.writeFileSync(keymap, output, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
  } catch (err) {
    console.error(err);
  }
})();
