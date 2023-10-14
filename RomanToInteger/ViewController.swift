//
//  ViewController.swift
//  RomanToInteger
//
//  Created by Ali Çolak on 14.10.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(findFromRomanToInteger("MCMXCVIII"))

    }


    func findFromRomanToInteger (_ roman : String) -> String {
        
        if !isValidateLetters(roman) {
            return "Please enter true letters"
        }
        
        let number = convertRomanToInteger(roman)
        
        
        if number >= 4000 {
            return "Please enter less than 4000"
        }
        
        
        if !isValidateRoman (roman,number) {
            return "Please enter true roman formats"
        }
        
        
        return String(number)
        
    }



    func convertRomanToInteger(_ roman : String) -> Int {
        
        let romanDictiniory : [Character:Int] = ["I":1,"V":5,"X":10,"L":50,"C":100,"D":500,"M":1000]
        
        var sum = 0
        
        for (index,item) in roman.enumerated() {
            
            let startIndex = roman.index(roman.startIndex, offsetBy: index)

            let firstItem = romanDictiniory[item]!
            
            if index != roman.count - 1 {
                
                let nextIndex = roman.index(after: startIndex)
                
                let nextChar = Character(String(roman[nextIndex]))

                let secondItem = romanDictiniory[nextChar]!
                
                if firstItem < secondItem {
                    sum -= firstItem
                } else {
                    sum += firstItem
                }
                
                
            } else {
                sum += firstItem
            }
            
            
            
        }
        
        return sum
        
    }


    func isValidateLetters (_ roman : String) -> Bool {
        
        var isValidate : Bool = true
        
        let letters = ["I","V","X","L","C","D","M"]
        
        for item in roman {
            if !letters.contains(String(item)) {
                return false
            }
        }
        
        return isValidate
        
    }

    func isValidateRoman (_ roman : String, _ number : Int) -> Bool {
        
        let trueRoman = convertIntegerToRoman(number)
        
        if trueRoman != roman {
            return false
        } else {
            return true
        }
        
    }


    func convertIntegerToRoman(_ number: Int) -> String {

        let romanNumerals: [(value: Int, numeral: String)] = [
            (1000, "M"),
            (900, "CM"),
            (500, "D"),
            (400, "CD"),
            (100, "C"),
            (90, "XC"),
            (50, "L"),
            (40, "XL"),
            (10, "X"),
            (9, "IX"),
            (5, "V"),
            (4, "IV"),
            (1, "I")
        ]

        var result = ""
        var remainingValue = number

        for numeral in romanNumerals {
            while remainingValue >= numeral.value {
                result += numeral.numeral
                remainingValue -= numeral.value
            }
        }

        return result
    }


}

