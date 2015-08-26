

/* GENERICS */

// Generics allow for flexible, reusable functions and types that can work with any type (subject to any defined requirements)

// Type parameters should be named in UpperCamelCase, or use generic T, U, V
// "T" is a type parameter in this function
func swapTwoValues<T>(inout a: T, inout _ b: T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var double1 = 5.0
var double2 = 2.0
swapTwoValues(&double1, &double2)
double1
double2


// GENERIC TYPES

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// Extending generic types

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}


// TYPE CONSTRAINTS
// Specify requirements for generic types
// Swift dictionaries have the type constraint that all keys must be hashable

class SomeClass { }
protocol SomeProtocol { }
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) { }


// ASSOCIATED TYPES
// Protocol's equivalent of type parameters

protocol Container {
    typealias ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct IntStack: Container {
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // Conforming to Container protocol
    typealias ItemType = Int // This line is optional
    mutating func append(item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}


// WHERE CLAUSES

func allItemsMatch
    <C1: Container, C2: Container where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
    (someContainer: C1, _ anotherContainer: C2) -> Bool {
        
        if someContainer.count != anotherContainer.count { return false }
        
        for i in 0...someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        return true
}






/* ACCESS CONTROL */





