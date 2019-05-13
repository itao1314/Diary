//
//  DiaryComposeViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/5/9.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit
import CoreData

let titleTextViewHeight: CGFloat = 50.0

let contentMargin: CGFloat = 20.0

var defaultFont = "Wyue-GutiFangsong-NC"

let DiaryFont = UIFont(name: defaultFont, size: 18)!

let DiaryLocationFont = UIFont(name: defaultFont, size: 16)!

let DiaryTitleFont = UIFont(name: defaultFont, size: 18)!

class DiaryComposeViewController: UIViewController {
    
    var composeView: UITextView!
    
    var locationTextView: UITextView!
    
    var titleTextView: UITextView!
    
    var finishButton: UIButton!
    
    var locationHelper = DiaryLocationHelper()
    
    var diary: Diary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddress(_:)), name:NSNotification.Name(rawValue: "DiaryLocationUpdated") , object: nil)
        
        composeView = UITextView(frame: CGRect(x: 0, y: contentMargin + titleTextViewHeight, width: screenSize.width, height: screenSize.height))
        composeView.font = DiaryFont
        composeView.isEditable = true
        composeView.isUserInteractionEnabled = true
        composeView.textContainerInset = UIEdgeInsets(top: contentMargin, left: contentMargin, bottom: contentMargin, right: contentMargin)
        
        view.addSubview(composeView)
        
        locationTextView = UITextView(frame: CGRect(x: 0, y: composeView.frame.size.height - 30.0, width: screenSize.width - 60, height: 30))
        locationTextView.font = DiaryLocationFont
        locationTextView.isEditable = true
        locationTextView.isUserInteractionEnabled = true
        locationTextView.bounces = false
        
        view.addSubview(locationTextView)
        
        titleTextView = UITextView(frame: CGRect(x: contentMargin, y: contentMargin / 2.0, width: screenSize.width - 60, height: titleTextViewHeight))
        titleTextView.font = DiaryTitleFont
        titleTextView.isEditable = true
        titleTextView.isUserInteractionEnabled = true
        titleTextView.bounces = false
        
        view.addSubview(titleTextView)
        
        finishButton = diaryButtonWith(text: "完", fontSize: 18, width: 50, normalImageName: "Oval", highlightImageName: "Oval_pressed")
        finishButton.center = CGPoint(x: screenSize.width - 20, y: screenSize.height - 30)
        finishButton.addTarget(self, action: #selector(finishCompose(_:)), for: .touchUpInside)
        view .addSubview(finishButton)
        
        finishButton.center = CGPoint(x: view.frame.width - finishButton.frame.size.height/2.0 - 10, y: view.frame.height  - finishButton.frame.size.height/2.0 - 10)
        
        locationTextView.center = CGPoint(x: locationTextView.frame.size.width/2.0 + 20.0, y: finishButton.center.y)
        
        if let diary = diary {
            composeView.text = diary.content
            locationTextView.text = diary.location
            if let title = diary.title {
                titleTextView.text = title
            }
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let rectValue = (notification as NSNotification).userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardSize = rectValue.cgRectValue.size
            updateTextViewSizeForKeyboardHeight(keyboardSize.height)
        }
    }
    
    func updateTextViewSizeForKeyboardHeight(_ keyboardHeight: CGFloat) {
        let newKeyboardHeight = keyboardHeight
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: {
            if (self.locationTextView.text == nil) {
                self.composeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - newKeyboardHeight)
            } else {
                let height = self.view.frame.height - newKeyboardHeight - 40.0 - self.finishButton.frame.size.height/2.0
                self.composeView.frame = CGRect(x: 0, y: contentMargin + titleTextViewHeight, width: self.composeView.frame.size.width, height: height - self.finishButton.frame.size.height/2.0)
            }
            
            self.finishButton.center = CGPoint(x: self.view.frame.width - self.finishButton.frame.size.height/2.0 - 10, y: self.view.frame.height - newKeyboardHeight - self.finishButton.frame.size.height/2.0 - 10)
            
            self.locationTextView.center = CGPoint(x: self.locationTextView.frame.size.width/2.0 + 20.0, y: self.finishButton.center.y)
            
        }, completion: nil)
        
    }
    
    @objc func updateAddress(_ notification: Notification) {
        if let address = notification.object as? String {
            locationTextView.text = "于 \(address)"
        }
        locationHelper.locationManager.stopUpdatingLocation()
    }
    
    @objc func finishCompose(_ button: UIButton) {
        composeView.endEditing(true)
        locationTextView.endEditing(true)
        if composeView.text.lengthOfBytes(using: String.Encoding.utf8) > 1 {
            
            if let diary = diary {
                diary.content = composeView.text
                diary.title = titleTextView.text
                diary.location = locationTextView.text
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Diary", in: managedContext)
                let newdiary = Diary(entity: entity!, insertInto: managedContext)
                newdiary.content = composeView.text
                
                if let address = locationHelper.address {
                    newdiary.location = address
                }
                
                if let title = titleTextView.text {
                    newdiary.title = title
                }
                
                newdiary.updateTimeWithDate(Date())
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("保存错误 \(error.description)")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
