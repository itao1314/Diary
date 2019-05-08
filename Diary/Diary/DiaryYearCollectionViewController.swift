//
//  DiaryYearCollectionViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/4/28.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DiaryCell"

class DiaryYearCollectionViewController: UICollectionViewController {
    
    var year: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = DiaryLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        cell.labelText = "一月"
        cell.textInt = 1
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let identifier = "DiaryMonthCollectionViewController"
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! DiaryMonthCollectionViewController
        dvc.month = 1
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
}
