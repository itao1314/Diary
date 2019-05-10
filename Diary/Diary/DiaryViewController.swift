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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
    }
    

}
