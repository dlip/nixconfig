const events = require("events");
const fs = require("fs");
const readline = require("readline");

function isASCII(str) {
  return /^[\x00-\x7F]*$/.test(str);
}

(async function main() {
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

    let output = `#separator:tab
`;

    rl.on("line", (line) => {
      let [word, keys] = line.split(" ");
      if (!keys) {
        return;
      }

      if (isASCII(word) && isASCII(keys)) {
        output += `${word}\t${keys}\n`;
      }
    });

    await events.once(rl, "close");

    fs.writeFileSync("anki.tsv", output, {
      encoding: "utf8",
      flag: "w",
      mode: 0o644,
    });
  } catch (err) {
    console.error(err);
  }
})();
