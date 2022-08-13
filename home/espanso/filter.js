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
      dict.set(line.toLowerCase(), true);
    });

    const rl = readline.createInterface({
      input: fs.createReadStream("words.txt"),
      crlfDelay: Infinity,
    });

    let used = new Map();
    function addWord(word, keys) {
      if (used.has(keys)) {
        throw new Error(
          `Can't use combo '${keys}' for word '${word}' already used by ${used.get(
            keys
          )}`
        );
      }
      used.set(keys, word);
    }

    rl.on("line", (line) => {
      let [word, keys] = line.split(" ");
      if (!keys) {
        keys = word;
        // Ignore 2 letter words since its not a significant saving of effort
        if (word.length <= 2) {
          addWord(word, keys);
          return;
        }
      } else {
        if (dict.has(keys)) {
          throw new Error(`Error: ${keys} is a dictionary word`);
        }
        addWord(word, keys);
        console.log(word, keys);
        return;
      }

      let options = [keys];

      // generate options by removing characters from the end
      let chars = keys.split("");
      let len = chars.length;
      for (let x = 0; x < len - 1; x++) {
        chars.pop();
        options.push(chars.join(""));
      }

      // generate options by removing characters from the end without vowels

      chars = keys.replace(/[aeiou]/g, "").split("");
      len = chars.length;
      //ensure first char is not stripped if vowel
      if (keys.charAt(0) !== chars[0]) {
        chars = [keys.charAt(0), ...chars];
      }
      for (let x = 0; x < len - 1; x++) {
        chars.pop();
        options.push(chars.join(""));
      }

      // generate options by removing vowels from the end of the word to the start
      chars = keys.split("");
      for (let x = 0; x < keys.length; x++) {
        const char = chars[keys.length - x - 1];
        if (char.match(/[aeiou]/) && x !== keys.length - 1) {
          chars.splice(keys.length - x - 1, 1);
          options.push(chars.join(""));
        }
      }

      options.sort((a, b) => a.length - b.length);

      let option = null;
      for (let x = 0; x < options.length; x++) {
        if (!used.has(options[x]) && !dict.has(options[x])) {
          option = options[x];
          addWord(word, option);
          break;
        }
      }

      if (!option) {
        for (let x = 0; x < options.length; x++) {
          index = options[x].split("").sort().join("");
          console.error(`Option ${options[x]} taken by ${used.get(index)}`);
        }
        throw new Error(`No available option for word ${word}`);
      }

      if (option.length == word.length) {
        throw new Error(
          `Option ${option} is not short enough for word ${word}`
        );
      }
      console.log(word, option);
    });

    await events.once(rl, "close");
  } catch (err) {
    console.error(err);
  }
})();
