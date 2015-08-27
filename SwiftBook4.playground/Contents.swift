
/* TYPE CASTING */

// Check the type of an instance ("is")
// Treat the instance as if it were a superclass or subclass of its current type ("as")
// Casting does not modify its instance; the instance is just treated and accessed as a different type

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

// library: [MediaType]
let library = [
    Movie(name: "Pulp Fiction", director: "Quentin Tarantino"),
    Song(name: "So Did We", artist: "Isis"),
    Movie(name: "Donnie Darko", director: "Richard Kelly"),
    Song(name: "In Awe Of", artist: "Cult of Luna"),
    Song(name: "Under the Surface", artist: "Neurosis")
]

// Use "is" to check type
for item in library {
    if item is Movie {
        print("Movie: \(item.name)")
    }
    else if item is Song {
        print("Song: \(item.name)")
    }
}


// DOWNCASTING

// Can check if instance is superclass or subclass in the same hierarchy
// Use as? (conditional) to return optional, or as! (forced)
for item in library {
    if let movie = item as? Movie {
        print("Movie: '\(movie.name)', director: '\(movie.director)'")
    }
    else if let song = item as? Song {
        print("Song: '\(song.name)', artist: '\(song.artist)'")
    }
}

// AnyObject - Represents an instance of any class
// Any - Represents and instance of any type (including closures)
// Useful for interacting with Obj-C objects such as arrays and dictionaries
// Use Any and AnyObject ONLY when they are explicitly needed - It is better to always specify types

var things = [Any]()
things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14)
things.append((2.0, 5.0))
things.append(Movie(name: "Interstellar", director: "Christopher Nolan"))
things.append({ (name: String) -> String in "Hello, \(name)" })

for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as Int")
    case 0 as Double:
        print("zero as Double")
    case let someInt as Int:
        print("An Int: \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("Positive Double: \(someDouble)")
    case let (x,y) as (Double, Double):
        print("An (x,y) point: \(x,y)")
    case let movie as Movie:
        print("Movie: '\(movie.name)', 'director: '\(movie.director)'")
    case let stringConverter as String -> String:
        print(stringConverter("Anthony"))
    default:
        print("Something else")
    }
}






/* NESTED TYPES */

// Classes, Enumerations, and Structures
// To refer to nested type, prefix it with the type it is enclosed in (Type.NestedType)






/* EXTENSIONS */

// Add new functionality to existing class, structure, enumeration, or protocol
// Similar to Categories in Obj-C
// Extensions can be used to:
//      1) Add computed properties
//      2) Define new instance and type methods
//      3) Define new convenience initializers
//      4) Define subscripts
//      5) Define and use nested types
//      6) Make an existing type conform to a protocol
// Extensions CANNOT override existing functionality

// Syntax:
class SomeType { }
protocol SomeProtocol { }
extension SomeType: SomeProtocol {
    // New functionality
}


// INITIALIZERS

// Extensions can only add convenience initializers
// These initializers can access default initializers and memberwise initializers

struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))
centerRect.origin.x


extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
3.repetitions { () -> Void in
    print("Betelgeuse")
}






/* PROTOCOLS */

// Blueprint of methods, properties, and other requirements to be adopted by a class, structure, or enumeration
// Can extend protocols
// Syntax:
//      class SomeClass: SomeSuperClass, FirstProtocol, SecondProtocol


// PROPERTY REQUIREMENTS
// Can specify if properties have both getter and setter or just a getter
// Cannot specify whether property is stored or computed

protocol SomeProtocol2 {
    var gettableAndSettable: Int { get set }
    var gettableOnly: Int { get }
    static var typeProperty: Int { get set }
}


// METHOD REQUIREMENTS
// Can specify instance or type methods
// Cannot provide default values for parameters

protocol SomeProtocol3 {
    static func someTypeMethod()
    func random() -> Double
    mutating func toggle() // Only needed for structures and enumerations
}


// INITIALIZER REQUIREMENTS
// Can create designated, convenience, and failable initializers
// Must always include "required" modifier in the implementation so that all subclasses implement the initializer

protocol SomeProtocol4 {
    init()
}

class SomeSuperClass {
    init() { }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // "required" not necessary for final classes
    required override init() { }
}


// PROTOCOLS AS TYPES
// Protocols can be used like any other type. For example:
//      1) As a parameter or return type for a function, method, or initializer
//      2) As a constant, variable, or property
//      3) As the type of items in a collection


// DELEGATION
// Definition: A design pattern to enable a class or structure to assign some of its responsibilities to an instance of another type


// PROTOCOL EXTENSIONS
// Can extend existing types to conform to a protocol
// If a type already implements all the requirements of a protocol, it still needs to explicitly conform to it to be used as the protocol type

protocol TextRepresentable {
    func asText() -> String
}

extension SomeSubClass: TextRepresentable {
    func asText() -> String {
        return "This is some subclass"
    }
}


// EXTENDING PROTOCOLS
// Protocols can be extended to provide default implementation

extension SomeProtocol3 {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

// Can use extensions to specify constraints that conforming types must satisfy, using "where" clauses

extension CollectionType where Generator.Element: TextRepresentable {
    func asList() -> String {
        let itemAsText = self.map { $0.asText() }
        return "(" + ", ".join(itemAsText) + ")"
    }
}


// PROTOCOL INHERITANCE
// Protocols can inherit each other
// Anything conforming to a "sub" protocol must implement all the associated protocols


// CLASS-ONLY PROTOCOLS
// Used when behavior defined by protocol assumes that the conforming type has reference (not value) semantics

protocol SomClassOnlyProtocol: class, SomeProtocol, SomeProtocol2 {
    
}


// PROTOCOL COMPOSITION
// Combine multiple protocols into one
// Syntax: protocol<SomeProtocol, AnotherProtocol>

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Someone: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(celebrator: protocol<Named, Aged>) {
    print("Happy \(celebrator.age) birthday \(celebrator.name)")
}

let birthdayPerson = Someone(name: "Anthony", age: 24)
wishHappyBirthday(birthdayPerson)


// CHECKING FOR PROTOCOL CONFORMANCE
// Use type casting

protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    static let pi = 3.14159
    var radius: Double
    var area: Double {
        return Circle.pi * radius * radius
    }
    init(radius: Double) {
        self.radius = radius
    }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    SomeSubClass()
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    }
    else {
        print("Object does not have an area")
    }
}


// OPTIONAL PROTOCOL REQUIREMENTS
// Useful for interacting with Obj-C code (must have @objc attribute)
// Syntax: @objc protocol, and "optional" before method/property
// Must use optional chaining when accessing optionla methods/properties

import Foundation

@objc protocol CounterDataSource {
    optional func incrementForCount(count: Int) -> Int
    optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?(count) {
            count += amount
        }
        else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}






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
protocol MyProtocol { }
func someFunction<T: SomeClass, U: MyProtocol>(someT: T, someU: U) { }


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
