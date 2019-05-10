//
//  DiaryYearCollectionViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/4/28.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "DiaryCell"

class DiaryYearCollectionViewController: UICollectionViewController {
    
    var year: Int!
    var diarys = [Diary]()
    var fetchedResultsController: NSFetchedResultsController<Diary>!
    var monthCount = 1
    var sectionsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = DiaryLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        do {
            let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
            fetchRequest.predicate = NSPredicate(format: "year=\(year!)")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "month", cacheName: nil)
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.count == 0 {
                print("没有存储结果")
            } else {
                if let sectionsCount = fetchedResultsController.sections?.count {
                    monthCount = sectionsCount
                    diarys = fetchedResultsController.fetchedObjects!
                } else {
                    sectionsCount = 0
                    monthCount = 1
                }
            }
        } catch let error as NSError {
            print("发现错误: \(error.description)")
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return monthCount
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        
        let components = Calendar.current.component(Calendar.Component.month, from: Date())
        var month = components
        
        if sectionsCount > 0 {
            let sectionInfo = fetchedResultsController.sections![indexPath.section]
            month = Int(sectionInfo.name)!
        }
        
        cell.textInt = month
        cell.labelText = "\(numberToChinese(cell.textInt)) 月"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let identifier = "DiaryMonthCollectionViewController"
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! DiaryMonthCollectionViewController
        
        let components = Calendar.current.component(Calendar.Component.month, from: Date())
        var month = components
        if sectionsCount > 0 {
            let sectionInfo = fetchedResultsController.sections![indexPath.section]
            month = Int(sectionInfo.name)!
        }
        dvc.month = month
        dvc.year = year
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
}
