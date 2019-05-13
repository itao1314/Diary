//
//  DiaryViewController.swift
//  Diary
//
//  Created by TaoTao on 2019/5/10.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit
import WebKit

class DiaryViewController: UIViewController {
    
    var diary: Diary!
    
    var webView: WKWebView!
    
    var saveButton: UIButton!
    
    var deleteButton: UIButton!
    
    var editButton: UIButton!
    
    var buttonsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        showButtons()
    }
    
    func setupUI() {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        webView.scrollView.bounces = true
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
        
        let mainHTML = Bundle.main.url(forResource: "DiaryTemplate", withExtension: "html")
        var contents: NSString = ""
        do {
            contents = try NSString(contentsOfFile: mainHTML!.path, encoding: String.Encoding.utf8.rawValue)
        } catch let error as NSError {
            print("\(error)")
        }
        
        let year = (Calendar.current as NSCalendar).component(NSCalendar.Unit.year, from: diary.created_at!)
        
        let month = (Calendar.current as NSCalendar).component(NSCalendar.Unit.month, from: diary.created_at!)
        
        let day = (Calendar.current as NSCalendar).component(NSCalendar.Unit.day, from: diary.created_at!)
        
        let timeString = "\(numberToChinese(year))年 \(numberToChinese(month))月 \(numberToChinese(day))日"
        
        contents = contents.replacingOccurrences(of: "#timeString#", with: timeString) as NSString
        
        let newDiaryString = diary.content?.replacingOccurrences(of: "\n", with: "</br>", options: NSString.CompareOptions.literal, range: nil)
        contents = contents.replacingOccurrences(of: "#newDiaryString#", with: newDiaryString!) as NSString
        
        var title = ""
        var contentWidthOffset = 140
        var contentMargin = 10
        if let titleStr = diary?.title {
            let parsedTime = "\(numberToChineseWithUnit((Calendar.current as NSCalendar).component(NSCalendar.Unit.day, from: diary.created_at!))) 日"
            if titleStr != parsedTime {
                title = titleStr
                contentWidthOffset = 205
                contentMargin = 10
                title = "<div class='title'>\(title)</div>"
            }
        }
        
        contents = contents.replacingOccurrences(of: "#contentMargin#", with: "\(contentMargin)") as NSString
        
        contents = contents.replacingOccurrences(of: "#title#", with: "\(title)") as NSString
        
        let minWidth = view.frame.size.width - CGFloat(contentWidthOffset)
        
        contents = contents.replacingOccurrences(of: "#minWidth#", with: "\(minWidth)") as NSString
        
        let font = defaultFont
        contents = contents.replacingOccurrences(of:  "#fontStr#", with: "\(font)") as NSString
        
        let titleMarginRight:CGFloat = 15
        
        contents = contents.replacingOccurrences(of: "#titleMarginRight#", with: "\(titleMarginRight)") as NSString
        
        if let location = diary.location {
            contents = contents.replacingOccurrences(of: "#location#", with: location) as NSString
        } else {
            contents = contents.replacingOccurrences(of: "#location#", with: "") as NSString
        }
        
        webView.loadHTMLString(contents as String, baseURL: nil)
        
        buttonsView = UIView()
        buttonsView.frame = CGRect(x: 0, y: screenSize.height - 60, width: screenSize.width, height: 60)

        buttonsView.alpha = 0;
        view.addSubview(buttonsView)
        
        let buttonFontSize: CGFloat = 18.0
        
        saveButton = diaryButtonWith(text: "存", fontSize: buttonFontSize, width: 50, normalImageName: "Oval", highlightImageName: "Oval_pressed")
        saveButton.center = CGPoint(x: buttonsView.frame.size.width / 2.0, y: buttonsView.frame.size.height / 2.0)
        saveButton.addTarget(self, action: #selector(saveToRoll), for: .touchUpInside)
        buttonsView.addSubview(saveButton)
        
        deleteButton = diaryButtonWith(text: "删", fontSize: buttonFontSize, width: 50, normalImageName: "Oval", highlightImageName: "Oval_pressed")
        deleteButton.center = CGPoint(x: saveButton.center.x + 60, y: buttonsView.frame.size.height / 2.0)
        buttonsView.addSubview(deleteButton)
        
        editButton = diaryButtonWith(text: "改", fontSize: buttonFontSize, width: 50, normalImageName: "Oval", highlightImageName: "Oval_pressed")
        editButton.center = CGPoint(x: saveButton.center.x - 60, y: buttonsView.frame.size.height / 2.0)
        editButton.addTarget(self, action: #selector(editDiary), for: .touchUpInside)
        buttonsView.addSubview(editButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showButtons))
        tap.delegate = self;
        webView .addGestureRecognizer(tap)
    }
    
    @objc func showButtons() {
        if buttonsView.alpha == 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.buttonsView.center = CGPoint(x: self.buttonsView.center.x,
                                                  y: screenSize.height - self.buttonsView.frame.size.height/2.0)
                self.buttonsView.alpha = 1.0
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.buttonsView.center = CGPoint(x: self.buttonsView.center.x, y: screenSize.height + self.buttonsView.frame.size.height/2.0)
                self.buttonsView.alpha = 0
            }, completion: nil)
        }
    }
    
    @objc func editDiary() {
        let identifier = "DiaryComposeViewController"
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! DiaryComposeViewController
        
        if let diary = diary {
            dvc.diary = diary
        }
        
        self.present(dvc, animated: true, completion: nil)
    }
    
    @objc func saveToRoll() {
        
        let offSet = webView.scrollView.contentOffset.x
        let image = webView.captureView()
        webView.scrollView.contentOffset.x = offSet
        
        var sharingItems = [AnyObject]()
        sharingItems.append(image)
        
        let activityController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = saveButton
        self.present(activityController, animated: true, completion: nil)
    }
    
    @objc func deleteThisDiary() {
        managedContext.delete(diary)
        do {
            try managedContext.save()
        } catch _ {
            
        }
        hideDiary()
    }
    
    func hideDiary() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DiaryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
