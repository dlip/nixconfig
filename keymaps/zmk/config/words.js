const events = require('events');
const fs = require('fs');
const readline = require('readline');

(async function processLineByLine() {
  try {
    const rl = readline.createInterface({
      input: fs.createReadStream('words.txt'),
      crlfDelay: Infinity
    });

    let macros = '';
    let combos = '';

    rl.on('line', (line) => {
      let [word, keys] = line.split(' ');
      const macro=('m_' + word).replace("'", '');
      const inputs = keys.toUpperCase().split('')
      const outputs = word.toUpperCase().split('').map(x => x.replace("'", 'SQT'));
      const bindings = '&kp ' + outputs.join(' &kp ') + ' &kp SPACE';
      macros += `
    ZMK_MACRO(${macro},
        wait-ms = <0>;
        tap-ms = <0>;
        bindings = <${bindings}>;
    )`

      const positions = 'P_' + inputs.join(' P_');
    combos += `
    combo_${macro} {
      timeout-ms = <50>;
      key-positions = <P_COMBO ${positions}>;
      bindings = <&${macro}>;
    };`
    });

    await events.once(rl, 'close');
    console.log(macros);
    console.log(combos);

  } catch (err) {
    console.error(err);
  }
})();
