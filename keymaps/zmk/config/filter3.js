const events = require('events');
const fs = require('fs');
const readline = require('readline');

function removeDuplicateCharacters(string) {
  return string
    .split('')
    .filter(function(item, pos, self) {
      return self.indexOf(item) == pos;
    })
    .join('');
}

(async function processLineByLine() {
  try {
    const rl = readline.createInterface({
      input: fs.createReadStream('words3.txt'),
      crlfDelay: Infinity
    });

    let used = {};
    function addWord(word, keys) {
      index = keys.split('').sort().join('');

      if (used[index]) {
        throw new Error(`Can't use combo '${keys}' for word '${word}' already used by ${used[index]}`)
      }
      used[index] = word;
    };

    rl.on('line', (line) => {
      let [word, keys] = line.split(' ');
      if(!keys) {
        keys = removeDuplicateCharacters(word);
        if (word.length < 3) {
          return;
        }
      } else {
        addWord(word, keys);
        console.log(word, keys);
        return;
      }

      let options = [keys];


      // generate options by removing characters from the end
      let chars = keys.split('');
      let len = chars.length;
      for (let x = 0; x < len - 1; x++) {
        chars.pop();
        options.push(chars.join(''));
      }

      // generate options by removing characters from the end without vowels

      chars = keys.replace(/[aeiou]/g, '').split('');
      len = chars.length;
      //ensure first char is not stripped if vowel
      if (keys.charAt(0) !== chars[0]) {
        chars = [ keys.charAt(0), ...chars];
      }
      for (let x = 0; x < len - 1; x++) {
        chars.pop();
        options.push(chars.join(''));
      }

      // generate options by removing vowels from the end of the word to the start
      chars = keys.split('');
      for (let x = 0; x < keys.length; x++) {
        const char = chars[keys.length - x - 1];
        if (char.match(/[aeiou]/) && x !== keys.length - 1) {
          chars.splice(keys.length - x - 1, 1);
          options.push(chars.join(''));
        }
      }

      options.sort((a, b) => a.length - b.length);

      let option = null;
      for (let x = 0; x < options.length; x++) {
        index = options[x].split('').sort().join('');

        if (!used[index]) {
          option = options[x];
          addWord(word, option);
          break;
        }
      }

      if (!option) {
        for (let x = 0; x < options.length; x++) {
          index = options[x].split('').sort().join('');
          let existing = used[index];
          console.error(`Option ${options[x]} taken by ${used[index]}`);
        }
        throw new Error(`No available option for word ${word}`);
      }

      console.log(word, option);
    });

    await events.once(rl, 'close');
  } catch (err) {
    console.error(err);
  }
})();
