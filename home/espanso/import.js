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
      input: fs.createReadStream(keymap),
      crlfDelay: Infinity,
    });

    let briefs = "";
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
      briefs += `  - trigger: "${keys}"
    replace: "${output}"
    propagate_case: true
    word: true
`;
    });

    await events.once(rl, "close");

    rl = readline.createInterface({
      input: fs.createReadStream("config/default.yml"),
      crlfDelay: Infinity,
    });

    let output = "";
    let mode = "normal";
    let foundBriefs = false;
    rl.on("line", (line) => {
      if (mode === "normal") {
        output += line + "\n";
        if (line.includes("BRIEFS START")) {
          mode = "briefs";
        }
      } else if (mode === "briefs") {
        if (line.includes("BRIEFS END")) {
          foundBriefs = true;
          output += briefs + "\n" + line + "\n";
          mode = "normal";
        }
      }
    });
    console.log(output);

    await events.once(rl, "close");

    if (!foundBriefs) {
      throw new Error(`Unable to find BRIEFS START/END, please add the comments to your keymap:
          # BRIEFS START
          # BRIES END
      `);
    }
    fs.writeFileSync("config/default.yml", output, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
  } catch (err) {
    console.error(err);
  }
})();
