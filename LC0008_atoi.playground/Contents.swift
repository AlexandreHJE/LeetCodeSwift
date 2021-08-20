//Requirements for atoi:
//The function first discards as many whitespace characters as necessary until the first non-whitespace character is found. Then, starting from this character, takes an optional initial plus or minus sign followed by as many numerical digits as possible, and interprets them as a numerical value.
//
//The string can contain additional characters after those that form the integral number, which are ignored and have no effect on the behavior of this function.
//
//If the first sequence of non-whitespace characters in str is not a valid integral number, or if no such sequence exists because either str is empty or it contains only whitespace characters, no conversion is performed.
//
//If no valid conversion could be performed, a zero value is returned. If the correct value is out of the range of representable values, INT_MAX (2147483647) or INT_MIN (-2147483648) is returned.

/*
Implement the myAtoi(string s) function, which converts a string to a 32-bit signed integer (similar to C/C++'s atoi function).

The algorithm for myAtoi(string s) is as follows:

Read in and ignore any leading whitespace.
Check if the next character (if not already at the end of the string) is '-' or '+'. Read this character in if it is either. This determines if the final result is negative or positive respectively. Assume the result is positive if neither is present.
Read in next the characters until the next non-digit charcter or the end of the input is reached. The rest of the string is ignored.
Convert these digits into an integer (i.e. "123" -> 123, "0032" -> 32). If no digits were read, then the integer is 0. Change the sign as necessary (from step 2).
If the integer is out of the 32-bit signed integer range [-231, 231 - 1], then clamp the integer so that it remains in the range. Specifically, integers less than -231 should be clamped to -231, and integers greater than 231 - 1 should be clamped to 231 - 1.
Return the integer as the final result.
Note:

Only the space character ' ' is considered a whitespace character.
Do not ignore any characters other than the leading whitespace or the rest of the string after the digits.
 */


import Foundation
import XCTest

func atoi_LeetCode(input: String) -> Int {
    var result = 0
    var notSignedValue = 0
    var signChanged: Bool = false
    var isPositive: Bool = true
    let inputArray = Array(input)
    let trimmedArray = trimLeadingSpaceChars(array: inputArray)
    let hasLeadingDigit = checkArrayHasLeadingDigit(array: inputArray)
    outerLoop: for c in trimmedArray {
        switch checkInputCharacterType(with: c) {
            case .isSpaceChar:
                if signChanged || hasLeadingDigit {
                    break outerLoop
                }

            case .isPositiveSignChar:
                if hasLeadingDigit { break outerLoop }
                if !signChanged {
                    signChanged = true
                } else {
                    break outerLoop
                }

            case .isNegativeSignChar:
                if hasLeadingDigit { break outerLoop }
                if !signChanged {
                    signChanged = true
                    isPositive = false
                } else {
                    break outerLoop
                }

            case .isNumericChar:
                notSignedValue = calculateValue(with: c, priviousValue: notSignedValue)
                if !isPositive {
                    result = -(notSignedValue)
                } else {
                    result = notSignedValue
                }
                
                if checkIfExceedInt32Bounds(with: result) {
                    result = result > 0 ? Int.int32_max : Int.int32_min
                    break outerLoop
                }

            default:
                break outerLoop
        }
    }

    return result
}

func checkArrayHasLeadingDigit(array: [Character]) -> Bool {
    var result: Bool = false
    for c in array {
        if !c.isWhitespace && !(c.isASCII && c.isNumber) {
            break
        } else if (c.isASCII && c.isNumber) {
            result = true
            break
        }
    }
    
    return result
}

func calculateValue(with addedDigit: Character, priviousValue: Int) -> Int {
    var result = priviousValue
    if addedDigit.isASCII && addedDigit.isNumber {
        result = (result * 10) + (addedDigit.wholeNumberValue ?? 0)
    }
    
    return result
}

func trimLeadingSpaceChars(array: [Character]) -> [Character] {
    var result: [Character] = []
    var keepTrimmingFlag: Bool = true
    for c in array {
        if !c.isWhitespace {
            keepTrimmingFlag = false
        }
        if !keepTrimmingFlag {
            result.append(c)
        }
    }
    
    return result
}

func checkIfExceedInt32Bounds(with value: Int) -> Bool {
    return value > Int.int32_max || value < Int.int32_min
}

func checkInputCharacterType(with char: Character) -> CharacterTypes {
    var characterType: CharacterTypes = .other
    
    if char.isASCII && char.isNumber {
        characterType = .isNumericChar
    } else if char == "+" {
        characterType = .isPositiveSignChar
    } else if char == "-" {
        characterType = .isNegativeSignChar
    } else if char.isWhitespace {
        characterType = .isSpaceChar
    }
    
    return characterType
}

enum CharacterTypes {
    case isNumericChar
    case isPositiveSignChar
    case isNegativeSignChar
    case isSpaceChar
    case other
}

extension Int {
    static let int32_max: Int = 2147483647
    static let int32_min: Int = -2147483648
}

let a = atoi_LeetCode(input: "5566") // 5566
let b = atoi_LeetCode(input: "-5566") // -5566
let c = atoi_LeetCode(input: "a5566") // 0
let d = atoi_LeetCode(input: "5566a") // 5566
let e = atoi_LeetCode(input: "-91283472332") // -2147483648
let f = atoi_LeetCode(input: "91283472332") // 2147483647
let g = atoi_LeetCode(input: "  5566") //5566
let h = atoi_LeetCode(input: "5566  ") // 5566
let i = atoi_LeetCode(input: "55  66") //55
let j = atoi_LeetCode(input: "+-12") // 0
let k = atoi_LeetCode(input: "+1") // 1
let l = atoi_LeetCode(input: "0000-42a1234") // 0
let m = atoi_LeetCode(input: "    +0 123") //0
let n = atoi_LeetCode(input: "0    123") //0
let o = atoi_LeetCode(input: "  0000000000012345678") // 12345678

let trimmedArr = trimLeadingSpaceChars(array: [" ", " ", " ", "-", "5", " ", " "])
// ["-", "5", " ", " "]

class AtoiFunctionTests: XCTestCase {
    
    func testInputIsPositiveAndNotExceededInt32Bound() {
        let input: String = "5566"
        let output = atoi_LeetCode(input: input)
        XCTAssertEqual(output, 5566)
    }
    
    func testInputIsNegativeAndNotExceededInt32Bound() {
        let input: String = "-5566"
        let output = atoi_LeetCode(input: input)
        XCTAssertEqual(output, -5566)
    }
    
    func testInputIsPositiveAndNotExceededInt32BoundButHaveLeadingElement() {
        let input: String = "a5566"
        let output = atoi_LeetCode(input: input)
        XCTAssertEqual(output, 0)
    }
    
    func testInputIsPositiveAndNotExceededInt32BoundButHaveTrailingElement() {
        let input: String = "5566a"
        let output = atoi_LeetCode(input: input)
        XCTAssertEqual(output, 5566)
    }
    
    func testInputIsPositiveAndExceededInt32Bound() {
        let input: String = "91283472332"
        let output = atoi_LeetCode(input: input)
        XCTAssertEqual(output, 2147483647)
    }
    
    func testInputIsNegativeAndExceededInt32Bound() {
        let input: String = "-91283472332"
        let output = atoi_LeetCode(input: input)
        XCTAssertEqual(output, -2147483648)
    }
    
}

AtoiFunctionTests.defaultTestSuite.run()

