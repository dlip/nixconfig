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

    function addWord(word, keys, left, right) {
      const sortedKeys = keys.split("").sort().join("");
      const available = wordAvailable(word, keys);
      if (available !== true) {
        throw available;
      }
      used.set(sortedKeys, word);
      let output = word + " " + keys;
      if (left) {
        output += " " + left;
      }
      if (right) {
        output += " " + right;
      }

      console.log(output);
    }

    // alphabet sorted by colemak-dh comfort
    const alphabet = "setnriaocfupldhgmxwyvkbjzq".split("");

    // ng is No Good combos to exclude from options
    const ng = new Map(
      [
        // no is a palindrome with on
        "no",
        // awkward for colmak
        "qz",
        "pd",
        "tb",
        "nj",
        "lh",
        "db",
        "jh",
        "js",
        "wz",
        "wx",
        "fc",
        "bv",
        "jk",
        // impossible on charachorder
        "oi",
        "re",
        "vm",
        "vc",
        "vk",
        "gz",
        "gw",
        "pf",
        "pd",
        "ph",
        "xb",
        "xq",
        "ln",
        "lj",
        "ys",
      ].map((x) => [x.split("").sort().join(""), true])
    );

    // set used = false for everything that is an option
    for (x of alphabet) {
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
      let [word, keys, left, right] = line.split(" ");
      if (keys === "xx") {
        keys = undefined;
      }
      if (!keys) {
        keys = word;
      } else {
        addWord(word, keys, left, right);
        return;
      }

      const options = new Map();
      const x = word[0];
      // look for combination in word itself, using the alphabet to prioritize most comfortable
      const tail = word.slice(1);
      for (y of alphabet) {
        if (tail.includes(y)) {
          const keys = x + y;
          if (wordAvailable(word, keys) === true) {
            addWord(word, keys, left, right);
            return;
          }
        }
      }

      // look for combination of a letter from the word plus any other letter
      for (y of alphabet) {
        const keys = x + y;
        if (wordAvailable(word, keys) === true) {
          addWord(word, keys, left, right);
          return;
        }
      }
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
