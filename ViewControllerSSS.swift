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
        // Do any additional setup after loading the view.
    }
    
    
    func convertRomanToInteger(_ roman : String) -> Int {
        
        let romanDictiniory : [Character:Int] = ["I":1,"V":5,"X":10,"L":50,"C":100,"D":500,"M":1000]
        
        var sum = 0
        
        for (index,item) in roman.enumerated() {
            
            
            if index != roman.count - 1 {
                
                let startIndex = roman.index(roman.startIndex, offsetBy: index)
                let endIndex = roman.index(roman.startIndex, offsetBy: index + 1 )

                let nextChar = Character(String(roman[startIndex ..< endIndex]))

                let firstItem = romanDictiniory[item]!
                let secondItem = romanDictiniory[nextChar]!
                
                
            } else {
                
            }
            
            
            
        }
        
        return sum
        
    }


}

