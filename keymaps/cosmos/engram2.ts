const options: Options = {
  wallThickness: 4,
  wallShrouding: 0,
  webThickness: 0,
  webMinThicknessFactor: 0.8,
  keyBasis: "choc",
  screwIndices: [-1, -1, -1, -1, -1],
  screwType: "screw insert",
  screwSize: "M3",
  screwCountersink: true,
  rounded: {},
  connector: "trrs",
  connectorSizeUSB: "average",
  connectorIndex: -1,
  microcontroller: "waveshare-rp2040-zero",
  fastenMicrocontroller: true,
  verticalClearance: 3,
  clearScrews: true,
  shell: { type: "basic", lip: false }
}
// NOTE: Screws / the connector with
// negative indices are placed automatically.
// In the basic/advanced tab, these values were:
// screwIndices: [9.5, 16.5, 4.5, 12.5, 19.5, 7.5, 14.5]
// connectorIndex: 0

const curvature = {
  curvatureOfColumn: 20,
  curvatureOfRow: 0,
  spacingOfRows: 17,
  spacingOfColumns: 18,
  arc: 0
}

/**
 * Useful for setting a different curvature
 * for the pinky keys.
 */
const pinkyCurvature = {
  ...curvature,
  curvatureOfColumn: 30
}

/**
 * The plane used to position the upper keys.
 * It's rotated by the tenting and x rotation
 * then translated by the z offset.
 */
const upperKeysPlane = new Trsf()
  .rotate(25, [0, 0, 0], [0, 1, 0], false)
  .rotate(1, [0, 0, 0], [1, 0, 0], false)
  .translate(0, 0, 0, false)


/** Definitions for the upper keys. */
const fingers: Key[] = [
  {
    type: "trackball",
    aspect: 1,
    cluster: "fingers",
    size: { radius: 20.9, sides: 50 },
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: -3.5,
        row: 0.20000000000000018
      })
      .translate(10, 10, 0)
      .transformBy(upperKeysPlane)
      .rotateTowards([0, 0, 1], 1)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 2,
      letter: "u"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: -1,
        row: -1
      })
      .translate(-1.5, 0, 0)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 3,
      home: "index",
      letter: "j"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: -1,
        row: 0
      })
      .translate(-1.5, 0, 0)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 4,
      letter: "m"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: -1,
        row: 1
      })
      .translate(-1.5, 0, 0)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 2,
      letter: "i"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: 0,
        row: -1
      })
      .translate(0, 5, -5)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 3,
      home: "middle",
      letter: "k"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: 0,
        row: 0
      })
      .translate(0, 5, -5)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 4,
      letter: ","
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: 0,
        row: 1
      })
      .translate(0, 5, -5)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 2,
      letter: "o"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: 1,
        row: -1
      })
      .translate(0, 0, -2)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 3,
      home: "ring",
      letter: "l"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: 1,
        row: 0
      })
      .translate(0, 0, -2)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 4,
      letter: "."
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...curvature,
        column: 1,
        row: 1
      })
      .translate(0, 0, -2)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 2,
      letter: "p"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...pinkyCurvature,
        column: 2,
        row: -1
      })
      .translate(3, -10, 10)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 3,
      home: "pinky",
      letter: ";"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...pinkyCurvature,
        column: 2,
        row: 0
      })
      .translate(3, -10, 10)
      .transformBy(upperKeysPlane)
  },
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 4,
      letter: "/"
    },
    aspect: 1,
    cluster: "fingers",
    position: new Trsf()
      .placeOnMatrix({
        ...pinkyCurvature,
        column: 2,
        row: 1
      })
      .translate(3, -10, 10)
      .transformBy(upperKeysPlane)
  }
]

/**
 * The plane used to position the thumbs.
 * It's defined using a nearby key position,
 * then offset by some amount.
 */
const thumbOrigin = new Trsf()
  .rotate(0, [0, 0, 0], [1, 0, 0])
  .rotate(-60, [0, 0, 0], [0, 1, 0])
  .rotate(30, [0, 0, 0], [0, 0, 1])
  .translate(-45, 0, -15)
  .translateBy(new Trsf()
    .placeOnMatrix({
      ...curvature,
      row: 1,
      column: -1.5
    })
    .transformBy(upperKeysPlane)
    .translate(8.75, -8.75, 0)
  )
  .translate(9, -7, -5)

/** The curvature of the thumb cluster. */
const thumbCurvature = {
  curvatureOfRow: 0,
  curvatureOfColumn: 0,
  spacingOfColumns: 19,
  spacingOfRows: 20
}

const thumbs: Key[] = [
  {
    type: "choc",
    keycap: {
      profile: "choc",
      row: 5,
      letter: " ",
      home: "thumb"
    },
    cluster: "thumbs",
    aspect: 1,
    position: new Trsf()
      .rotate(0, [0, 0, 0], [1, 0, 0])
      .rotate(0, [0, 0, 0], [0, 1, 0])
      .rotate(0, [0, 0, 0], [0, 0, 1])
      .placeOnMatrix({
        ...thumbCurvature,
        column: 0,
        row: 0
      })
      .transformBy(thumbOrigin)
  },
  {
    type: "choc",
    keycap: { profile: "choc", row: 5 },
    cluster: "thumbs",
    aspect: 1,
    position: new Trsf()
      .rotate(0, [0, 0, 0], [1, 0, 0])
      .rotate(0, [0, 0, 0], [0, 1, 0])
      .rotate(0, [0, 0, 0], [0, 0, 1])
      .placeOnMatrix({
        ...thumbCurvature,
        column: 1,
        row: 0
      })
      .transformBy(thumbOrigin)
  }
]

const wristRestOrigin = new Trsf()
  .translateBy(new Trsf()
    .placeOnMatrix({
      ...curvature,
      row: 1,
      column: -1
    })
    .transformBy(upperKeysPlane)
    .translate(8.75, -8.75, 0)
  )
  .rotate(0, [0, 0, 0], [0, 0, 1])
  .translate(4, -5, 4)

export default {
  ...options,
  wristRestOrigin,
  keys: [...fingers, ...thumbs],
}
