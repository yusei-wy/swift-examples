struct TimesTable {
  let multipiler: Int
  subscript(index: Int) -> Int {
    return multipiler * index
  }
}

let threeTimesTable = TimesTable(multipiler: 3)
print("six times three is \(threeTimesTable[6])")

struct Matrix {
  let rows: Int, columns: Int
  var grid: [Double]
  init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    grid = Array(repeating: 0.0, count: rows * columns)
  }
  func indexIsValid(row: Int, column: Int) -> Bool {
    return 0 <= row && row < rows && 0 <= column && column < columns
  }
  subscript(row: Int, column: Int) -> Double {
    get {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      return grid[(row * columns) + column]
    }
    set {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      grid[(row * columns) + column] = newValue
    }
  }
}

var matrix = Matrix(rows: 2, columns: 2)
print(matrix)

matrix[0, 1] = 1.5
print(matrix)
matrix[1, 0] = 3.2
print(matrix)

/// Type Subscripts
enum Planet: Int {
  case mercury = 1
  case venus, earth, mars, jupiter, saturn, uranus, neptune
  static subscript(n: Int) -> Planet {
    return Planet(rawValue: n)!
  }
}
let mars = Planet[4]
print(mars)
