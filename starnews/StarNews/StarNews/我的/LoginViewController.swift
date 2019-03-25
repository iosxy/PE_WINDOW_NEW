//
//  LoginViewController.swift
//  Yuwan
//
//  Created by lqs on 2017/6/14.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import SVProgressHUD

class LoginViewController: BaseViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var weiboButton: UIButton!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var qqButton: UIButton!
    
    var goHomeAfterLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        Utils.addTitleBarTo(view)
        title = "登录"
//            let arr = NSArray()
//            arr[1]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(close(sender:)))
        
        usernameField.leftView = makeImageView(UIImage(named: "login_icon_phone")!, addWidth: 5)
        usernameField.leftViewMode = .always
        passwordField.leftView = makeImageView(UIImage(named: "login_icon_password")!, addWidth: 5)
        passwordField.leftViewMode = .always
        
       let isTest =  UserDefaults.standard.value(forKey: "testEnvironment") as? Bool
        if isTest != nil && isTest! {
            usernameField.text = "15313636660"
            
            passwordField.text = "qqqqqq"
        }
      
    }
    
    @objc func close(sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func makeImageView(_ image: UIImage, addWidth: CGFloat) -> UIImageView {
        let icon = UIImageView(image: image)
        icon.frame = CGRect(x: 0, y: 0, width: image.size.width + addWidth, height: image.size.height);
        icon.contentMode = .center
        return icon
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func login(_ sender: Any) {
        if (usernameField.text == nil || usernameField.text == "" || !self.isPhoneNumber(phoneNumber:usernameField.text)) {
            SVProgressHUD.showInfo(withStatus: "请输入正确的手机号")
            return
        }
        if (passwordField.text == nil || passwordField.text == "") {
            SVProgressHUD.showInfo(withStatus: "密码为空")
            return
        }
        var auth: String? = nil
        SVProgressHUD.show(withStatus: "正在登录中...")
        
        YWAPI_NEW.post(YWNETNEW_newLogin, ["telephone": usernameField.text!, "password": passwordField.text!]).then { data -> Promise<JSON> in
            auth = data["accessToken"].stringValue
            return YWAPI_NEW.fetchUserInfo(auth!)
            }.then {[weak self] userInfo -> Void in
                SVProgressHUD.dismiss()
               
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }.catch { error in
                SVProgressHUD.showInfo(withStatus: "手机号码或密码错误")
        }
        

        YWAPI_NEW.post(YWNETNEW_login, nil).then{item -> Void in
            YWAPI_NEW.setAuth(item["token"].stringValue)
        }
        
        
        
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
        let registerViewController = RegisterViewController()
        registerViewController.isForgetPassword = true
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @IBAction func register(_ sender: Any) {
       self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    

}
