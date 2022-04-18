const events = require('events');
const fs = require('fs');
const readline = require('readline');

(async function processLineByLine() {
  try {
    const rl = readline.createInterface({
      input: fs.createReadStream('words.txt'),
      crlfDelay: Infinity
    });

    let used = {};
    rl.on('line', (line) => {
      let [word, keys] = line.split(' ');
      const cs = keys.split('')
      if (word.length > 2) {
        combo = "";
        index = "";
        for (let x = 0; x < cs.length; x++) {
          if (combo.split('').includes(cs[x])) {
            continue;
          }
          combo += cs[x];
          // need to sort combo to ensure no dupes with different order
          index = combo.split('').sort().join('');

          if (!used[index]) {
            break;
          }
        }
        if (used[index]) {
          combo = keys;
          index = combo.split('').sort().join('');
          if (used[index]) {
            throw new Error(`Combo ${combo} already used by ${used[index]}`)
          }
        }
        used[index] = word;

        console.log(word, combo);
      }
    });

    await events.once(rl, 'close');

  } catch (err) {
    console.error(err);
  }
})();
