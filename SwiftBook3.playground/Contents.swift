

/* DEINITIALIZATION */

// Called immediately before object is deallocated (cannot be called manually)
// Only available on class types
// Only 1 deinitializer per class
// Syntax: deinit { }






/* AUTOMATIC REFERENCE COUNTING */

// Only applies to instances of classes (reference types)


// HOW ARC WORKS

// For each new class instance, a piece of memory is allocated to store it
// When the instance is no longer needed, the memory is deallocated
// ARC tracks how many properties, constants, and variables are currently referrring to each class instance
//      Properties, constants, and variables hold "strong" references to the object

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}
var person1: Person?
var person2: Person?
var person3: Person?

person1 = Person(name: "Anthony")
person2 = person1
person3 = person1

person1 = nil
person3 = nil
person2 = nil // Now "Anthony" is deinitialized


// STRONG REFERENCE CYCLES

// If 2 or more class instances hold a strong reference to each other, neither can be deinitialized
// Prevent strong reference cycles with "weak references" and "unowned references"


// WEAK REFERENCES
//      Use when it is possible for both properties to be nil
//      Must always be optional types
//      Reference becomes nil as soon as the instance it refers to gets deinitialized

class Person2 {
    let name: String
    init(name: String) {
        self.name = name
    }
    var apartment: Apartment?
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    weak var tenant: Person2?
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}

var anthony: Person2? = Person2(name: "Anthony")
var unit104: Apartment? = Apartment(unit: "104")
anthony!.apartment = unit104
unit104!.tenant = anthony
anthony = nil
unit104 = nil


// UNOWNED REFERENCES
//      Use when one property can be nil but the other cannot
//      Assumed to NEVER be nil
//      Accessing the unowned reference after its instance reference is deallocated causes a runtime error

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number: UInt64
    // Credit cards must ALWAYS be associated with a customer, so unowned is more appropriate than a weak reference
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit {
        print("Card #\(number) is being deinitialized")
    }
}

var dgonz: Customer? = Customer(name: "DGonz")
dgonz!.card = CreditCard(number: 1234_5678_9012_3456, customer: dgonz!)
dgonz = nil // Both instances for Customer and CreditCard get deinitialized


// Unowned property + implicitly unwrapped optional
//      Use when both properties can never be nil

class Country {
    let name: String
    var capitalCity: City! // Allows Country to pass "self" to the City init() before being fully initialized (since self.capitalCity is not yet defined)
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
// No strong reference cycles since only one variable refers to both the Country and the City
var usa = Country(name: "USA", capitalName: "DC")
usa.name
usa.capitalCity.name


// STRONG REFERENCE CYCLES FOR CLOSURES

// Causes
//      Class instance and closure reference each other
//      Closures are reference types like classes
//      Closures can capture instance properties and methods

// Resolved by defining a "capture list" in the closure's definition
// Declare each captured reference as weak or unowned
//      Unowned - If the captured reference will never be nil
//      Weak - If the captured reference may become nil

// Syntax:
// lazy var someClosure: (Int, String) -> String = {
//    [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
//    // closure body goes here
// }
//
// lazy var someClosure: Void -> String = {
//    [unowned self, weak delegate = self.delegate!] in
//    // closure body goes here
// }


class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: Void -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hi")
paragraph!.asHTML()
paragraph = nil






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
try! processFile("fancy.txt")





