
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





