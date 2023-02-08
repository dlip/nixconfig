const events = require("events");
const fs = require("fs");
const readline = require("readline");

function translateKeys(x) {
  switch (x) {
    case "'":
      return "SQT";
      break;
    case "`":
      return "BSPC";
      break;
    case "_":
      return "SPC";
      break;
    case ".":
      return "DOT";
      break;
    case ",":
      return "COMMA";
      break;
    case "@":
      return "AT";
      break;
    default:
      return x;
  }
}

function mapBindings(x) {
  if (x.match(/[A-Z]/)) {
    return `&sk LSHIFT &kp ${x.toUpperCase()}`;
  }

  return `&kp ${translateKeys(x).toUpperCase()}`;
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

    let macros = "";
    let combos = "";
    let used = {};

    rl.on("line", (line) => {
      let [word, keys, left, right] = line.split(" ");
      let index = keys.split("").sort().join("");
      if (used[index]) {
        throw new Error(
          `Can't use combo '${keys}' for word '${word}' already used by ${used[index]}`
        );
      }
      used[index] = word;
      const macro = "m_" + word.split("").map(translateKeys).join("");
      const inputs = keys.toUpperCase().split("").map(translateKeys);
      const bindings = word.split("").map(mapBindings).join(" ");
      macros += `MACRO(${macro}, ${bindings} &kp SPACE)\n`;

      const positions = "P_" + inputs.join(" P_");
      combos += `COMBO(${macro}, &macro_${macro}, ${positions})\n`;
    });

    await events.once(rl, "close");

    fs.writeFileSync("macros.dtsi", macros, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
    fs.writeFileSync("combos.dtsi", combos, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
  } catch (err) {
    console.error(err);
  }
})();
