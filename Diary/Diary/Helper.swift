//
//  Helper.swift
//  Diary
//
//  Created by TaoTao on 2019/5/8.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

let screenSize = UIScreen.main.bounds

func diaryButtonWith(text: String, fontSize: CGFloat, width: CGFloat, normalImageName: String, highlightImageName: String ) -> UIButton {
    let button = UIButton(type: .custom)
    button.frame = CGRect(x: 0, y: 0, width: width, height: width)
    button.setBackgroundImage(UIImage(named: normalImageName), for: .normal)
    button.setBackgroundImage(UIImage(named: highlightImageName), for: .highlighted)
    
    let font = UIFont(name: "Wyue-GutiFangsong-NC", size: fontSize)
    let textAttributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.white]
    
    let attributedText = NSAttributedString(string: text, attributes: textAttributes)
    button.setAttributedTitle(attributedText, for: .normal)
    return button
}

func numberToChinese(_ number: Int) -> String {
    let numbers = String(number)
    var finalString = ""
    for singleNumber in numbers {
        let string = singleNumberToChinese(singleNumber)
        finalString = "\(finalString)\(string)"
    }
    return finalString
}

func singleNumberToChinese(_ singleNumber: Character) -> String {
    switch singleNumber {
    case "0":
        return "零"
    case "1":
        return "一"
    case "2":
        return "二"
    case "3":
        return "三"
    case "4":
        return "四"
    case "5":
        return "五"
    case "6":
        return "六"
    case "7":
        return "七"
    case "8":
        return "八"
    case "9":
        return "九"
    default:
        return ""
    }
}

func numberToChineseWithUnit(_ number:Int) -> String {
    let numbers = String(number)
    var units = unitParser(numbers.count)
    var finalString = ""
    
    for (index, singleNumber) in numbers.enumerated() {
        let string = singleNumberToChinese(singleNumber)
        if (!(string == "零" && (index+1) == numbers.count)){
            finalString = "\(finalString)\(string)\(units[index])"
        }
    }
    
    return finalString
}

func unitParser(_ unit:Int) -> [String] {
    
    var units = Array(["万","千","百","十",""].reversed())
    let parsedUnits = units[0..<(unit)].reversed()
    let slicedUnits: ArraySlice<String> = ArraySlice(parsedUnits)
    let final: [String] = Array(slicedUnits)
    return final
}

extension Diary {
    func updateTimeWithDate(_ date: Date){
        self.created_at = date
        self.year = Int32(Calendar.current.component(Calendar.Component.year, from: date))
        self.month = Int32(Calendar.current.component(Calendar.Component.month, from: date))
    }
}
