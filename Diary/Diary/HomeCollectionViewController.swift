//
//  HomeCollectionViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/4/28.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "HomeYearCollectionViewCell"

class HomeCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self;
        
        let yearLayout = DiaryLayout()
        collectionView.setCollectionViewLayout(yearLayout, animated: false)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeYearCollectionViewCell
        
        cell.textInt = 2015
        cell.labelText = "二零一五 年"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let identifier = "DiaryYearCollectionViewController"
        let dvc = storyboard?.instantiateViewController(withIdentifier: identifier) as! DiaryYearCollectionViewController
        dvc.year = 2015
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
