protocol Shape {
  func draw() -> String
}

struct Triangle: Shape {
  var size: Int
  func draw() -> String {
    var result: [String] = []
    for length in 1...size {
      result.append(String(repeating: "*", count: length))
    }

    return result.joined(separator: "\n")
  }
}
let smallTriangle = Triangle(size: 3)
// print(smallTriangle.draw())

struct FlippedShape<T: Shape>: Shape {
  var shape: T
  func draw() -> String {
    if shape is Shape {
      return shape.draw()
    }

    let lines = shape.draw().split(separator: "\n")

    return lines.reversed().joined(separator: "\n")
  }
}
let flippedTriangle = FlippedShape(shape: smallTriangle)
// print(flippedTriangle.draw())

struct JoinedShape<T: Shape, U: Shape>: Shape {
  var top: T
  var bottom: U
  func draw() -> String {
    return top.draw() + "\n" + bottom.draw()
  }
}
let joinedTriangle = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
// print(joinedTriangle.draw())

struct Square: Shape {
  var size: Int
  func draw() -> String {
    let line = String(repeating: "*", count: size)
    let result = [String](repeating: line, count: size)

    return result.joined(separator: "\n")
  }
}

func makeTrapezoid() -> some Shape {
  let top = Triangle(size: 2)
  let middle = Square(size: 2)
  let bottom = FlippedShape(shape: top)
  let trapezoid = JoinedShape(
    top: top,
    bottom: JoinedShape(
      top: middle,
      bottom: bottom
    )
  )

  return trapezoid
}
let trapezoid = makeTrapezoid()
// print(trapezoid.draw())

func flip<T: Shape>(_ shape: T) -> some Shape {
  return FlippedShape(shape: shape)
}
func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
  JoinedShape(top: top, bottom: bottom)
}

let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle))
// print(opaqueJoinedTriangles.draw())

// func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//   if shape is Square {
//     return shape  // エラー: 戻り値の型が一致しません
//   }

//   return FlippedShape(shape: shape)  // エラー: 戻り値の型が一致しません
// }

func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
  return [T](repeating: shape, count: count)
}

/// Boxed Protocol Types
struct VerticalShapes: Shape {
  var shapes: [any Shape]
  func draw() -> String {
    return shapes.map { $0.draw() }.joined(separator: "\n\n")
  }
}

let largeTriangle = Triangle(size: 5)
let largeSquare = Square(size: 5)
let vertical = VerticalShapes(shapes: [largeTriangle, largeSquare])
print(vertical.draw())

if let downcastTriangle = vertical.shapes[0] as? Triangle {
  print(downcastTriangle.size)
}

protocol Container {
  associatedtype Item
  var count: Int { get }
  subscript(i: Int) -> Item { get }
}
extension Array: Container {}

// // エラー：関連方があるプロトコルは戻り値の方として使用できません
// func makeProtocolContainer<T>(item: T) -> Container {
//   return [item]
// }

// // エラー： C を推論するための十分な情報がありません
// func makeProtocolContainer<T, C: Container>(item: T) -> C {
//   return [item]
// }

func makeOpaqueContainer<T>(item: T) -> some Container {
  return [item]
}
let opaqueContainer = makeOpaqueContainer(item: 12)
let twelve = opaqueContainer[0]
print((type(of: twelve)), twelve)
