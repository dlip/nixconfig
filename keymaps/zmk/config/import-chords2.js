const events = require('events');
const fs = require('fs');
const readline = require('readline');

function translateKeys(x) {
  switch(x) {
    case "'":
      return 'SQT';
      break;
    case '`':
      return 'BSPC';
      break;
    case '_':
      return 'SPC';
      break;
    case '.':
      return 'DOT';
      break;
    case '@':
      return 'AT';
      break;
    default:
      return x;
  }
}

function mapBindings(x) {
  if (x.match(/[A-Z]/)) {
    return `&sk LSHIFT &kp ${x.toUpperCase()}`
  }

  return `&kp ${translateKeys(x).toUpperCase()}`
}

(async function processLineByLine() {
  try {
    const keymap = process.argv[2];
    if (!keymap) {
      throw new Error(`Missing keymap filename, please pass as first argument`);
    }
    if (!fs.existsSync(keymap)) {
      throw new Error(`Unable to find keymap file ${keymap}`);
    }
    let rl = readline.createInterface({
      input: fs.createReadStream('chords2.txt'),
      crlfDelay: Infinity
    });

    let macros = '';
    let combos = '';
    let used = {};

    rl.on('line', (line) => {
      let [word, keys] = line.split(' ');
      let index = keys.split('').sort().join('');
      if (used[index]) {
        throw new Error(`Can't use combo '${keys}' for word '${word}' already used by ${used[index]}`)
      }
      used[index] = word;
      const macro='m_' + word.split('').map(translateKeys).join('');
      const inputs = keys.toUpperCase().split('').map(translateKeys);
      const bindings = word.split('').map(mapBindings).join(' ') + ' &kp SPACE';
      macros += `    ZMK_MACRO(${macro},
        wait-ms = <MACRO_WAIT>;
        tap-ms = <MACRO_TAP>;
        bindings = <${bindings}>;
    )
`

      const positions = 'P_' + inputs.join(' P_');
    combos += `    combo_${macro} {
      timeout-ms = <COMBO_TIMEOUT>;
      key-positions = <${positions}>;
      bindings = <&${macro}>;
    };
`
    });

    await events.once(rl, 'close');

    rl = readline.createInterface({
      input: fs.createReadStream(keymap),
      crlfDelay: Infinity
    });

    let output = '';
    let mode = 'normal';
    let foundMacros = false;
    let foundCombos = false;
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
          foundMacros = true;
          output += macros + '\n' + line + '\n';
          mode = 'normal';
        }
      } else if (mode === 'combos') {
        if (line.includes('COMBOS END')) {
          foundCombos = true;
          output += combos + '\n' + line + '\n';
          mode = 'normal';
        }
      }
    });

    await events.once(rl, 'close');

    if (!foundMacros) {
      throw new Error(`Unable to find MACROS START/END, please add the comments to your keymap:
        macros {
          // MACROS START
          // MACROS END
        }
      `)
    }
    if (!foundCombos) {
      throw new Error(`Unable to find MACROS START/END, please add the comments to your keymap:
        combos {
          // COMBOS START
          // COMBOS END
        }
      `)
    }
    fs.writeFileSync("cradio.keymap", output, { encoding: "utf8", flag: "w", mode: 0o644 });
  } catch (err) {
    console.error(err);
  }
})();
