//
//  ViewController.swift
//  RomanToInteger
//
//  Created by Ali Çolak on 14.10.2023.
//

/**
Some notes,

 - Don't use force unwrap, I mean dont use "somethink!". It may cause crash.
 - Use constants for constants. It's easy to read and edit. Just advice :)
 - Be ceraful about access modifiers which private, public etc. Lot's of peoplo eliminate on cases because of it.
 - Use extensions.
 - Some of components lazy some of not. Why? Be consistent.
 - Pay attention about spaces. Lots of unnecessary empty line.

 I know you are a student and try to improve yourself. But these are important thinks. I don't mean to be rude.
 I saw it while casually browsing Github in the evening and wanted to contribute.

 Just some advices from someone who experienced.
 Take care and good luck.

 Said Çankıran.
 */

import UIKit

class ViewController: UIViewController {

    enum Constants: String {
        case headerLabelText = "Roman Numeral Converter"
        case romanNumberPlaceHolder = "Please type the roman number to convert"
        case buttonTitle = "Convert"
        case favoriteButtonImageName = "star.fill"
        case dictionaryKey = "romanToIntegerDictionaryKey"
        case letterValidationError = "Please enter true letters"
        case numberValidationError = "Please enter less than 4000"
        case romanFormatValidationError = "Please enter true roman formats"
    }
    
    var numberReturn: String = ""
    var numberRoman: String = ""
    let defaults = UserDefaults.standard
    var romanToIntegerDictionary = [String: String]()

    private lazy var headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.headerLabelText.rawValue
        return label
    }()
    
    
    private lazy var romanNumberTF : UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = Constants.romanNumberPlaceHolder.rawValue
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    
    private lazy var calculateButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.setTitle(Constants.buttonTitle.rawValue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(convert), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var responseLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var saveToFavoritesButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.favoriteButtonImageName.rawValue)?.withTintColor(.yellow, renderingMode: .alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(saveToFavorites), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
        checkRomanToIntegerDictionary()
    }

    override func viewDidLayoutSubviews() {
        setConstraints()
    }


    private func checkRomanToIntegerDictionary() {
        if let savedDictionary = defaults.dictionary(forKey: Constants.dictionaryKey.rawValue) as? [String: String] {
            print("Roman to Integer Dictionary: \(savedDictionary)")
        } else {
            print("Roman to Integer Dictionary bulunamadı.")
        }
    }

    @objc private func convert(){
        guard let romanString = romanNumberTF.text else { return }
        numberRoman = romanString
        let responseText = findFromRomanToInteger(romanString)
        
        DispatchQueue.main.async {
            self.responseLabel.text = responseText
            self.addFavorite(key: self.numberReturn, value: self.numberRoman)
            if let savedDictionary = self.defaults.dictionary(forKey: Constants.dictionaryKey.rawValue) as? [String: String] {
                print("Roman to Integer Dictionary: \(savedDictionary)")
            } else {
                print("Roman to Integer Dictionary bulunamadı.")
            }
        }
    }
    
    @objc private func saveToFavorites() {

    }
}

private extension ViewController {
    func findFromRomanToInteger(_ roman : String) -> String {
        if !isValidateLetters(roman) {
            return Constants.letterValidationError.rawValue
        }
        
        let number = convertRomanToInteger(roman)
        if number >= 4000 {
            return Constants.numberValidationError.rawValue
        }

        if !isValidateRoman(roman,number) {
            return Constants.romanFormatValidationError.rawValue
        }
        
        numberReturn = String(number)
        return numberReturn
    }

    func addFavorite(key: String, value: String) {
            if let savedDictionary = defaults.dictionary(forKey: Constants.dictionaryKey.rawValue) as? [String: String] {
                romanToIntegerDictionary = savedDictionary
            } else {
                print("Roman to Integer Dictionary bulunamadı.")
            }
            
            romanToIntegerDictionary[key] = value
            defaults.removeObject(forKey: Constants.dictionaryKey.rawValue)
            defaults.set(romanToIntegerDictionary, forKey: Constants.dictionaryKey.rawValue)
            
    }

    func convertRomanToInteger(_ roman : String) -> Int {
        let romanDictiniory : [Character:Int] = ["I":1,"V":5,"X":10,"L":50,"C":100,"D":500,"M":1000]
        var sum = 0

        for (index,item) in roman.enumerated() {
            let startIndex = roman.index(roman.startIndex, offsetBy: index)

            guard let firstItem = romanDictiniory[item] else { return -1 }

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
        let letters = ["I","V","X","L","C","D","M"]
        var isValidated = false
        roman.forEach { item in
            isValidated = letters.contains(String(item))
        }

        return isValidated
    }

    func isValidateRoman (_ roman: String, _ number: Int) -> Bool {
        return convertIntegerToRoman(number) == roman
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

private extension ViewController {
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
