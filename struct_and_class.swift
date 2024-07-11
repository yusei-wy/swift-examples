struct Resolution {
  var width = 0
  var height = 0
}

class VideoMode {
  var resolution = Resolution()
  var interlaced = false
  var frameRate = 0.0
  var name: String?
}

let vga = Resolution(width: 640, height: 480)

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048

print(hd)
print(cinema)

enum CompassPoint {
  case north, south, east, west
  mutating func turnNorth() {
    self = .north
  }
}

var currentDirection = CompassPoint.west
let rememberdDirection = currentDirection
currentDirection.turnNorth()

print("The current direction is \(currentDirection)")
print("The remembered direction is \(rememberdDirection)")

let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")

struct FixedLengthRange {
  var firstValue: Int
  let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
print(rangeOfThreeItems)
rangeOfThreeItems.firstValue = 6
print(rangeOfThreeItems)

class DataImporter {
  /*
  DataImporter は外部ファイルからデータをインポートするためのクラス
  このクラスは初期化にかなりの時間がかかると想定します
  */
  var filename = "data.txt"
}

class DataManager {
  lazy var importer = DataImporter()
  var data = [String]()
  // ここでデータを管理する
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// DataImporter インスタンスはまだ作成されていない
print(manager.importer.filename)

struct Point {
  var x = 0.0, y = 0.0
}
struct Size {
  var width = 0.0, height = 0.0
}
struct Rect {
  var origin = Point()
  var size = Size()
  var center: Point {
    get {
      let centerX = origin.x + (size.width / 2)
      let cneterY = origin.y + (size.height / 2)
      return Point(x: centerX, y: cneterY)
    }
    set(newCenter) {
      origin.x = newCenter.x - (size.width / 2)
      origin.y = newCenter.y - (size.height / 2)
    }
  }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
