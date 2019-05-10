//
//  DiaryMonthCollectionViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/5/8.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "DiaryCell"

let DiaryRed = UIColor(red: 192.0/255.0, green: 23.0/255.0, blue: 48.0/255.0, alpha: 1)

class DiaryMonthCollectionViewController: UICollectionViewController {
    
    var month: Int!
    
    var year: Int!
    
    var yearLabel: DiaryLabel!
    
    var monthLabel: DiaryLabel!
    
    var fetchedResultsController: NSFetchedResultsController<Diary>!
    
    var diarys = [Diary]()
    
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
        
        do {
            let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
            fetchRequest.predicate = NSPredicate(format: "year = \(year!) AND month = \(month!)")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedResultsController.performFetch()
            if fetchedResultsController.sections?.count == 0 {
                print("没有存储结果")
            } else {
                diarys = fetchedResultsController.fetchedObjects!
            }
        } catch let error as NSError {
            print("发现错误 \(error.localizedDescription)")
        }
    }
    
    @objc func newCompose() {
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "DiaryComposeViewController") as! DiaryComposeViewController
        self.present(dvc, animated: true, completion: nil)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diarys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        let diary = diarys[indexPath.row]
        cell.labelText = diary.title!
        return cell
    }
    
}
