//
//  Helper.swift
//  Diary
//
//  Created by TaoTao on 2019/5/8.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

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
