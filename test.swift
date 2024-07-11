class NamedShape {
  var numberOfSides: Int = 0
  var name: String

  init(name: String) {
    self.name = name
  }

  func simpleDescription() -> String {
    return "A shape with \(numberOfSides) sides."
  }
}

class Square: NamedShape {
  var sideLength: Double

  init(sideLength: Double, name: String) {
    self.sideLength = sideLength
    super.init(name: name)
    numberOfSides = 4
  }

  func area() -> Double {
    return sideLength * sideLength
  }

  override func simpleDescription() -> String {
    return "A square with sides of length \(sideLength)."
  }
}

let test = Square(sideLength: 5.2, name: "myu test square")
print(test.area())
print(test.simpleDescription())

class EquilateralTriangle: NamedShape {
  var sideLength: Double = 0.0

  init(sideLength: Double, name: String) {
    self.sideLength = sideLength
    super.init(name: name)
    numberOfSides = 3
  }

  var perimeter: Double {
    get {
      return 3.0 * sideLength
    }
    set {
      sideLength = newValue / 3.0
    }
  }

  override func simpleDescription() -> String {
    return "An equilateral triangle with sides of length \(sideLength)."
  }
}

var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
triangle.perimeter = 9.9
print(triangle.sideLength)

class TriangleAndSquare {
  var triangle: EquilateralTriangle {
    willSet {
      square.sideLength = newValue.sideLength
    }
  }

  var square: Square {
    willSet {
      triangle.sideLength = newValue.sideLength
    }
  }

  init(size: Double, name: String) {
    square = Square(sideLength: size, name: name)
    triangle = EquilateralTriangle(sideLength: size, name: name)
  }
}

var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "large square")
print(triangleAndSquare.square.sideLength)

let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
print(optionalSquare?.sideLength ?? 0.0)

enum Rank: Int {
  case ace = 1
  case two, three, four, five, six, seven, eight, nine, ten
  case jack, queen, kind

  func toString() -> String {
    switch self {
    case .ace:
      return "ace"
    case .jack:
      return "jack"
    case .queen:
      return "queen"
    case .kind:
      return "kind"
    default:
      return String(self.rawValue)
    }
  }

  func toInteger() -> Int {
    switch self {
    case .ace:
      return 1
    case .jack:
      return 11
    case .queen:
      return 12
    case .kind:
      return 13
    default:
      return self.rawValue
    }
  }

}

let ace = Rank.ace
let aceRawValue = ace.rawValue
print(ace, aceRawValue)
print(ace.toString(), ace.toInteger())

if let convertedRank = Rank(rawValue: 3) {
  let threeDescription = convertedRank.toString()
  print(threeDescription)
}

enum Suit {
  case spades, hearts, diamonds, clubs

  func toString() -> String {
    switch self {
    case .spades:
      return "spades"
    case .hearts:
      return "hearts"
    case .diamonds:
      return "diamonds"
    case .clubs:
      return "clubs"
    }
  }

  func toSymbol() -> String {
    switch self {
    case .spades:
      return "♠️"
    case .hearts:
      return "♥️"
    case .diamonds:
      return "♦️"
    case .clubs:
      return "♣️"
    }
  }
}

let hearts = Suit.hearts
print(hearts, hearts.toString(), hearts.toSymbol())

enum ServerResponse {
  case result(String, String)
  case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
case let .result(sunrise, sunset):
  print("Sunrise is at \(sunrise) and sunset is at \(sunset)")
case let .failure(message):
  print("Failure... \(message)")
}

struct Card {
  var rank: Rank
  var suit: Suit

  func toString() -> String {
    return "The \(rank.toString()) of \(suit.toString())"
  }
}

let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfspadesDescription = threeOfSpades.toString()
print(threeOfSpades, threeOfspadesDescription)

func fetchUserId(from server: String) async -> Int {
  if server == "primary" {
    return 97
  }

  return 501
}

func fetchUsername(from server: String) async -> String {
  let userId = await fetchUserId(from: server)
  if userId == 501 {
    return "John Appleseed"
  }

  return "Guest"
}

func connectUser(to server: String) async {
  async let userId = fetchUserId(from: server)
  async let username = fetchUsername(from: server)
  let greeting = await "Hello \(username), user ID \(userId)"
  print(greeting)
}

Task {
  await connectUser(to: "primary")
}

let userIds = await withTaskGroup(of: Int.self) { group in
  for server in ["primary", "secondary", "development"] {
    group.addTask {
      return await fetchUserId(from: server)
    }
  }

  var results: [Int] = []
  for await result in group {
    results.append(result)
  }

  return results
}

print(userIds)

actor ServerConnection {
  var server = "primary"
  private var activeUsers: [Int] = []

  func connect() async -> Int {
    let userId = await fetchUserId(from: server)
    // ... communicate with server ...
    activeUsers.append(userId)

    return userId
  }
}
let server = ServerConnection()
let userId = await server.connect()
print(server, userId)

protocol ExampleProtocol {
  var simpleDescription: String { get }
  mutating func adjust()
}

class SimpleClass: ExampleProtocol {
  var simpleDescription = "A very simple class."
  var anotherPreoperty = 69105

  func adjust() {
    simpleDescription += " Now 100% adjusted."
  }
}

var a = SimpleClass()
print(a, a.adjust())
let aDescription = a.simpleDescription
print(aDescription)

struct SimpleStructure: ExampleProtocol {
  var simpleDescription: String = "A simple structure"

  mutating func adjust() {
    simpleDescription += " (adjusted)"
  }
}

var b = SimpleStructure()
print(b, b.adjust())
let bDescription = b.simpleDescription
print(bDescription)

extension Int: ExampleProtocol {
  var simpleDescription: String {
    return "The number \(self)"
  }

  mutating func adjust() {
    self += 42
  }
}

var seven = 7
seven.adjust()
print(seven.simpleDescription)

enum PrinterError: Error {
  case outOfPaper
  case noToner
  case onFire
}

func send(job: Int, toPrinter printerName: String) throws -> String {
  if printerName == "Never Has Toner" {
    throw PrinterError.noToner
  }

  return "Job sent"
}

do {
  let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
  print(printerResponse)
} catch {
  print(error)
}

do {
  let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
  print(printerResponse)
} catch PrinterError.onFire {
  print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
  print("Printer error: \(printerError).")
} catch {
  print(error)
}

let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
print(printerSuccess)
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")
print(printerFailure)

var fridgeIsOpen = false
var fridgeContenrt = ["milk", "eggs", "leftovers"]

func fridgeContents(_ food: String) -> Bool {
  fridgeIsOpen = true
  defer {
    fridgeIsOpen = false
  }

  let result = fridgeContenrt.contains(food)
  return result
}
if fridgeContents("banana") {
  print("Found a banana")
}
print(fridgeIsOpen)

func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
  var result = [Item]()
  for _ in 0..<numberOfTimes {
    result.append(item)
  }

  return result
}
print(makeArray(repeating: "knock", numberOfTimes: 4))

// Swift 標準ライブラリの奥p書なる方の再実装
enum OPtionalValue<Wrapped> {
  case none
  case some(Wrapped)
}
var possibleInteger: OPtionalValue<Int> = .none
print(possibleInteger)
possibleInteger = .some(100)
print(possibleInteger)

func anyCommonElemetns<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
where T.Element: Equatable, T.Element == U.Element {
  for lhsItem in lhs where rhs.contains(lhsItem) {
    return true
  }

  return false
}
print("anyCommonElemetns([1, 2, 3], [3]) =", anyCommonElemetns([1, 2, 3], [3]))

let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)

let number = convertedNumber!

guard let number = convertedNumber else {
  fatalError("The number was invalid")
}

for index in "👨‍👨‍👦‍👦".indices {
  print("\(index) : \("👨‍👨‍👦‍👦"[index])")
}

let greeting = "Hello, world!"
let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index]
let newString = String(beginning)
print(beginning, newString)

var shoppingList = ["Eggs", "Milk"]
shoppingList.append("Flour")
shoppingList += ["Banking Powder"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
print(shoppingList)
shoppingList[4...6] = ["Bananas", "Apples"]
print(shoppingList)

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

print(oddDigits.union(evenDigits).sorted())
print(oddDigits.intersection(evenDigits).sorted())
print(oddDigits.subtracting(singleDigitPrimeNumbers).sorted())
print(oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted())

let temperatureInCelsius = 25
let weatherAdvice: String

let freezeWarning: String? =
  if temperatureInCelsius <= 0 {
    "氷点下です。氷に注意しましょう"
  } else {
    nil
  }
print(freezeWarning)

let approximateCount = 62
let countedThings = "土星を回る月"
let naturalCount: String
switch approximateCount {
case 0:
  naturalCount = "まったくない"
case 1..<5:
  naturalCount = "少しある"
case 5..<12:
  naturalCount = "多少ある"
case 12..<100:
  naturalCount = "数多くある"
case 100..<1000:
  naturalCount = "たくさんある"
default:
  naturalCount = "膨大にある"
}
print("\(countedThings) は \(naturalCount).")

if #available(iOS 10, macOS 10.12, *) {
  print("iOS 10 <= OS || macOS 10.12 <= OS")
} else {
  print("other")
}

@available(macOS 10.12, *)
struct ColorPreference {
  var bestColor = "blue"
}

func chooseBestColor() -> String {
  guard #available(macOS 10.12, *) else {
    return "red"
  }

  let colors = ColorPreference()
  return colors.bestColor
}

print(chooseBestColor())

func returnValue() -> Int {
  // return を省略できるのは他の処理がないときだけ
  // print("returnValue")

  1
}

print(returnValue())

let digitNames = [
  0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four",
  5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine",
]
let numbers = [16, 58, 510]

let strings = numbers.map { (number) -> String in
  var number = number
  var output = ""
  repeat {
    output = digitNames[number % 10]! + output
    number /= 10
  } while number > 0

  return output
}

print(strings)
