//
//  ViewController.swift
//  RomanToInteger
//
//  Created by Ali Çolak on 14.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var numberReturn: String = ""
    var numberRoman: String = ""
    let defaults = UserDefaults.standard
    var romanToIntegerDictionary = [String: String]()

    private var headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Roman Numeral Converter"
        return label
    }()
    
    
    let romanNumberTF : UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.placeholder = "Please type the roman number to convert"
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    
    private lazy var calculateButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.setTitle("Convert", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(convert), for: .touchUpInside)
        return button
    }()
    
    
    private var responseLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var saveToFavoritesButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill")?.withTintColor(.yellow, renderingMode: .alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(saveToFavorites), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedDictionary = defaults.dictionary(forKey: "romanToIntegerDictionaryKey") as? [String: String] {
                    print("Roman to Integer Dictionary: \(savedDictionary)")
                } else {
                    print("Roman to Integer Dictionary bulunamadı.")
                }
   
                
        initialConfig()
        
        
        
    }


    @objc
    func convert(){
        guard let romanString = romanNumberTF.text else { return }
        numberRoman = romanString
        let responseText = findFromRomanToInteger(romanString)
        
        DispatchQueue.main.async {
            self.responseLabel.text = responseText
            self.addFavorite(key: self.numberReturn, value: self.numberRoman)
            if let savedDictionary = self.defaults.dictionary(forKey: "romanToIntegerDictionaryKey") as? [String: String] {
                        print("Roman to Integer Dictionary: \(savedDictionary)")
                    } else {
                        print("Roman to Integer Dictionary bulunamadı.")
                    }
        }
        
    }
    
    @objc
    func saveToFavorites(){
       
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
        
        numberReturn = String(number)
        return numberReturn
        
    }

    
    
    override func viewDidLayoutSubviews() {
        setConstraints()
    }
    
    func addFavorite(key: String, value: String) {
            if let savedDictionary = defaults.dictionary(forKey: "romanToIntegerDictionaryKey") as? [String: String] {
                romanToIntegerDictionary = savedDictionary
            } else {
                print("Roman to Integer Dictionary bulunamadı.")
            }
            
            romanToIntegerDictionary[key] = value
            defaults.removeObject(forKey: "romanToIntegerDictionaryKey")
            defaults.set(romanToIntegerDictionary, forKey: "romanToIntegerDictionaryKey")
            
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

extension ViewController {
    func initialConfig(){
        view.addSubviews([headerLabel,romanNumberTF,calculateButton,responseLabel,saveToFavoritesButton])
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 150),
            headerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 20),
            headerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 20),
            
            
            romanNumberTF.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,constant: 20),
            romanNumberTF.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 20),
            romanNumberTF.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -20),
            
            
            calculateButton.topAnchor.constraint(equalTo: romanNumberTF.bottomAnchor,constant: 20),
            calculateButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 20),
            calculateButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -20),
            
            
            responseLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor,constant: 20),
            responseLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 20),
            responseLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: 20),
            
            
            saveToFavoritesButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,constant: 20),
            saveToFavoritesButton.leftAnchor.constraint(equalTo: romanNumberTF.rightAnchor,constant: 20),
            saveToFavoritesButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -20)

        ])
    }
}


extension UIView {
    func addSubviews(_ views : [UIView]){
        views.forEach { view in
            self.addSubview(view)
        }
    }
}

