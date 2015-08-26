

/* PROPERTIES */

// Stored properties (not available in enums) and computed properties
// Type properties -> static properties

// Constant stored properties can be assigned during the struct's/class's initialization

// Constant structs cannot modify any properties, even variable ones
struct someStruct {
    var changeable: Int
}
let constantStruct = someStruct(changeable: 5)
//constantStruct.changeable = 3 <-- This results in an error


// Lazy stored properties - not calculated until it is used for the first time
// Can refer to self properties/methods because it does not exist until after initialization is complete
// Useful when the initial value:
//      1) depends on outside factors that are not known until after instance initialization
//      2) is computationally intensive to calculate
//      3) is also not required immediately, or in some cases no needed at all

class DataImporter {
    var secretData = "secret"
}
class DataManger {
    lazy var importer = DataImporter()
}

let manager = DataManger()
let dataImport = manager.importer // Now that the lazy var is being accessed, it is being initialized
dataImport.secretData

// Unlike Obj-C, Swift does not have instance variables (ivars) as backing store for properties


// COMPUTED PROPERTIES

// Computed properties do not store values; they are getters/setters for other properties
// Must use "var", not "let"
// Read-only computed properties - No setter, and no need for "get" keyword (just return)
// Similar to functions but with a single parameter

struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var horizontalLength: Double
    var verticalLength: Double
    
    init(length1: Double, length2: Double) {
        horizontalLength = length1
        verticalLength = length2
    }
    var upperRightCorner: Point {
        get {
            return Point(x: horizontalLength, y: verticalLength)
        }
        // If the parameter (newCorner) is not given, the default is newValue
        set (newCorner){
            horizontalLength = newCorner.x
            verticalLength = newCorner.y
        }
    }
}
var myRectangle = Rect(length1: 5.0, length2: 8.0)
myRectangle.upperRightCorner.x
myRectangle.upperRightCorner = Point(x: 3.3, y: 4.4)
myRectangle.upperRightCorner.y


// PROPERTY OBSERVERS

// Respond to changes in a property's value
// Can be used on stored properties (not lazy) and inherited properties (stored and computed)
// didSet and willSet

class watchMe {
    var something: String = "nothing" {
        willSet {
            print("About to set something to \(newValue)")
        }
        didSet {
            print("Just finished setting something from \(oldValue) to \(something)")
        }
    }
}
let watchMeInc = watchMe()
watchMeInc.something = "anything"


// GLOBAL AND LOCAL VARIABLES

// Global constants are declared outside of any function/method/closure or type context
// Globals are always computed "lazily"

// Type properties (class/static properties)
//      Always lazily initialized on first access
//      Must be given a default value (types do not have static initializers)
//      Obj-C did not have support for these (had to use static methods as accessors for a private static variable in the .m)
//      Declared with "static" before the var/let
//      Declared with "class" for computed properties






/* METHODS */

// Unlike Obj-C, Swift allows methods in Enumerations and Structures
// Like Obj-C, method names typically include the first argument name in the method name
//      Ex: incrementBy(amount: Int, numberOfTimes: Int) - This method signature would be incrementBy(_:numberOfTimes:)
// First param name has only local name by default, and subsequent params all have both internal and external names by default
// The "self" keyword is often not needed (Swift infers that you are working with a property)
//      Must be used when function parameter overrides the name

// Value types (structs, enums) cannot modify properties within instance methods by default
//      Swift is geared for "functional programming", which discourages changing data directly
//      Need "mutating" keyword on functions to allow it
struct Point2 {
    var x: Double = 0.0
    var y: Double = 0.0
    
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        self.x += deltaX
        self.y += deltaY
    }
}

// Structs and Enums can also use mutating methods to change the value itself
enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case Off:
            self = Low
        case Low:
            self = High
        case High:
            self = Off
        }
    }
}

// Type methods can be used for classes, structs, and enums
// Use "static" keyword, or "class" to make the method override-able by subclasses
// "self" refers to the type itself when used inside type methods
// Similarly, type methods can call other type methods without prefixing it with the type name






/* SUBSCRIPTS */

// Subscripts - Shortcuts for accessing member elements of a collection, list, or sequence
// Used by arrays and dictionaries
// Can be defined in classes, structs, and enums
// Each type can have multiple subscripts (Subscript overloading - distinguished by param types)
// Each subscript can have multiple input parameters of any type (no in-out or default params though)

class typeWithSubscript {
    subscript(index: Int) -> Int {
        get {
            return 0
        }
        set(newValue) {
        }
    }
}






/* INHERITANCE */

// Swift does NOT have a base class like NSObject in Obj-C
// Property observers can be added for inherited properties, both stored and computed
//      Cannot be used with properties that are not set (constant stored and read-only computed)
// Syntax - class subclass: superclass { ... }

class Vehicle {
    var currentSpeed: Double = 0.0
    var description: String {
        return "traveling at \(currentSpeed) mph"
    }
}


// OVERRIDING

// Can override instance/type methods, instance/type properties, and subscripts
// Must use "override" keyword
// Call superclass with "super" keyword

class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}


// Information on whether a superclass property is stored or computed is lost in subclass
//      Can turn stored property into computed, and vice-versa
//      Cannot turn read-write property into read-only (need to override both getter and setter)

class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10) + 1
        }
    }
}

// Use "final" keyword to prevent overriding methods/properties or on classes to prevent subclassing






/* INITIALIZATION */

// Unlike Obj-C, Swift initializers do not return a value
// They ensure that new instances are correctly initialized before first time use
// Stored properties MUST be initialized before the instance is fully created, done by:
//      1) Setting in the type's init() method
//      2) Giving a default value
//      3) Declaring the property as an optional (intialized to nil on object creation)
// In init() methods, all parameters (including the first) have automatic external names
//      Use underscores to remove this requirement, as usual

struct Weather {
    var temperature: Double
    static let freezingPoint = 32.0
    let heatAdvisoryPoint: Double // Cannot be modified after init() method is called
    var raining: Bool? // Optionals do not need initializing
    init() {
        temperature = Weather.freezingPoint
        heatAdvisoryPoint = 100.0
    }
    init(withCurrentTemperature currentTemperature: Double) {
        temperature = currentTemperature
        heatAdvisoryPoint = 100.0
    }
}
var currentWeather = Weather(withCurrentTemperature: 98.6)


// DEFAULT INITIALIZERS
//      init() not needed if all properties have defaults and there is no superclass
// Structs get a memberwise initializer
struct Size {
    var width = 0.0, height = 0.0
}
let twoByFour = Size(width: 2.0, height: 4.0)

// Intializer Delegate for Value Types
// In structs and enums, you can call an init() method from another init() method
// Useful to avoid duplicating code
// Call self.init() to access another


// CLASS INHERITANCE AND INITIALIZATION

// Designated (primary) intializers - Every class needs at least one
//      Must call "up" to superclass init()
// Convenience initializers are optional and call designated intializers to finish initializing
//      Must call "across" to designated init() in the same class

// Safety checks done by swift
//      1) All stored properties in the class must be initialized before calling superclass init()
//      2) Designated init() must call superclass designated init() before assigning values to the superclass's properties
//      3) Convenience initializer must delegate to another initializer before assigning values to any properties
//      4) Initializers cannot call instance methods, read instance properties, or refer to self until 1st phase of initialization completes

// Two-phase initialization - Swift first gives an initial value to all stored properties, then allows customized values to be set
// Phase 1
//      1) Designated or convenience initializer is called
//      2) Memory for new instance of the class is allocated
//      3) Designated initializer confirms all stored properties have a value. Memory for these properties is initialized.
//      4) Designated initializer hands off to superclass initializer
//      5) Superclass repeats steps 1-4 until the top of the hierarchy is reached
//      6) Once top of the chain finishes initializing, the instance's memory is considered fully initialized
// Phase 2
//      1) Starting at the top of the hierarchy, each designated initializer may customize the instance further (access self, modify properties, call instance methods, etc)
//      2) Convenience initializers may customize the instance further (once the designated initializer is finished)

// Subclasses do not inherit superclass initializers by default
// Subclasses can override superclass initializers

class Vehicle2 {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

class Bicycle: Vehicle2 {
    // Overriding the default initializer
    override init() {
        super.init() // Must be called first so that numberOfWheels gets initialized
        numberOfWheels = 2
    }
}


// AUTOMATIC INITIALIZER INHERITANCE - Subclass automatically inherits superclass initializers if:
//      1) The subclass has no designated initializers
//      2) The subclass provides an implementation of all superclass designated initializers - the subclass will inherit all superclass convenience initializers

class Food {
    var name: String
    // For structs/enums, this init would not be necessary - value types get "default memberwise initializers"
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "Unnamed")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    // This overrides Food's designated init(), not the convenience init()
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
    // Since RecipeIngredient overrides the Food's designated init(), it automatically inherits Food's convenience init()
    // This automatically inherited init() calls RecipeIngredient's designated init(), not Food's init()
}
let mysteryIngredient = RecipeIngredient()
mysteryIngredient.name
let oneBacon = RecipeIngredient(name: "Bacon")
let dozenEggs = RecipeIngredient(name: "Eggs", quantity: 12)

class ShoppingList: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
    convenience init(isPurchased: Bool) {
        self.init()
        purchased = isPurchased
    }
    // ShoppingList inherits all 3 initializers from superclasses:
    // init()
    // init(name: String)
    // init(name: String, quantity: Int)
}

let alreadyBought = ShoppingList(isPurchased: true)
alreadyBought.description

var breakfast = [
    ShoppingList(),
    ShoppingList(name: "Bacon"),
    ShoppingList(name: "Eggs", quantity: 12)
]

breakfast[0].name = "Orange Juice"
breakfast[0].name
breakfast[1].purchased = true
breakfast[1].purchased

for item in breakfast {
    print(item.description)
}


// FAILABLE INITIALIZERS
// Useful for when bad parameter values are passed, or if a required resource is not yet available
// Syntax: init?()

struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}
let noAnimal = Animal(species: "")
if noAnimal == nil {
    print("Animal object was not instantiated")
}

enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}


// Enums with raw values automatically get a failable initializer
enum TemperatureUnitRaw: Character {
    case Kelvin = "K"
    case Celsius = "C"
    case Fahrenheit = "F"
}
let notAUnit = TemperatureUnitRaw(rawValue: "X")
if notAUnit == nil {
    print("Temperature unit does not exist")
}

// For classes, initialization failures can only be triggered AFTER all stored properties are set and initializer delegation is complete
class Product {
    let name: String! // Default value of nil before init() is executed
    var priceInDollars: Double
    init?(name: String) {
        self.name = name
        priceInDollars = 0.00
        if name.isEmpty { return nil } // Must be called after the properties self.name and self.quantity are initialized
    }
}
if let turbo = Product(name: "turbo") {
    // No need to check turbo.name == nil
    // It is an implicitly unwrapped optional and a constant, so it will always be non-nil if Product initialization succeeds
    print("The product's name is \(turbo.name)")
}

// Failable initializers can delegate to other initializers (both failable and not), including those in superclasses
class CartItem: Product {
    let quantity: Int!
    init?(name: String, quantity: Int) {
        self.quantity = quantity
        
        // Must be called before the failure case
        // If this fails, initialization terminates and the line below is never called
        super.init(name: name)
        if quantity < 1 { return nil }
    }
}

// Can override failable initializers with nonfailable initializers, but NOT vice-versa
class Document {
    var name: String?
    // Creates a document with a nil name
    init() { }
    // Creates a document with a non-empty name
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

class AutomaticallyNamedDocument: Document {
    let defaultName = "[Untitled]"
    override init() {
        super.init()
        self.name = defaultName
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = defaultName
        } else {
            self.name = name
        }
    }
}

class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")! // Force unwrap the failable initializer; we know it will not fail
    }
}

// Required initializers
class SomeClass {
    // Must be reimplemented in subclasses, but can be empty
    required init() { }
}
class SomeSubclass: SomeClass {
    // "required" keyword still required in subclasses
    required init() { }
}


// SETTING A DEFAULT PROPERTY VALUE WITH A CLOSURE OR FUNCTION
// Useful for stored properties that need customization or setup

struct CheckerBoard {
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...10 {
            for j in 1...10 {
                temporaryBoard.append(isBlack)
                isBlack != isBlack
            }
            isBlack != isBlack
        }
        return temporaryBoard
        }()
}





