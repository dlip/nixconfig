const events = require("events");
const fs = require("fs");
const readline = require("readline");

(async function processLineByLine() {
  try {
    const used = new Map();
    function wordAvailable(word, keys) {
      const sortedKeys = keys.split("").sort().join("");
      if (used.get(sortedKeys)) {
        return new Error(
          `Can't use combo '${keys}' for word '${word}' already used by ${used.get(
            sortedKeys
          )}`
        );
      }
      if (used.get(sortedKeys) !== false && sortedKeys !== "i") {
        return new Error(`Invalid combination of keys '${keys}' or NG word`);
      }
      return true;
    }

    function addWord(word, keys) {
      const sortedKeys = keys.split("").sort().join("");
      const available = wordAvailable(word, keys);
      if (available !== true) {
        throw available;
      }
      used.set(sortedKeys, word);
      console.log(word, keys);
    }

    const alpha = Array.from(Array(26)).map((e, i) => i + 97);
    const alphabet = alpha.map((x) => String.fromCharCode(x));
    const nginput = readline.createInterface({
      input: fs.createReadStream("ng.txt"),
      crlfDelay: Infinity,
    });
    const ng = new Map();
    nginput.on("line", (line) => {
      const combo = line.toLowerCase().split("").sort().join("");
      ng.set(combo, true);
    });
    await events.once(nginput, "close");
    for (x of alphabet) {
      used.set(x, false);
      for (y of alphabet) {
        const combo = (x + y).split("").sort().join("");
        if (ng.get(combo) !== true && combo[0] !== combo[1]) {
          used.set(combo, false);
        }
      }
    }

    const rl = readline.createInterface({
      input: fs.createReadStream("words.txt"),
      crlfDelay: Infinity,
    });
    rl.on("line", (line) => {
      let [word, keys] = line.split(" ");
      if (!keys) {
        keys = word;
      } else {
        addWord(word, keys);
        return;
      }

      // look for combination in word itself
      const options = new Map();
      for (x of word) {
        for (y of word.split("").reverse()) {
          const keys = x + y;
          if (wordAvailable(word, keys) === true) {
            addWord(word, keys);
            return;
          }
        }
      }

      // look for combination of a letter from the word plus any other letter
      for (x of word) {
        for (y of alphabet) {
          const keys = x + y;
          if (wordAvailable(word, keys) === true) {
            // addWord(word, keys);
            console.log(keys);
            // return;
          }
        }
      }
      throw new Error(keys);
    });
    await events.once(rl, "close");

    // used.forEach((v, k) => {
    //   if (v === false) {
    //     console.log(k);
    //   }
    // });
  } catch (err) {
    console.error(err);
  }
})();
