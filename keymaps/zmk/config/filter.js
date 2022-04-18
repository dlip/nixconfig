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
        for (let x = 0; x < cs.length; x++) {
          if (combo.split('').includes(cs[x])) {
            continue;
          }
          combo += cs[x];
          if (!used[combo]) {
            break;
          }
        }
        if (used[combo]) {
          combo = keys;
          if (used[combo]) {
            throw new Error('Combo already used: ' + combo)
          }
        }
        used[combo] = true;

        console.log(word, combo);
      }
    });

    await events.once(rl, 'close');

  } catch (err) {
    console.error(err);
  }
})();
