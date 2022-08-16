const events = require("events");
const fs = require("fs");
const readline = require("readline");

(async function processLineByLine() {
  try {
    const used = new Map();
    function addWord(word, keys) {
      if (used.get(keys) === true) {
        throw new Error(
          `Can't use combo '${keys}' for word '${word}' already used by ${used.get(
            keys
          )}`
        );
      }
      used.set(keys, word);
    }

    const dictinput = readline.createInterface({
      input: fs.createReadStream("dictionary.txt"),
      crlfDelay: Infinity,
    });
    const dict = new Map();

    dictinput.on("line", (line) => {
      const combo = line.toLowerCase().split("").sort().join("");
      dict.set(combo, true);
    });

    await events.once(dictinput, "close");

    const alpha = Array.from(Array(26)).map((e, i) => i + 97);
    const alphabet = alpha.map((x) => String.fromCharCode(x));
    for (x of alphabet) {
      for (y of alphabet) {
        const combo = (x + y).split("").sort().join("");
        if (dict.get(combo) !== true && combo[0] !== combo[1]) {
          used.set(combo, false);
        }
      }
    }

    const backupWords = [];
    const rl = readline.createInterface({
      input: fs.createReadStream("words.txt"),
      crlfDelay: Infinity,
    });
    rl.on("line", (line) => {
      let [word, keys] = line.split(" ");
      if (!keys) {
        keys = word;
        // Ignore 3 letter words since its not a significant saving of effort
        if (word.length < 3) {
          return;
        }
      } else {
        addWord(word, keys);
        return;
      }

      // generate every possible combination of letters
      const options = new Map();
      for (x of word) {
        for (y of word.split("").reverse()) {
          const combo = (x + y).split("").sort().join("");
          if (used.get(combo) === false && combo[0] !== combo[1]) {
            options.set(combo, true);
          }
        }
      }
      if (options.size === 0) {
        // look for any combination of a single letter
        for (x of word) {
          for (y of alphabet) {
            const combo = (x + y).split("").sort().join("");
            if (used.get(combo) === false && combo[0] !== combo[1]) {
              options.set(combo, true);
            }
          }
        }
      }

      if (options.size > 0) {
        const value = options.keys().next().value;
        addWord(word, value);
        console.log(word, value);
      }
    });

    await events.once(rl, "close");
    const result = [...used].sort();
  } catch (err) {
    console.error(err);
  }
})();
