

/* OPTIONAL CHAINING */

// Process for querying and calling properties, methods, and subscripts on an optional that may currently be nil
// If optional is nil, the property/method/subscript returns nil (gracefully - no runtime error)
// Similar to messaging in Obj-C, but works for any type and can be checked for success or failure

class Person3 {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

let anton = Person3()
// roomCount is of type Int?
if let roomCount = anton.residence?.numberOfRooms {
    print("Anton's residence has \(roomCount) rooms")
} else {
    print("Unknown number of rooms")
}


// More complex example:

class Person_ {
    var residence: Residence_?
}

class Residence_ {
    var address: Address?
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("Number of rooms is \(numberOfRooms)")
    }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        }
        else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        }
        else {
            return nil
        }
    }
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

let mike = Person_()
let roomCount = mike.residence?.numberOfRooms // residence is nil, so roomCount becomes nil

let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
mike.residence?.address = someAddress // residence is nil, so this assignment does nothing

let mikesHouse = Residence_()
mikesHouse.rooms.append(Room(name: "Bathroom"))
mike.residence = mikesHouse
mike.residence?.address = someAddress // This assignment works now that mike.residence is not nil
mike.residence?.address?.buildingIdentifier()
mike.residence?[0].name // Subscripts have optional before the brackets
let mikesStreet = mike.residence?.address?.street






/* ERROR HANDLING */

// Swift supports throwing, catching, propagating, and manipulating errors
// Unlike most other languages, Swift does not unwind the call stack (computationally expensive)
// Errors are represented by types that conform to the "ErrorType" protocol
// Enums can be used to create new ErrorTypes

enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(centsNeeded: Int)
    case OutOfStock
}

struct Item {
    var price: Int
    var count: Int
}

var inventory = ["Candy bar": Item(price: 125, count: 7),
    "Chips": Item(price: 100, count: 4),
    "Pretzels": Item(price: 75, count: 11)]

var amountDeposited = 100

func vend(itemNamed name: String) throws { // Need the "throws" keyword if try/catch is not used
    guard var item = inventory[name] else {
        throw VendingMachineError.InvalidSelection
    }
    
    guard item.count > 0 else {
        throw VendingMachineError.OutOfStock
    }
    
    if amountDeposited >= item.price {
        // Dispense the snack
        amountDeposited -= item.price
        --item.count
        inventory[name] = item
    } else {
        let amountNeeded = item.price - amountDeposited
        throw VendingMachineError.InsufficientFunds(centsNeeded: amountNeeded)
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
// Need to use "try" when calling a function that can throw exceptions
func buyFavoriteSnack(person: String) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vend(itemNamed: snackName)
}


// CATCHING AND HANDLING ERRORS

// Catch clauses must be exhaustive. For default, you can use catch with no parameters
do {
    try vend(itemNamed: "Candy bar")
} catch VendingMachineError.InvalidSelection {
    print("Invalid selection")
} catch VendingMachineError.OutOfStock {
    print("Out of stock")
} catch VendingMachineError.InsufficientFunds(let amountNeeded) {
    print("Insufficient funds. Please insert an additional \(amountNeeded) cents.")
    // Final catch is not needed; it is here to show how to catch all remaining errors
} catch {
    print("Some unknown exception occurred")
}


// DISABLING ERROR PROPAGATION

// Syntax: try!

enum myErrors: ErrorType {
    case someError
}

func willOnlyThrowIfTrue(value: Bool) throws {
    if value {
        throw myErrors.someError
    }
}

do {
    try willOnlyThrowIfTrue(true)
} catch {
    print("Threw an exception!")
}
try! willOnlyThrowIfTrue(false) // If true, this would trigger a runtime exception


// CLEAN-UP ACTIONS

// Defer statements defer execution until the current scope is exited
// Useful for closing file descriptors, freeing manually allocated memory, etc.
// Cannot transfer control out of the statements (no break, return, etc.)
// Defer statements are executed in reverse orders

func processFile(filename: String) throws {
    if !filename.isEmpty {
        // let file = open(filename)
        defer {
            // close(file)
            print("Calling second defer")
        }
        defer {
            print("Calling first defer")
        }
        // while let line = try file.readline() { ... }
        
        // Defer statements get called here
    }
}
try! processFile("nsa.txt")






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





