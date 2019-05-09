//
//  DiaryLayout.swift
//  Diary
//
//  Created by TaoTao on 2019/4/28.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit



class DiaryLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsets(top: screenSize.height / 2.0 - itemHeight / 2.0, left: screenSize.width / 2.0 - itemWidth / 2.0, bottom: screenSize.height / 2.0 - itemHeight / 2.0, right: screenSize.width / 2.0 - itemWidth / 2.0)
        scrollDirection = .horizontal
    }
}
