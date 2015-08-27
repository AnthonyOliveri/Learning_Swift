

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

// Restricts access to code from other code located in different source files and modules
// Can assign access to almost anything
//      Classes, structs, enums, properties, methods, initializers, subscripts, protocols

// A "module" is single unit of code distribution
//      Ex - framework or app
//      Each target in an Xcode project is its own module

// Three access levels:
//      Public - accessible to other modules
//      Internal - accessible only within the module - THIS IS THE DEFAULT LEVEL
//      Private - accessible only within the source file

// CORE PRINCIPLE: No entity can be defined in terms of another entity that has a more restrictive access level
//      A public property could not be accessed in another module because its internal/private type could not be
//      A public function could not be called in another module that has no access to its internal/private parameters or return type

// Unit testing: Can only access public and internal code

// Syntax:
public class publicClass { }
internal class internalClass { } // internal modifier is not required
private class privateClass { }

public var publicVariable = 0
internal let internalConstant = 0 // internal modifier is not required
private func privateFunction() { }


// CUSTOM TYPES

// Public and internal types have default members with internal access
//      For type members that are part of an API, they MUST be explicitly declared "public"
// Private types have default members with private access

// Tuple types - Access level of most restrictive type
// Function types - Access level of most restrictive parameter or return type
// Enum types - All cases automatically get same access level as the containing type, and cannot be changed
//      accessLevel (rawValues) >= accessLevel (enumType)
// Nested types
//      Internal if nested inside a public or internal type
//      Private if nested inside a private type


// SUBCLASSING

// Subclass cannot have higher access level than its superclass
// Subclasses can override any class member and give it ANY access level, regardless of the level in the superclass

public class SomeClass2 {
    private func someMethod() { }
}

internal class SomeClass3: SomeClass2 {
    override internal func someMethod() { }
}


// CONSTANTS, VARIABLES, PROPERTIES, AND SUBSCRIPTS

// Cannot be more public than its type
// Subscripts cannot be more public than its index and return type

// Getters and setters automatically get same access level
// Can give setter a lower access level than the getter
//      Applies to both stored and computed properties

public struct TrackedString {
    public private(set) var numberOfEdits = 0 // Public getter, private setter
    public var value: String = "" {
        didSet {
            numberOfEdits++
        }
    }
}


// INITIALIZERS

// Custom initializers cannot have an access level higher than the enclosing type
//      Cannot have access level higher than parameter types
// Default initializers are internal for public/internal types, and private for private types
// Default memberwise initializers for structs are internal, or private if any properties are private


// PROTOCOLS

// All requirements automatically have the same access level as the enclosing protocol
// Protocols cannot have higher access levels than protocols they inherit
// A type can conform to a protocol if it has an equal or higher access level
//      The conformance part of the type will have an access level of whichever is lower: the type or the protocol
// Cannot conform to a protocol in 2 different ways in the same program


// EXTENSIONS

// Extended types keep the same access level
// Members added to extensions follow the same rules as normal types
// Extension can be marked public, internal, or private to set the default access type of all members
//      This can be overridden by individual members
//      Not possible when using extension to conform to protocol; the protocol's access level gets used


// TYPE ALIAS

// Can have an access level less than or equal to the level of the type it aliases
//      Public alias cannot alias a private or internal type





/* ADVANCED OPERATORS */

// Swift operators do NOT overflow by default - An error gets thrown instead
// To allow overflow to occur, using & (&+, &-, &*)


// BITWISE OPERATORS

// NOT ~
// AND &
// OR  |
// XOR ^
// Bitwise left shift <<
// Bitwise right shift >>


// OVERLOADING EXISTING OPERATORS

struct Vector2D {
    var x = 0.0, y = 0.0
}

// Global function so that all instances of Vector2D can use this operator
func + (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}

let someVector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 3.0, y: 1.0)
let combinedVector = someVector + anotherVector
(combinedVector.x, combinedVector.y)

// Prefix/postfix operators

prefix func - (vector: Vector2D) -> Vector2D {
    return Vector2D(x: -vector.x, y: -vector.y)
}

let negativeVector = -someVector

// Compount assignment operators

// Left parameter must be inout since it is being modified
func += (inout left: Vector2D, right: Vector2D) {
    left = left + right
}

prefix func ++ (inout vector: Vector2D) -> Vector2D {
    vector += Vector2D(x: 1.0, y: 1.0)
    return vector
}

// Equivalence Operators

func == (left: Vector2D, right: Vector2D) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

func != (left: Vector2D, right: Vector2D) -> Bool {
    return !(left == right)
}


// CUSTOM OPERATORS

// Define at the global level
prefix operator +++ {}

prefix func +++ (inout vector: Vector2D) -> Vector2D {
    vector += vector
    return vector
}

// Prefix and associativity

infix operator +- { associativity left precedence 140 }

func +- (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y - right.y)
}
















