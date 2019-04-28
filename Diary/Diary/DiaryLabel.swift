//
//  DiaryLabel.swift
//  Diary
//
//  Created by TaoTao on 2019/4/28.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

func sizeHeightWithText(labelText: NSString, fontSize: CGFloat, textAttributedString: [NSAttributedString.Key: AnyObject] ) -> CGRect {
    return labelText.boundingRect(with: CGSize(width: fontSize, height: 480), options: .usesLineFragmentOrigin, attributes: textAttributedString, context: nil);
}

class DiaryLabel: UILabel {
    
    var textAttributes: [NSAttributedString.Key: AnyObject]!
    
    convenience init(fontName: String, labelText: String, fontSize: CGFloat, lineHeight: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let font = UIFont(name: fontName, size: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        textAttributes = [NSAttributedString.Key.font: font!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let labelSize = sizeHeightWithText(labelText: labelText as NSString, fontSize: fontSize, textAttributedString: textAttributes)
        frame = CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
        attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
        lineBreakMode = .byCharWrapping
        numberOfLines = 0
    }
    
    func updateText(labelText: String) {
        let labelSize = sizeHeightWithText(labelText: labelText as NSString, fontSize: font.pointSize, textAttributedString: textAttributes)
        self.frame = CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
        self.attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
    }

}
