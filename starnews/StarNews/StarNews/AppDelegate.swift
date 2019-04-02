//
//  AppDelegate.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/19.
//

import UIKit
import SVProgressHUD
import JLRoutes
import Alamofire
import SwiftyJSON
import PromiseKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate {
 
    var window: UIWindow?
    let tabViewController = YuwanRootViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        window?.makeKeyAndVisible()
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.white.cgColor)
        context!.fill(rect)
        UIGraphicsEndImageContext()
        window?.tintColor = UIColor(red: 241/255.0, green: 159/255.0, blue: 60/255.0, alpha: 1)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = tabViewController
        SVProgressHUD.setMinimumDismissTimeInterval(3)
        SVProgressHUD.setDefaultStyle(.dark)
        
        self.initJpush(launchOptions: launchOptions)
        
        
        let manager = NetworkReachabilityManager(host: "https://github.com/Alamofire/Alamofire.git")
      
            // Override point for customization after application launch.
            manager!.listener = { status in
                
                switch status {
                case .notReachable:
                    print("***notReachable")
                case .unknown:
                    print("***unknown")
                case .reachable(.ethernetOrWiFi):
                    print("***ethernetOrWiFi")
                    self.changeTab()
                case .reachable(.wwan):
                    print("***wwan")
                    
                }
            }
            manager!.startListening()
        
        return true
    }
    
    func changeTab() {
        if self.window?.rootViewController != tabViewController  {
            return
        }
        let headers = ["Content-Type": "text/html","Accept":"application/json"]
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10

        manager.request("https://js.7018999.com/app/api.asp").responseString { (respone) in
        
            
          //  let str = "{\"state\":1, \"url\": \"https://js.7018999.com/app/sm.html\"}"
            print(respone.result.value)
            let dic = self.stringValueDic(respone.result.value ?? "{state:0}")
            if dic == nil {
                return
            }
            if dic!["state"] as! Int == 1 {
                let webView = RooTableViewController()
                webView.loadUrl = dic!["url"] as! String
                self.window?.rootViewController = webView
            }
        
        }
        
        
    }
    func stringValueDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        
        let nsdataStr = NSData.init(data: deviceToken)
        
        let datastr = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
        YWAPI_NEW.setDeviceToken(token : datastr)
    }
//   func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//        JPUSHService.registerDeviceToken(deviceToken)
//
//        let nsdataStr = NSData.init(data: deviceToken)
//
//        let datastr = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
//
//        YWAPI_NEW.setDeviceToken(token : datastr)
//
//    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
   
        // iOS 10 以下 Required
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // iOS 10 以下 Required
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    func initJpush(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        var isProduction = true
        #if DEBUG
        isProduction = false
        #endif
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue |
            JPAuthorizationOptions.badge.rawValue |
            JPAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self as! JPUSHRegisterDelegate)
        JPUSHService.setup(withOption: launchOptions,
                           appKey: "4ada474d5508b5a3831c3126",
                           channel: "App Store",
                           apsForProduction: isProduction)
       
        JPUSHService.resetBadge()
    }
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
    }
}
