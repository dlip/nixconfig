const events = require('events');
const fs = require('fs');
const readline = require('readline');

(async function processLineByLine() {
  try {
    let rl = readline.createInterface({
      input: fs.createReadStream('filtered.txt'),
      crlfDelay: Infinity
    });

    let macros = '';
    let combos = '';

    rl.on('line', (line) => {
      let [word, keys] = line.split(' ');
      const macro=('m_' + word).replace("'", '');
      const inputs = keys.toUpperCase().split('').map(x => x.replace("'", 'SQT'));
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

    rl = readline.createInterface({
      input: fs.createReadStream('cradio.keymap'),
      crlfDelay: Infinity
    });

    let output = '';
    let mode = 'normal';
    rl.on('line', (line) => {
      if (mode === 'normal') {
        output += line + '\n';
        if (line.includes('MACROS START')) {
          mode = 'macros';
        } else if (line.includes('COMBOS START')) {
          mode = 'combos';
        }
      } else if (mode === 'macros') {
        if (line.includes('MACROS END')) {
          output += macros + '\n' + line + '\n';
          mode = 'normal';
        }
      } else if (mode === 'combos') {
        if (line.includes('COMBOS END')) {
          output += combos + '\n' + line + '\n';
          mode = 'normal';
        }
      }
    });

    await events.once(rl, 'close');
    // console.log(output);
    fs.writeFileSync("cradio.keymap", output, { encoding: "utf8", flag: "w", mode: 0o644 });
  } catch (err) {
    console.error(err);
  }
})();
