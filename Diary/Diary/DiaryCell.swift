//
//  DiaryCell.swift
//  Diary
//
//  Created by TaoTao on 2019/4/28.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    var textLabel: DiaryLabel!
    var textInt = 0
    var labelText: String = "" {
        didSet {
            textLabel.updateText(labelText: labelText)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel = DiaryLabel(fontName: "Wyue-GutiFangsong-NC", labelText: labelText, fontSize: 16, lineHeight: 5, color: UIColor.black)
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.center = CGPoint(x: itemWidth / 2.0, y: itemHeight / 2.0)
    }
}
