import UIKit


// Higher Order Sequence Functions
// Source: https://www.weheartswift.com/higher-order-functions-map-filter-reduce-and-more/


// Map

// Definition: func map<u>(transform: (T) -> U) -> [U]
// Function: [x1, x2, ..., xn].map(f) -> [f(x1), f(x2), ..., f(xn)]


// Filter

// Definition: Removes array elements that do not pass a certain condition
// Function:   func filter(includeElement: (T) -> Bool) -> [T]


// Reduce

// Definition: Combine array elements into a single value
// Function:   func reduce(initial: U, combine: (U,T) -> U) -> U


// Example problems

// 1)
func applyTwice(f: (Float -> Float), x: Float) -> Float {
    return f(f(x))
}
print(applyTwice({$0 * $0}, x: 5.0))


// 2)
func applyKTimes(f: (Float -> Float), x: Float, k: Int) -> Float {
    if k <= 1 {
        return f(x)
    }
    return f(applyKTimes(f, x: x, k: k - 1))
}
print(applyKTimes({$0 * $0}, x: 2, k: 3))
// 3)
print(applyKTimes({2 * $0}, x: 2, k: 3))


// 4) Write a map that returns an array of "Users" with only their name
class User {
    let name: String
    let age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
let someUsers = [User(name: "Anthony", age: 24), User(name: "Mike", age: 26), User(name: "DGonz", age: 26)]
print(someUsers.map( {$0.name} ))


// 5) Write a map that returns an array of a dictionary with values only
let otherUsers: [Dictionary<String, String>] = [["name": "Anthony", "age": "24"], ["name": "Anthony", "age": "24"]]
print(otherUsers.map( {$0["name"]} ))


// 6) Write a filter that selects odd integers
let someNumbers = [1, 1, 2, 3, 5, 8, 13, 21, 34]
print(someNumbers.filter( {$0 % 2 == 0} ))


// 7) Write a filter that selects strings that are Int convertible
let possibleInts = ["asdf", "kj;lkj", "32", "5.5", "2.7", "14"]
print(possibleInts.filter( {return Int($0) != nil} ))


// 8) Write a filter to select UIViews that are a subclass of UILabel
let uiViewFrame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 0.0, height: 5.0))
let uiLabelFrame = CGRect(origin: CGPoint(x: -5.0, y: 10.0), size: CGSize(width: 10.0, height: 2.0))
let someViews: [UIView] = [UIView(), UIView(frame: uiViewFrame), UILabel(), UILabel(frame: uiLabelFrame)]

print( someViews.filter( {$0 is UILabel} ).count )


// 9) Write a reduce that combines an array of strings, each separated by a newline
let someStrings2 = ["This", "is", "reduce"]
let oneString = someStrings2.reduce("", combine: {$0 + $1 + "\n"} )
print(oneString)


// 10) Reduce that finds largest element in an array of Ints
let someInts2 = [4, 60, 19, 100, -5, 999]
print(someInts2.reduce(someInts2[0], combine: { ($0 > $1 ? $0 : $1) }))




// Nullability and Objective-C
// Source: https://developer.apple.com/swift/blog/

// "nullable" and "nonnull"
// 2 type annotations for Obj-C that allow easier interoperability with Swift
// When specifying methods/properties with these annotations, Swift code can reference their types with the appropriate optional/nonoptional type (rather than implicitly unwrapped optionals)
// No longer need implicitly unwrapped optionals when translating from Obj-C to Swift

// Example without nullability:
// Obj-C: @property (copy) NSString* name;
// Swift: @NSCopying var name: String!

// Example with nullabiliity:
// Obj-C: @property (copy, nullable) NSString* name;
// Swift: @NSCopying var name: String?

// Audited regions: 
// NS_ASSUME_NONNULL_BEGIN
// [Some Obj-C code]
// NS_ASSUME_NONNULL_END




// Increasing Performance by Reducing Dynamic Dispatch
// Source: https://developer.apple.com/swift/blog/

// The problem: At runtime, the program uses dynamic dispatch for each called method and property, since they may have been overridden in a subclass. 
// Swift compiler only compiles 1 file at a time

// Solution 1: Mark as "final" - No possible definition override
// Solution 2: Mark as "private" - "final" is inferred if there is no overriding definition in the same file
// Solution 3: Use "Whole Module Optimization" so that all files in the module are compiled together - Everything internal/private gets optimized




// Swift 2.0
// Source: https://developer.apple.com/swift/blog/

// Introduced error handling with try/catch/throw and ErrorType
// #available blocks ensure code is only run on the specified OS versions
// Protocol extensions
// guard statements




// Strings in Swift 2.0
// Source: https://developer.apple.com/swift/blog/

// Strings are no longer a "CollectionType" (i.e. an array of characters)
    // Functionality replaced with the .characters property

var cafeString = "cafe"
let accuteAccent: Character = "\u{0301}"
cafeString.append(accuteAccent)
cafeString.characters.count // Appending to an array would make the count 5 instead of 4
cafeString.characters.contains("e") // Adding the accute accent replaced a character

// Strings are equal if they are "canonically equivalent", even if they are composed of different unicode scalars
"\u{1100}\u{1161}" == "\u{AC00}"

// Strings provide view properties that are CollectionTypes
cafeString.characters // Extended grapheme clusters - approximation of user-perceived characters
cafeString.unicodeScalars
cafeString.utf8
cafeString.utf16



