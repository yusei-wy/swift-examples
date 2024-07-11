enum Barcode {
  case upc(Int, Int, Int, Int)
  case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
print(productBarcode)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
print(productBarcode)

enum Version {
  case string(Int, Int, Int)
  case number(Int)
}

var version = Version.string(1, 2, 3)

switch version {
case let .string(major, minor, patch):
  print("Version \(major).\(minor).\(patch)")
case let .number(release):
  print("Version \(release)")
}

/// Raw Values
enum ASCIIControlCharacter: Character {
  case tab = "\t"
  case lineFeed = "\n"
  case carriageReturn = "\r"
}

/// Implicity Assigned Raw Values
enum Planet: Int {
  case mercury = 1
  case venus, earth, mars, jupiter, saturn, uranus, neptune
}

enum CompassPoint: String {
  case north, south, east, west
}

let earthsOrder = Planet.earth.rawValue
print(earthsOrder)

let sunsetDirection = CompassPoint.west.rawValue
print(sunsetDirection)

let possiblePlanet = Planet(rawValue: 99)
print(possiblePlanet?.rawValue)

/// Recursive Enumerations
// enum ArithmeticExpression {
//   case number(Int)
//   indirect case addition(ArithmeticExpression, ArithmeticExpression)
//   indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
// }
indirect enum ArithmeticExpression {
  case number(Int)
  case addition(ArithmeticExpression, ArithmeticExpression)
  case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
  switch expression {
  case let .number(value):
    return value
  case let .addition(left, right):
    return evaluate(left) + evaluate(right)
  case let .multiplication(left, right):
    return evaluate(left) * evaluate(right)
  }
}

print(evaluate(product))
