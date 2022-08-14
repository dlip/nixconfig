const events = require("events");
const fs = require("fs");
const readline = require("readline");

(async function processLineByLine() {
  try {
    const dictinput = readline.createInterface({
      input: fs.createReadStream("dictionary.txt"),
      crlfDelay: Infinity,
    });
    const dict = new Map();

    dictinput.on("line", (line) => {
      dict.set(line.toLowerCase().split("").sort().join(""), true);
    });

    await events.once(dictinput, "close");

    const used = new Map();
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
        // throw new Error(`No available option for word ${word}`);
        backupWords.push(word);
        return;
      }

      const value = options.keys().next().value;
      addWord(word, value);
      console.log(word, value);
      console.log(word, value[1] + value[0]);
    });

    await events.once(rl, "close");
    for (word of backupWords) {
      const options = new Map();
      // look for any combination of a single letter
      for (x of word) {
        for (y of alphabet) {
          const combo = (x + y).split("").sort().join("");
          if (used.get(combo) === false && combo[0] !== combo[1]) {
            options.set(combo, true);
          }
        }
      }
      if (options.size === 0) {
        continue;
      }
      const value = options.keys().next().value;
      addWord(word, value);
      console.log(word, value);
      console.log(word, value[1] + value[0]);
    }
    // used.forEach((v, k) => {
    //   if (v === false) {
    //     console.log(k);
    //   }
    // });
  } catch (err) {
    console.error(err);
  }
})();
