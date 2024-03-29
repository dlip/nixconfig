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
  /*
  wristRest: {
    length: 80,
    maxWidth: 100,
    xOffset: 30,
    zOffset: 0,
    angle: 3,
    tenting: 6
  },
  */
  microcontroller: "waveshare-rp2040-zero",
  fastenMicrocontroller: true,
  verticalClearance: 0.1,
  clearScrews: true,
  shell: { type: "basic", lip: false }
}
// NOTE: Screws / the connector with
// negative indices are placed automatically.
// In the basic/advanced tab, these values were:
// screwIndices: [9.5, 16.5, 2.5, 20.5, 13.5, 5.5, 22.5]
// connectorIndex: 27.2

const curvature = {
  curvatureOfColumn: 30,
  curvatureOfRow: 5,
  spacingOfRows: 20.5,
  spacingOfColumns: 21.5
}

/**
 * Useful for setting a different curvature
 * for the pinky keys.
 */
const pinkyCurvature = {
  ...curvature,
  curvatureOfColumn: 20
}

/**
 * The plane used to position the upper keys.
 * It's rotated by the tenting and x rotation
 * then translated by the z offset.
 */
const upperKeysPlane = new Trsf()
  .rotate(17, [0, 0, 0], [0, 1, 0], false)
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
      .translate(0, 0, 0)
      .translate(10, 7, 0)
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
        column: -1.5,
        row: -1
      })
      .translate(0, 0, 0)
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
        column: -1.5,
        row: 0
      })
      .translate(0, 0, 0)
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
        column: -1.5,
        row: 1
      })
      .translate(0, 0, 0)
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
        column: -0.5,
        row: -1
      })
      .translate(0, 2.8, -6.5)
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
        column: -0.5,
        row: 0
      })
      .translate(0, 2.8, -6.5)
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
        column: -0.5,
        row: 1
      })
      .translate(0, 2.8, -6.5)
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
        column: 0.5,
        row: -1
      })
      .translate(0, 0, 0)
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
        column: 0.5,
        row: 0
      })
      .translate(0, 0, 0)
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
        column: 0.5,
        row: 1
      })
      .translate(0, 0, 0)
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
        column: 1.5,
        row: -1
      })
      .translate(0, -10, 6)
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
        column: 1.5,
        row: 0
      })
      .translate(0, -10, 6)
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
        column: 1.5,
        row: 1
      })
      .translate(0, -10, 6)
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
  .translate(4, -5, 4)

const thumbs: Key[] = [
  {
    type: "choc",
    aspect: 1,
    cluster: "thumbs",
    position: new Trsf()
      .rotate(0, [0, 0, 0], [1, 0, 0])
      .rotate(0, [0, 0, 0], [0, 1, 0])
      .rotate(0, [0, 0, 0], [0, 0, 1])
      .translate(19, 0, 0)
      .transformBy(thumbOrigin),
    keycap: { profile: "choc", row: 5 }
  },
  {
    type: "choc",
    aspect: 1,
    cluster: "thumbs",
    position: new Trsf()
      .rotate(0, [0, 0, 0], [1, 0, 0])
      .rotate(0, [0, 0, 0], [0, 1, 0])
      .rotate(0, [0, 0, 0], [0, 0, 1])
      .translate(0, 0, 0)
      .transformBy(thumbOrigin),
    keycap: { profile: "choc", row: 5 }
  },
]

const wristRestOrigin = new Trsf()
  .rotate(0, [0, 0, 0], [0, 0, 1])
  .translateBy(new Trsf()
    .placeOnMatrix({
      ...curvature,
      row: 1,
      column: -1.5
    })
    .transformBy(upperKeysPlane)
    .translate(8.75, -8.75, 0)
  )
  .translate(4, -5, 4)

export default {
  ...options,
  wristRestOrigin,
  keys: [...fingers, ...thumbs],
}
