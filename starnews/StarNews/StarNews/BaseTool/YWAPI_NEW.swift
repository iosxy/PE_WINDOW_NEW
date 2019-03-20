//
//  YWAPI.swift
//  Yuwan
//
//  Created by lqs on 2017/6/20.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit
import SVProgressHUD

class YWAPI_NEW: NSObject {
    static let yuwanUserInfoChangedNotificationName = Notification.Name("YuwanUserInfoChanged")
    static let yuwanUserLoginNotificationName = Notification.Name("YuwanUserLogin")
    //  private static let PREFIX = "http://api.yuwantop.com"
    
    static func getPrefix() -> String {
         let isTest:Bool? = isTestEnvironment()
        if isTest != nil && isTest! {
           return "http://192.168.1.132:8080/yuwanapi/app/"  //周刚环境
//            return "http://47.92.126.120:8080/yuwanapi/app/"  //新开发环境
              //return "http://47.92.91.26/yuwanapi/ap p/"  //开发环境
           
            return "https://test-sslapp.yuwantop.com/yuwanapi/app/" //测试环境 转 HTTPS
        } else {
      
            return YW_API_PRODUCTION + "yuwanapi/app/"
        }
    }
    
    static func get(_ uri: String, _ parameters: [String: Any]? = nil) -> Promise<JSON> {
        return request(uri: uri, method: .get, parameters: parameters)
    }
    static func setDeviceToken(token : String){
        UserDefaults.standard.set(token, forKey: "deviceToken")
    }
    static func getDeviceToken() -> String {
        let token = UserDefaults.standard.value(forKey: "deviceToken") as? String ?? "未知ID"

        return String(token)
    }
    static func post(_ uri: String, _ parameters: [String: Any]? = nil) -> Promise<JSON> {
        return request(uri: uri, method: .post, parameters: parameters)
    }
    
    static func setAuth(_ auth: String) {
        UserDefaults.standard.set(auth, forKey: "userToken")
    }
    
    static func getAuth() -> String? {
        return UserDefaults.standard.value(forKey: "userToken") as? String
    }
    
    static func setTestEnvironment(_ testEnviron: Bool) {
        UserDefaults.standard.set(testEnviron, forKey: "testEnvironment")
    }
    
    static func isTestEnvironment() -> Bool? {
      
        return UserDefaults.standard.value(forKey: "testEnvironment") as? Bool
    }
//    static func requestLogin() -> Bool {
//        guard YWAPI.getAuth() != nil else {
//            let vc = LoginViewController().inNavigationController()
//            Utils.getNavigationController().present(vc, animated: true) {
//
//            }
//            return false
//        }
//        return true
//    }
    
    static func fetchUserInfo(_ auth: String) -> Promise<JSON> {
        // let headers = ["auth": auth, "Cookie": "auth=" + auth]
        
        return Promise { fulfill, reject in
            
            YWAPI_NEW.post(YWNETNEW_profile, ["userToken":auth]).then{ respone -> Void in
                if self == nil {
                    return
                }
                fulfill(respone["data"])
                UserDefaults.standard.set(respone["data"].rawString(), forKey: "yuwanUserInfo")
                NotificationCenter.default.post(name: yuwanUserInfoChangedNotificationName, object: nil, userInfo: ["yuwanUserInfo": respone["data"]])
                
                }.catch(execute: { (error) in
                    // reject(NSError(domain: , code: 42, userInfo: [NSLocalizedDescriptionKey: "error"]))
                    reject(error as NSError)
                })
            
        }
    }
    static func getUserInfo() -> JSON? {
        let jsonString = UserDefaults.standard.value(forKey: "yuwanUserInfo") as? String
        if (jsonString != nil) {
            return JSON(parseJSON: jsonString!)
        } else {
            return nil
        }
    }
    
    static func getUserModel() -> UserBean? {
        guard let json = getUserInfo() else {
            return nil
        }
        let bean = UserBean()
        bean.id = json["id"].numberValue
        bean.name = json["name"].stringValue
        bean.avatar = json["avatar"].string
        bean.telephone = json["telephone"].stringValue
        bean.gender = json["gender"].numberValue
        bean.nick = json["nick"].stringValue
        bean.signature = json["signature"].stringValue
        bean.birthDate = json["birthDate"].numberValue
        bean.region?.province = json["region"]["province"].stringValue
        bean.region?.city = json["region"]["city"].stringValue
        bean.region?.county = json["region"]["county"].stringValue

        return bean
    }
    
    static func clearAuth() {
        NotificationCenter.default.post(name: yuwanUserInfoChangedNotificationName, object: nil, userInfo: nil)
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "yuwanAuth")
        UserDefaults.standard.removeObject(forKey: "yuwanUserInfo")
    }
    static func updateUserInfo (userInfo : String) {
        UserDefaults.standard.set(userInfo, forKey: "yuwanUserInfo")
    }
    //新接口
    private static func request(uri: String, method: HTTPMethod, parameters: [String: Any]?) -> Promise<JSON> {
    
        let auth = getAuth()
        let token = auth == nil ? "" : auth!
       
        let headers = ["Content-Type": "application/json","Accept":"application/json"]
        var  paramubtable:[String :Any]
        if method == .post {
           paramubtable  = ["token":token,"map":parameters];
        }else{
            paramubtable = parameters!
        }
        
        debugPrint(paramubtable)
        return Promise { fulfill, reject in
         
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 10
            manager.request(getPrefix() + uri, method: method, parameters: paramubtable,encoding:JSONEncoding.default,headers:headers).responseJSON { (response) in
                
                    debugPrint(response)
                if (response.result.value == nil) {
                    reject(NSError(domain: "test", code: 42, userInfo: [NSLocalizedDescriptionKey: "error"]))
                    SVProgressHUD.dismiss()
                    //SVProgressHUD.showError(withStatus: "网络超时，请稍候再试")
                    
                    return
                }
                let object = JSON(response.result.value!)
                let code = object["code"].intValue
                let subCode = object["subCode"].intValue
                if (code != 9091 || subCode != 10002) {
                    if (code == -2 || code == -3) {
                        clearAuth()
                    }
                    debugPrint(object["message"])
                    var code = 42
                    if object["message"].stringValue.contains("verifyCode") {  //验证码错误
                        code = 101
                    } else if object["message"].stringValue.contains("exist") { //用户不存在
                        code = 102
                    }
                    
                    reject(NSError(domain: object["subMessage"].stringValue, code: code, userInfo: [NSLocalizedDescriptionKey: object["subMessage"].stringValue]))
                } else {
                    
                    fulfill(object["data"])
                }
                debugPrint(object)
            }
        }
    }
    //上传头像
    static func upload(_ uri: String, _ name: String, _ data: Data) -> Promise<JSON> {
        let auth = getAuth()
        let headers = auth == nil ? nil : ["auth": auth!, "Cookie": "auth=" + auth!]
        
        return Promise { fulfill, reject in
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: name, fileName: "1.jpg", mimeType: "image/jpeg")
            },
                to: YWAPI_NEW.getPrefix() + uri,
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            fulfill(JSON(response.result.value!)["data"])
                        }
                    case .failure(let encodingError):
                        reject(encodingError)
                    }
            }
            )
        }
    }
}

