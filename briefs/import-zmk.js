const events = require("events");
const fs = require("fs");
const readline = require("readline");

const positions = [
  "Q",
  "W",
  "F",
  "P",
  "B",
  "J",
  "L",
  "U",
  "Y",
  ";",
  "A",
  "R",
  "S",
  "T",
  "G",
  "M",
  "N",
  "E",
  "I",
  "O",
  "Z",
  "X",
  "C",
  "D",
  "V",
  "K",
  "H",
  "COMMA",
  "DOT",
  'SQT',
  '',
  'SPC',
  'LSHIFT',
  '',
];

function translatePosition(x) {
  const pos = positions.indexOf(x);
  if (pos === -1) {
    throw new Error(`Unable to find position for ${x}`);
  }
  return pos;
}

function translateKeys(x) {
  switch (x) {
    case "'":
      return "SQT";
      break;
    case "←":
      return "BSPC";
      break;
    case "⇧":
      return "LSHIFT";
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
    case "␣":
      return "SPC";
      break;
    default:
      return x;
  }
}

function mapBindings(x) {
  if (x.match(/[A-Z]/)) {
    return `&sk LSHIFT &kp ${x.toUpperCase()}`;
  }

  return `&${x == '⇧' ? 'sk' : 'kp'} ${translateKeys(x).toUpperCase()}`;
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

    let macros = `#define str(s) #s
#define MACRO(NAME, BINDINGS) \\
  macro_##NAME: macro_##NAME { \\
      compatible = "zmk,behavior-macro"; \\
      label = str(macro_##NAME); \\
      #binding-cells = <0>; \\
      wait-ms = <0>; \\
      tap-ms = <10>; \\
      bindings = <BINDINGS>; \\
  };

`;
    let combos = `#define COMBO(NAME, BINDINGS, KEYPOS) \\
  combo_##NAME { \\
    timeout-ms = <100>; \\
    bindings = <BINDINGS>; \\
    key-positions = <KEYPOS>; \\
    layers = <0>; \\
  };

`;
    let used = {};

    rl.on("line", (line) => {
      let [word, keys] = line.split(" ");
      if (!keys) {
        return;
      }
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
      macros += `MACRO(${macro}, ${bindings}${word.includes('␣') ? '' : ' &kp SPACE'})\n`;

      const positions = [...inputs, 'SPC'].map(translatePosition).join(" ");
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
