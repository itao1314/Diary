//
//  DiaryMonthCollectionViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/5/8.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DiaryCell"

let DiaryRed = UIColor(red: 192.0/255.0, green: 23.0/255.0, blue: 48.0/255.0, alpha: 1)

class DiaryMonthCollectionViewController: UICollectionViewController {
    
    var month: Int!
    
    var yearLabel: DiaryLabel!
    
    var monthLabel: DiaryLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = DiaryLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        let screenSize = UIScreen.main.bounds.size
        
        yearLabel = DiaryLabel(fontName: "TpldKhangXiDictTrial", labelText: "二零一五年", fontSize: 16, lineHeight: 5, color: UIColor.black)
        let yearLabelSize = yearLabel.frame.size
        yearLabel.frame = CGRect(x: screenSize.width - yearLabelSize.width - 20, y: 40, width:yearLabelSize.width, height: yearLabelSize.height)
        view.addSubview(yearLabel)
        
        monthLabel = DiaryLabel(fontName: "Wyue-GutiFangsong-NC", labelText: "三月", fontSize: 16, lineHeight: 5, color: DiaryRed)
        let monthLabelSize = monthLabel.frame.size
        monthLabel.frame = CGRect(x: screenSize.width - monthLabelSize.width - 20, y: screenSize.height/2.0 - monthLabelSize.height/2.0, width:monthLabelSize.width, height: monthLabelSize.height)
        view.addSubview(monthLabel)
        
        let composeButton = diaryButtonWith(text: "撰", fontSize: 14, width: 40, normalImageName: "Oval", highlightImageName: "Oval_pressed")
        
        composeButton.center = CGPoint(x: yearLabel.center.x,
                                          y: 38 + yearLabel.frame.size.height + 36.0/2.0)
        
        composeButton.addTarget(self, action: #selector(newCompose),
                                for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(composeButton)
    }
    
    @objc func newCompose() {
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        cell.textInt = 1
        cell.labelText = "一月"
        return cell
    }
    
}
