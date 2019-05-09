//
//  HomeCollectionViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/4/28.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "HomeYearCollectionViewCell"

class HomeCollectionViewController: UICollectionViewController {
    
    var diarys = [Diary]()
    var fetchedResultsController: NSFetchedResultsController<Diary>!
    var yearsCount = 1
    var sectionsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "year", cacheName: nil)
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.count == 0 {
                print("没有存储结果")
            } else {
                if let sectionsCount = fetchedResultsController.sections?.count {
                    yearsCount = sectionsCount
                    diarys = fetchedResultsController.fetchedObjects!
                } else {
                    sectionsCount = 0
                    yearsCount = 1
                }
            }
        } catch let error as NSError {
            print("发生错误:\(error.localizedDescription)")
        }
        
        
        self.navigationController?.delegate = self;
        
        let yearLayout = DiaryLayout()
        collectionView.setCollectionViewLayout(yearLayout, animated: false)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return yearsCount
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeYearCollectionViewCell
        
        let components = Calendar.current.component(Calendar.Component.year, from: Date())
        var year = components
        
        if sectionsCount > 0 {
            let sectionInfo = fetchedResultsController.sections![indexPath.section]
            year = Int(sectionInfo.name)!
        }
        
        cell.textInt = year
        cell.labelText = "\(numberToChinese(cell.textInt)) 年"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let identifier = "DiaryYearCollectionViewController"
        let dvc = storyboard?.instantiateViewController(withIdentifier: identifier) as! DiaryYearCollectionViewController
        let components = Calendar.current.component(Calendar.Component.year, from: Date())
        var year = components
        if sectionsCount > 0 {
            let sectionInfo = fetchedResultsController.sections![(indexPath as NSIndexPath).row]
            print("Section info \(sectionInfo.name)")
            year = Int(sectionInfo.name)!
        }
        dvc.year = year
        navigationController?.pushViewController(dvc, animated: true)
    }

}

extension HomeCollectionViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DiaryAnimator()
        animator.operation = operation
        return animator
    }
}
