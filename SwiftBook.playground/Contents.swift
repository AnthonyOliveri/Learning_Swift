
import UIKit




/* THE BASICS */


// Swift has its own fundamental types (Int, Double, Float, Bool, String, etc)
// Swift is a TYPE SAFE language (catches possible type errors at compile time to avoid runtime crashses)
// Variables are declared with either "let" (constants) or "var" (mutable variable)
// Type annotations are optional
// Type cast can be used for types that have an initializer for the argument's type - SomeType(intialValue)
// Type Alias - Create new name for existing type

// Tuples are new: can be used to return multiple values from a function
//      Can contain an assortment of types
//      Contents can be decomposed
let tupleExample = ("something", 4.4, false)
let (sTuple, _, bTuple) = tupleExample // _ ignores that entry in the tuple
tupleExample.0
let tuple2 = (tupleString: "something", tupleDouble: 4.4, tupleBool: false)

// Optionals for all types; safer and more expressive that Obj-C
// nil in Swift is not a pointer to a nonexistent object; it is the absence of a value of a certain type
// Be careful using forced unwrapping - it will trigger runtime error if the variable is nil
//      Optional binding is safer
// Implicitly unwrapped optionals
//      For variables/constants that will ALWAYS have a value
//      Removes need to unwrap the value any time it is referenced
//      Useful for constants that cannot be defined during initialization or when interacting with Objective-C
let assumedString: String! = "This is an optional, without the need for later unwrapping"

var serverResponseCode: Int? = 404
serverResponseCode = nil

if let testResponseCode = serverResponseCode {
    print("Not nil")
} else {
    print("nil")
}

// Error handling is typical, except the "try" is put inside a "do" block
//      Can have multiple catch statements
// Assertions are useful to check for code that MUST be true in order for the program to continue





/* BASIC OPERATORS */


// Multiple variable assignment
let (x, y) = (1, "fish")
x
y

// Can use remainders on doubles
-8.4 % 2

// nil coalescing operator (ternary)
var a: Int?
let b = 0
let c = a ?? b

// Range operators
for i in 1...5 { } // Closed range
for i in 1..<5 { } // Half-open range





/* STRINGS AND CHARACTERS */


// Unlike Obj-C, Swift strings are value types, not objects

var str = "Hello, playground"

// Can iterate over characters
for singleChar in str.characters {
    print(singleChar)
}

// Can convert character arrays to strings
let catCharacters: [Character] = ["C", "a", "t", " ", "🐱"]
let catString = String(catCharacters)

// Concatenating strings/characters
let string1 = "hi"
let string2 = "there"
let char1: Character = "!"
let combinedStrings = string1 + " " + string2 + String(char1)

// String interpolation
print("The combined strings spell: \(combinedStrings)")

// Swift strings are Unicode scalars, ranging from U+0000 -> U+D7FF
for singleChar in str.unicodeScalars {
    print(singleChar)
}

// Swift characters are "Extended graphene clusters" - Sequence of 1 or more unicode scalars that produce one final character
let eAcute: Character = "A\u{20DD}"
let eAcute2: Character = "\u{65}\u{301}"
let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1f1f8}"

// Count - Counts combined characters (like eAcute2) as 1
print(str.characters.count)

// Indexing strings
str[str.startIndex]
str[str.startIndex.successor()]
str[str.endIndex.predecessor()]
let index = advance(str.startIndex, 5)

for i in str.characters.indices {
    print("\(str[i])")
}

// Inserting/removing
str.insert("!", atIndex: str.endIndex)
str.splice(" there".characters, atIndex: advance(str.startIndex, 5))

// String comparison results in true if all characters are cononically equivalent
//      They have the same linguistic meaning and appearance

// Prefix/suffix
str.hasPrefix("Hell")
str.hasSuffix("evil")





/* COLLECTION TYPES */


// Arrays, sets, and dictionaries
// All are value types, not reference types


// ARRAYS

// Initializing
var someInts = [Int]()
let someStrings = [String](count: 3, repeatedValue: "betelgeuse")
var someDoubles = [4.4, 5.5, 6.6]

// Modifying arrays
// Mixed type collections default to an array of type [AnyObject]
var asdf = ["fsadf", 4.7, true]
asdf += ["no"]
asdf.insert("new", atIndex: 2)
asdf.removeAtIndex(1)
asdf[0...1] = ["old", "new"]
asdf.removeLast()
asdf

// Iterating
for (index, value) in asdf.enumerate() {
    print("Index = \(index), value = \(value)")
}

asdf.count
asdf.isEmpty


// SETS

// Sets can only contain types that are hashable
// Custom types must conform to both the "Hashable" and the "Equatable" protocols

// Initialization
var letters = Set<Character>()
var aSet: Set = Set(asdf)
var anotherSet: Set = [4, 5, 6]

// Accessing/modifying
letters.count
letters.isEmpty
letters.insert("c")
letters.remove("c")
letters = [] // Still type Set<Character>

// Set operations
let oddInts: Set = [1, 3, 5, 7, 9]
let evenInts: Set = [0, 2, 4, 6, 8]
let primes: Set = [2, 3, 5, 7]

oddInts.union(evenInts).sort()
oddInts.intersect(evenInts).sort()
oddInts.subtract(primes).sort()
oddInts.exclusiveOr(primes).sort()

oddInts.isDisjointWith(evenInts)
primes.isSubsetOf(oddInts)
primes.isStrictSubsetOf(oddInts)


// DICTIONARIES

// All keys are same type; All values are same type
// Keys must conform to "Hashable" protocol

// Initialization
let stupidDict = [Bool: Bool]()
var specialDict: [String: Double] = ["asdf": 4.4, "stuff" : 1.1]
let nonexistent = specialDict["f"]
let existent: Double? = nonexistent

// Accessing/modifying
if let oldValue = specialDict.updateValue(2.2, forKey: "stuff") {
    print("\(specialDict)")
}
if let stuff = specialDict["stuff"] {
    print("\(stuff)")
}

// Iterating
for (key, item) in specialDict {
    print("\(key) : \(item)")
}





/* CONTROL FLOW */


// FOR LOOPS

// Ignore index with underscore
for _ in 1...3 { }


// WHILE LOOPS

// repeat-while: Same as do-while loops


// CONDITIONALS - SWITCH

// Switch statements do not fall through unless "fallthrough" keyword is used (no need for "break")
// Can match to many different patterns (intervals, tuples, type casts, etc.)

// Tuples in switch statements
let somePoint = (0, 2)
switch somePoint {
case (0,0):
    print("Origin")
case (0, _):
    print("y-axis")
case (_,0):
    print("x-axis")
default:
    print("Elsewhere")
}
// Value binding
switch somePoint {
case (let x, let y):
    print("(\(x), \(y))")
}
// Conditional switch
let anotherPoint = (1,-1)
switch anotherPoint {
case let (x,y) where x == y:
    print("\(x), \(y) is on the x = y line")
case let (x,y) where x == -y:
    print("\(x), \(y) is on the x = -y line")
default:
    print("Elsewhere")
}


// CONTROL TRANSFER

// continue, break, fallthrough, return, throw
// Use break in a switch case to ignore it (all cases require some kind of action)

// Statements can be labeled to direct control transfer to that particular statement
var count = 10
outerLoop: repeat {
    for index in 0...5 {
        if index == count {
            count = index
            break outerLoop
        }
    }
    count--
} while count > 0
count

// "guard" statements are used to require a condition to be true
//      They are like "if" statements with only the else clause
// Must use break, continue, return, or throw to get out of the else clause
let nilString: String? = nil
for i in 0...1 {
    guard let newString = nilString else {
        print("Failed to assign to newString")
        break
    }
}


// CHECKING API AVAILABILITY

if #available(iOS 9, OSX 10.10, *) {
    print("API is available!")
} else {
    print("API not available!")
}





/* FUNCTIONS */

// Functions are reference types!

// Functions can return tuples and other functions
// Return values can be named for easier access
func returnSomeShit() -> (s1: String, s2: String) {
    return ("some", "shit")
}
var some = returnSomeShit().s1
var shit = returnSomeShit().s2

let someShit: (String, String) = returnSomeShit()
some = someShit.0
shit = someShit.1

// Return values can be optional
func maybe() -> (int1: Int, int2: Int)? {
    return (5, 9)
}
let something = maybe()

// External parameter names go before internal param name
// Parameters can have default values
func combineStrings(firstString s1: String, s2: String, s3: String = " is awesome") -> String {
    return s1 + s2 + s3
}
// Parameters after the 1st must use the internal param name if no external param name exists
let combined = combineStrings(firstString: "Ant", s2: "hony")
let combined2 = combineStrings(firstString: "Ant", s2:"hony", s3: " sucks")

// If you don't want to use param names, use an underscore in function declaration
func combineStrings2(s1: String, _ s2: String, _ s3: String = " is awesome") -> String {
    return s1 + s2 + s3
}
let combined3 = combineStrings2("Ant", "hony")

// Variadic parameters must always be last in parameter list
func variableParams(string: String, numbers: Int...) { }

// Parameters are implicitly constant
// Need to use "var" on parameters to make them modifiable
func changeParam(var aString: String) {
    aString = "New value"
}

// Objects are now passed by value instead of reference; must use "inout"
func swapInts(inout a: Int, inout _ b: Int) {
    let temp = a
    a = b
    b = temp
}
var a1 = 1
var b1 = 3
swapInts(&a1, &b1)
a1
b1

// Function types - Functions can return other functions, and take functions as parameters
let combineStringsFunc: (String, String, String) -> String = combineStrings
let new = combineStringsFunc("this", " shit", " is neat")

// Nested functions
func chooseStepFunction(backwards: Bool) -> ((Int) -> Int) {
    func stepForward(input: Int) -> Int {
        return input + 1
    }
    func stepBackward(input: Int) -> Int {
        return input - 1
    }
    return backwards ? stepBackward : stepForward
}

var currentValue = 10
let countToZero = chooseStepFunction(currentValue > 0)
while currentValue != 0 {
    print("\(currentValue)")
    currentValue = countToZero(currentValue)
}
currentValue





/* CLOSURES */

// Closures are either 1) global functions, 2) nested functions, or 3) unnamed closures
// Closures are equivalent to C blocks, and are useful for passing short functions as inline parameters
// Useful for:
//      1) Inferring parameter and return types from context
//      2) Implicit returns from single-expression closures
//      3) Shorthand argument names
//      4) Trailing closure syntax
// General syntax:
// { (parameter1, parameter2) -> return type in
//     statements
// }
// Parameters cannot contain default values
// Closures are reference types!

let names = ["Anthony", "Anton"]
var reversed = [String]()

// Closures are fucking ridiculous. All the below expressions do the same thing.

func backwardsSort(s1: String, s2: String) -> Bool { return s1 > s2 }
reversed = names.sort(backwardsSort)

reversed = names.sort( { (s1: String, s2: String) -> Bool in return s1 > s2 } )

reversed = names.sort( { s1, s2 in return s1 > s2 } )

reversed = names.sort( { s1, s2 in s1 > s2 } )

reversed = names.sort( { $0 > $1 } )

reversed = names.sort(>)

// Trailing closures are useful if the closure body is long
// If a closure is the last parameter, it can be supplied after the function call's parentheses are closed
reversed = names.sort() { $0 > $1 }
reversed = names.sort { $0 > $1 }

// Nested functions capture arguments, variables, and constants from the outer function
func makeIncrementer(forIncrementer amount: Int) -> (Void -> Int) {
    var runningTotal = 0
    func increment() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return increment
}

// the function increment() is assigned to the constant "incrementBy9", so runningTotal and amount are retained in memory
let incrementBy9 = makeIncrementer(forIncrementer: 9)
var total: Int = 0
for _ in 0...4 {
    total = incrementBy9()
}
total

let incrementBy7 = makeIncrementer(forIncrementer: 7)
for _ in 0...4 {
    total = incrementBy7()
}
total

// Demonstrating that closures are reference types
let anotherIncrement = incrementBy7
anotherIncrement()





/* ENUMERATIONS */

// Enums are not assigned default integer values; associated values are optional
// Enums are first class types. They can have:
//      1) Computed properties
//      2) Instance methods
//      3) Extensions
//      4) Conformation to protocols
//      5) Default initializers

// Associated values can be of different types for different cases of the enum
enum Barcode {
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
}

// Raw values provide default values for each case that do not change
// Raw values are all the same type
enum ASCIIControlCharacter: Character {
    case Tab = "\t"
    case LineFeed = "\n"
    case CarriageReturn = "\r"
}

// Unspecified raw values increment by 1 for each following case
enum Planet: Double {
    case Mercury, Venus, Mars, Earth, Jupiter, Saturn, Uranus, Neptune
}
print(Planet.Jupiter.rawValue)

// Matching enums with switch statements
var ourPlanet: Planet = Planet.Earth
ourPlanet = .Mars
switch ourPlanet {
case .Mercury:
    print("First planet")
case .Venus:
    print("Second planet")
case .Mars:
    print("Third planet")
case .Earth:
    print("Fourth planet")
default:
    ("Some gas or ice giant")
}

let productBarcode = Barcode.UPCA(1, 2, 3, 4)
switch productBarcode {
case let .UPCA(numberSystem, manufacturer, product, check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check))")
case let .QRCode(productCode):
    print("QR code: \(productCode)")
}

// Initializing from raw value
let somePlanet = Planet(rawValue: 5.0)
print(somePlanet)

// Enums can be recursive

enum RecursiveEnum {
    case One
    indirect case Two(RecursiveEnum)
}

indirect enum VeryRecursiveEnum {
    case One(VeryRecursiveEnum)
    case Two(VeryRecursiveEnum)
}





/* CLASSES AND STRUCTURES */

// Unlike structs, classes:
//      1) Are REFERENCE TYPES - Instances are shared among different properties
//      2) Inherit from other classes
//      3) Type cast (check type at runtime)
//      4) Have deinitializers
//      5) Allow more than one reference to an instance (reference counting)

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

// Unlike classes, structs:
//      1) Are VALUE TYPES - Instances are copied among different properties
//      2) Have memberwise initiazizers, implicit initializers in which member properties can be set

struct Resolution {
    var width = 0
    var height = 0
}
let vga = Resolution(width: 640, height: 480)

// Unlike Objective-C, sub-properties can be set directly rather than needing to create a new property
// Object constants can have modified properties; the constant does not change (still a pointer to the same object)
let video1 = VideoMode()
video1.interlaced = true
video1.resolution.width = 640
video1.resolution.height = 480

// Use === to check if two constants or variables refer to the same instance

// Reference types in swift are similar to C pointers but do not point directly to an address in memory

// PROGRAMMING GUIDELINES - CHOOSING CLASS VS STRUCTURE

// Use structs if the type:
//      1) Should be copied instead of passed by reference
//      2) Does not need to inherit behavior from existing type
//      3) Encapsulating a few simple data values
//      4) Properties are value types





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















