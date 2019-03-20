//
//  NSObject+Tools.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/6/19.
//  Copyright © 2018年 lqs. All rights reserved.
//

import Foundation

public extension NSObject {

    func createLabel(_ title : String! ,_ titleColor : UIColor!,_ font : Int ,_ supView: UIView) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = titleColor
        label.yw_font(size: CGFloat(font))
        supView.addSubview(label)
        return label
    }
    /// 将颜色转换为图片
    ///
    /// - Parameter color: <#color description#>
    /// - Returns: <#return value description#>
    func getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func getImageWithView(view : UIView) -> UIImage {
        let s = view.bounds.size
        UIGraphicsBeginImageContext(s)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!;
    }
  
    //字符串转字典
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString: <#jsonString description#>
    /// - Returns: <#return value description#>
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    //校验手机号
    func isPhoneNumber(phoneNumber:String?) -> Bool {
        if phoneNumber == nil || phoneNumber == "" || phoneNumber?.count != 11{
            return false
        }
        if phoneNumber?.characters.count == 0 {
            return false
        }
        let mobile = "^(11[0-9]|12[0-9]|14[0-9]|19[0-9]|13[0-9]|15[0-9]|16[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else
        {
            return false
        }
    }
    
    
    //校验s身份证
    func isIDCode(code:String?) -> Bool {
        if code == nil || code == "" || code?.count != 18{
            return false
        }
        if code?.characters.count == 0 {
            return false
        }
        let mobile = "^(\\d{17})(\\d|[xX])$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: code) == true {
            return true
        }else
        {
            return false
        }
    }
    
    
    //校验图文验证码
    func isImageCode(code:String?) -> Bool {
        if code == nil || code == "" || code?.count != 4{
            return false
        }
        if code?.characters.count == 0 {
            return false
        }
        let mobile = "^[a-zA-Z0-9]{4}"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: code) == true {
            return true
        }else
        {
            return false
        }
    }
}




public extension String {
    
    func compareCurrentTime(time:String!) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObj =  formatter.date(from: time)
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: dateObj!)
        let mydate = dateObj?.addingTimeInterval(TimeInterval(interval))
        let nowDate = Date().addingTimeInterval(TimeInterval(interval))
        var timeInterval = mydate?.timeIntervalSince(nowDate)
        timeInterval = -timeInterval!
        let timeCount = Int(timeInterval!)
      
        var result:String? = ""
//         if(timeCount/60 <= 60){
//            result = String(timeCount/60) + "分钟前";
//        }
//
//        else if(timeCount/(60*60) <= 24){
//
//            result = String(timeCount/(60*60)) + "小时前";
//        }
//
//        else if((timeCount/(24*60*60)) <= 30){
//            result = String(timeCount/(60*60*24)) + "天前";
//        }
//
//        else if((timeCount/(24*60*60*30)) <= 12){
//            result = String(timeCount/(60*60*24*30)) + "月前";
//        }
//        else{
//
//            result = String(timeCount/(60*60*24*30*12)) + "年前";
//        }
       if(timeCount <= 60){
            result = "刚刚"
        }
       else if(timeCount/60 < 60){
            result = String(timeCount/60) + "分钟前";
        }
            
        else if(timeCount/(60*60) < 24){
            
            result = String(timeCount/(60*60)) + "小时前";
        }
            
        else if((timeCount/(24*60*60)) <= 30){
            result = time;
        }
            
        else if((timeCount/(24*60*60*30)) <= 12){
            result = time;
        }
        else{
            
            result = time;
        }
        return result!;
    }
}

