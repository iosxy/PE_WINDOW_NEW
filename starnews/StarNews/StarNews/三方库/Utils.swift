//
//  Utils.swift
//  Yuwan
//
//  Created by lqs on 2017/6/17.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
import EVReflection

class YWDateComponents {
  var day: Int = 0
  var hour: Int = 0
  var minute: Int = 0
  var second: Int = 0
  
  init() {
  }
}

class Utils: NSObject {
    enum MessageType:Int {
        case defaultMessage = 0 , getLotteryKind = 100 , getLotteryKaMiNotSend,getLotteryKaMiSend,getLotteryKindSend,shopKaMiNotSend,shopKaMiSend,shopKindSend,youZanShopKindSend,crowdSuccess,crowdFail,messageByReplay,news,tv,movie,star,town,outlinks,handSendKaMi,shopKaMiHandSend,ticketSend,ticketNotSend
    }
    //100 抽奖获得实物 101抽奖获得卡密未发放  102 抽奖获得卡密发放  103 抽奖获得实物未发放 104 商城兑换获得卡密未发放 105 商城兑换获得卡密发放 106 商城兑换获得实物发货 107 有赞商城实物发货 108 参与的众筹项目成功 109 参与的众筹项目失败 110 评论被回复 111新闻 112电视剧 113电影 114 娱丸卡 115娱丸话题 116外联 117 手动发放卡密 118 商城卡密手动发放 119 名额类票务发放 120 票务兑换成功未发放
  static func addTitleBarTo(_ superview: UIView) {
    //        let maskView = UIView()
    //        maskView.backgroundColor = UIColor(red: 1, green: 0x98/255.0, blue: 0, alpha: 1)
    let maskView = UIImageView(image: UIImage(named: "nav_backgrd"))
    superview.addSubview(maskView)
    
    maskView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(kTopHeight)
    }
    superview.bringSubviewToFront(maskView)
  }
  
   static func jumpToTabbarSeletcedIndex(index : Int) -> Void {
        if index > 4 || index < 0{
            return;
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
    appDelegate.tabViewController.tabVC.selectedIndex = index
        
    }
    
  static func getNavigationController() -> UINavigationController {
    /*
     let resideMenu = UIApplication.shared.delegate!.window!!.rootViewController as! RESideMenu
     return resideMenu.contentViewController as! UINavigationController
     */
    var vc = UIApplication.shared.delegate!.window!!.rootViewController!
    while (vc.presentedViewController != nil) {
      vc = vc.presentedViewController!
    }
    let nav = vc as? UINavigationController
    if nav != nil {
      return nav!
    }
    
    let app = UIApplication.shared.delegate as! AppDelegate
    return app.tabViewController
  }
 static func getCurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurrentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getCurrentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrentViewController(base: presented)
        }
        return base
    }
   
    
  static func makeAutoHeight(_ view: UIView, x: CGFloat, y: CGFloat, width: CGFloat) {
    //        NSLog("before makeAutoHeight")
    view.frame = CGRect(x: x, y: y, width: width, height: 10)
    //        NSLog("before systemLayoutSizeFitting")
    let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    //        NSLog("after systemLayoutSizeFitting")
    view.frame = CGRect(x: x, y: y, width: width, height: size.height)
    //        NSLog("after makeAutoHeight")
  }
  
  static func addHeight(_ view: UIView, height: CGFloat) {
    //        NSLog("before addHeight")
    
    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height + height)
    //        NSLog("after addHeight")
    
  }
  
  static func alert(_ message: String, _ title: String? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "好", style: .default, handler: { (alertAction) in
      alertController.dismiss(animated: true, completion: {
        // TODO
      })
    }))
    Utils.getNavigationController().present(alertController, animated: true, completion: nil)
  }
  
  static func calcAspectRatio(image: JSON, defaultValue: CGFloat = .pi) -> CGFloat {
    let width = image["width"].floatValue
    let height = image["height"].floatValue
    return width > 0 && height > 0 ? CGFloat(width / height) : defaultValue
  }
  
  static func getDate(_ unixdate: Int64, format: String = "yyyy-MM-dd") -> String {
    var date : NSDate!
    if String(unixdate).count == 10 {
        date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
    }else {
        date = NSDate(timeIntervalSince1970: TimeInterval(unixdate / 1000))
    }
    
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = format
    //        dayTimePeriodFormatter.timeZone = NSTimeZone(name: timezone) as TimeZone!
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    
    return dateString
  }
    static func getDateNew(_ unixdate: String!, format: String = "yyyy/MM/dd") -> String {
        
        let string =  unixdate
        let fom = "yyyy-MM-dd HH:mm:ss"
        
        let fommater = DateFormatter()
        fommater.dateFormat = fom
        
        let date = fommater.date(from: string!)
        
        let string2 = fommater.string(from: date!)
        
        let newFommater = DateFormatter()
        newFommater.dateFormat = format
        let date2 = newFommater.string(from: date!)
        
        return date2

    }
    
  static func getSignDate(dateStr: String) -> String {
    let srcFormatter = DateFormatter()
    srcFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let srcDate = srcFormatter.date(from: dateStr)
    let dstFormatter = DateFormatter()
    dstFormatter.dateFormat = "yyyy.MM.dd"
    let dstString = dstFormatter.string(from: srcDate!)
    return dstString
  }
    
    
  static func lineNumber(label: UILabel, text: String) -> Int {
    let oneLineSize = CGSize(width: label.bounds.size.width, height: .greatestFiniteMagnitude)
    let oneLineRect  =  "a".boundingRect(with: oneLineSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
    let size = CGSize(width: label.bounds.size.width, height: .greatestFiniteMagnitude)
    let boundingRect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
    return Int(boundingRect.height / oneLineRect.height)
  }
  
  
    
 

  static func timeRemainingSinceNow(_ endTime: NSNumber) -> YWDateComponents {
    var delta = Int(Date(timeIntervalSince1970: endTime.doubleValue / 1000).timeIntervalSinceNow)
    let component = YWDateComponents()
    component.second = delta % 60
    delta /= 60
    component.minute = delta % 60
    delta /= 60
    component.hour = delta % 24
    delta /= 24
    component.day = delta
    return component
  }

  static func timePastSince(_ time: NSNumber) -> YWDateComponents {
    var delta = -Int(Date(timeIntervalSince1970: time.doubleValue / 1000).timeIntervalSinceNow)
    let component = YWDateComponents()
    component.second = delta % 60
    delta /= 60
    component.minute = delta % 60
    delta /= 60
    component.hour = delta % 24
    delta /= 24
    component.day = delta
    return component
  }

  static func timePastSinceToEnd(_ time: NSNumber, _ endTime: NSNumber) -> YWDateComponents {
    var delta = -Int(Date(timeIntervalSince1970: time.doubleValue / 1000).timeIntervalSinceNow)
    var delta2 = -Int(Date(timeIntervalSince1970: endTime.doubleValue / 1000).timeIntervalSinceNow)
    if delta2 > 0 {
        delta = delta - delta2
    }
    let component = YWDateComponents()
    component.second = delta % 60
    delta /= 60
    component.minute = delta % 60
    delta /= 60
    component.hour = delta % 24
    delta /= 24
    component.day = delta
    return component
  }

  static func timeRemainingStringSinceNow(_ time: NSNumber) -> String {
    let component = timeRemainingSinceNow(time)
    if (component.day > 0) {
      return String(component.day) + "天"
    }
    if (component.hour > 0) {
      return String(component.hour) + "小时"
    }
    if (component.minute > 0) {
      return String(component.minute) + "分钟"
    }
    return "0天"
  }

  static func shortNumberString(_ num: NSNumber) -> String {
    if (num.doubleValue < 10000) {
      return num.stringValue
    }
    
    let divisor = pow(10.0, Double(1))
    let new =  (num.doubleValue / 10000 * divisor).rounded() / divisor
    
    return String(format: "%.1f万", new )
    
  }

  static func beanObjectToJSON(_ bean: EVObject) -> JSON {
    return JSON(parseJSON: bean.toJsonString())
  }
    static func cheackStatus(){

        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    YWAPI_NEW.post(YWNETNEW_querryStatus,["auditEdition" :currentVersion]).then { respone -> Void in
        let userDefaults = UserDefaults.standard
        userDefaults.set(respone["status"].bool, forKey: "status")
        userDefaults.synchronize()
            }.catch{ error -> Void in
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "status")
                userDefaults.synchronize()
        }
        
    }
    static func getStatus() -> Bool {
        
        let userDefaults = UserDefaults.standard
        let result = userDefaults.object(forKey: "status") as? Bool
        if result == nil {
            return true
        }
        return result!
    }
    
    static func setShareOpenUrlStatus(_ status : Bool?) {
        if status != nil {
            UserDefaults.standard.set(status, forKey: "shareOpenUrlStatus")
        }
    }
    static func getShareOpenUrlStatus() -> Bool {
        
        let status = UserDefaults.standard.object(forKey: "shareOpenUrlStatus") as? Bool
        if (status == nil) {
            return false
        }else {
            return status!
        }
        
    }
    static func cheackIsFirstRunningCard() -> Bool{
        
        let isFirstRunning = UserDefaults.standard.object(forKey: "isFirstRunning") as? Bool
        
        if isFirstRunning == nil {
            
            UserDefaults.standard.set(false, forKey: "isFirstRunning")
            return true
            
        }else {
            UserDefaults.standard.set(false, forKey: "isFirstRunning")
            return false
        }
    }
    static func cheackIsFirstRunningArticle() -> Bool{
        
        let isFirstRunning = UserDefaults.standard.object(forKey: "isFirstRunningArticle") as? Bool
        
        if isFirstRunning == nil {
            
            UserDefaults.standard.set(false, forKey: "isFirstRunningArticle")
            return true
            
        }else {
            UserDefaults.standard.set(false, forKey: "isFirstRunningArticle")
            return false
        }
    }
    
    
    
    static func removeAllZero(value : Double) -> String {
        
        var str = String(value)
        let len = str.count
        for i in 0...len - 1 {
            
            if (!str.hasSuffix("0")){
                break
            }else {
                
                str =  String(str.prefix(len - 2))
            }
            
        }
        if (str.hasSuffix(".")){
            return String(str.prefix(len - 2))
        }else {
            return str;
        }
        
    }
 
}

