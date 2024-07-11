/// エスケープクロージャ - Escaping Closures
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
  completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
  closure()
}

class SomeClass {
  var x = 50
  func doSomething() {
    someFunctionWithEscapingClosure { self.x = 100 }
    someFunctionWithNonescapingClosure { x = 200 }
  }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)

completionHandlers.first?()
print(instance.x)

class SomeOtherClass {
  var x = 10
  func doSomething() {
    someFunctionWithEscapingClosure { [self] in x = 200 }
    someFunctionWithNonescapingClosure { x = 200 }
  }
}

// struct SomeStruct {
//   var x = 10
//   mutating func doSomething() {
//     someFunctionWithNonescapingClosure { x = 200 }  // OK
//     someFunctionWithEscapingClosure { x = 100 }  // Error
//   }
// }

/// 自動クロージャ - Autoclosures
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)

print("ただ今 \(customerProvider()) を接客中！")
print(customersInLine.count)

func serve(customer customerProvider: () -> String) {
  print("ただ今 \(customerProvider()) を接客中！")
}
serve(customer: { customersInLine.remove(at: 0) })

var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvicer: @autoclosure @escaping () -> String) {
  customerProviders.append(customerProvicer)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("\(customerProviders.count) 個のクロージャーが保持されています")
for customerProvider in customerProviders {
  print("ただ今 \(customerProvider()) を接客中！")
}

// /// ARC in Action
// class Person {
//   let name: String
//   init(name: String) {
//     self.name = name
//     print("\(name) の初期化が進行中です")
//   }
//   deinit {
//     print("\(name) のインスタンス割当が解除されました")
//   }
// }

// var reference1: Person?
// var reference2: Person?
// var reference3: Person?
// reference1 = Person(name: "John Applessed")
// reference2 = reference1
// reference3 = reference1
// reference1 = nil
// reference2 = nil
// reference3 = nil

// /// Strong Reference Cycles Between Class Instances
// class Person {
//   let name: String
//   init(name: String) { self.name = name }
//   var apartment: Apartment?
//   deinit { print("\(name) のインスタンス割当が解除されました") }
// }

// class Apartment {
//   let unit: String
//   init(unit: String) { self.unit = unit }
//   var tanant: Person?
//   deinit { print("アパート \(unit) のインスタンス割当が解除されました") }
// }

// var john: Person?
// var unit4A: Apartment?
// john = Person(name: "John Applessed")
// unit4A = Apartment(unit: "4A")
// john?.apartment = unit4A
// unit4A?.tanant = john
// john = nil
// unit4A = nil

// /// 弱参照 - Weak References
// class Person {
//   let name: String
//   init(name: String) { self.name = name }
//   var apartment: Apartment?
//   deinit { print("\(name) のインスタンス割当が解除されました") }
// }

// class Apartment {
//   let unit: String
//   init(unit: String) { self.unit = unit }
//   weak var tanant: Person?
//   deinit { print("アパート \(unit) のインスタンス割当が解除されました") }
// }

// var john: Person?
// var unit4A: Apartment?

// john = Person(name: "John Applessed")
// unit4A = Apartment(unit: "4A")

// john?.apartment = unit4A
// unit4A?.tanant = john

// john = nil
// unit4A = nil

/// 非所有参照 - Unowned References
class Customer {
  let name: String
  var card: CreditCard?
  init(name: String) { self.name = name }
  deinit { print("\(name) のインスタンス割当が解除されました") }
}

class CreditCard {
  let number: UInt64
  unowned let customer: Customer
  init(number: UInt64, customer: Customer) {
    self.number = number
    self.customer = customer
  }
  deinit { print("カード番号 #\(number) のインスタンス割当が解除されました") }
}

var john: Customer?
john = Customer(name: "John Appleseed")
john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
john = nil

/// オプショナル値への非所有参照 -Unowned Optional References
class Department {
  var name: String
  var courses: [Course]
  init(name: String) {
    self.name = name
    self.courses = []
  }
}

class Course {
  var name: String
  unowned var department: Department
  unowned var nextCourse: Course?
  init(name: String, in department: Department) {
    self.name = name
    self.department = department
    self.nextCourse = nil
  }
}
