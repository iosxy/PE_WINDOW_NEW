//
//  RegisterViewController.swift
//  Yuwan
//
//  Created by lqs on 2017/6/17.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import SVProgressHUD
import HandyJSON


class RegisterRewardBean:BaseBean, HandyJSON {
    var count: String! = ""
    var startTime: String! = ""
    var endTime: String! = ""
    var online: Bool! = false
}

class RegisterViewController: BaseViewController {

    @IBOutlet weak var telephoneField: UITextField!
    @IBOutlet weak var verifyCodeField: UITextField!
    @IBOutlet weak var verifyCodeButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
  
    private var bean: RegisterRewardBean?
    
    var isForgetPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utils.addTitleBarTo(view)
        self.setupBackButton()
        
        if (isForgetPassword) {
            registerButton.setTitle("确定", for: .normal)
            title = "忘记密码"
            passwordField.placeholder = "输入新密码"
        } else {
            title = "注册"
        }
        telephoneField.leftView = makeImageView(UIImage(named: "login_icon_phone")!, addWidth: 5)
        telephoneField.leftViewMode = .always
        verifyCodeField.leftView = makeImageView(UIImage(named: "login_icon_code")!, addWidth: 5)
        verifyCodeField.leftViewMode = .always
        passwordField.leftView = makeImageView(UIImage(named: "login_icon_password")!, addWidth: 5)
        passwordField.leftViewMode = .always
      
  
        YWAPI_NEW.post(YWNETNEW_getConfig, ["key" : "register.send.yuwan"]).then{[weak self] respone -> Void in
            if self == nil  {
                return
            }
            self!.bean = RegisterRewardBean.deserialize(from: respone["config"].dictionaryObject)
        }

    }
    
    private func makeImageView(_ image: UIImage, addWidth: CGFloat) -> UIImageView {
        let icon = UIImageView(image: image)
        icon.frame = CGRect(x: 0, y: 0, width: image.size.width + addWidth, height: image.size.height);
        icon.contentMode = .center
        return icon
    }

    var countDown = 0
    
    var timer: Timer? = nil
    
    @IBAction func sendVerifyCode(_ sender: Any) {
        
        if (!self.isPhoneNumber(phoneNumber:telephoneField.text)) {
            SVProgressHUD.showInfo(withStatus: "请输入正确的手机号码")
            return
        }
        
        let vc = YWImageVerificationCodeViewController()
        vc.telephone = telephoneField.text
        vc.onDone = {
            self.resetTimer()
            self.verifyCodeField.becomeFirstResponder()
        }
        vc.show(parent: self)
        
        //self.getVerifyCode()
    }
    
//    func getVerifyCode() -> Void {
//        SVProgressHUD.show(withStatus: "正在获取中...")
//        verifyCodeButton.isEnabled = false
//        YWAPI.post(YWNET_verifyCode, ["telephone": telephoneField.text!]).then { data -> Void in
//            self.resetTimer()
//            SVProgressHUD.dismiss()
//            }.catch { error in
//                SVProgressHUD.showInfo(withStatus: "获取失败，请稍后重试")
//        }
//    }
    
    private func resetTimer() {
        self.countDown = 60
        self.timer?.invalidate()
        doCountDown()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(doCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func doCountDown() {
        if (countDown >= 1) {
            verifyCodeButton.setTitle("\(countDown)s", for: .normal)
            verifyCodeButton.isEnabled = false
            countDown -= 1
        } else {
            verifyCodeButton.setTitle("重发验证码", for: .normal)
            verifyCodeButton.isEnabled = true
            self.timer?.invalidate()
        }
    }
    
    @IBAction func register(_ sender: Any) {
        if (telephoneField.text == nil || telephoneField.text == "" || !self.isPhoneNumber(phoneNumber:telephoneField.text)) {
            SVProgressHUD.showInfo(withStatus: "请输入正确的手机号")
            return
        }
        if (verifyCodeField.text == nil || verifyCodeField.text == "") {
            SVProgressHUD.showInfo(withStatus: "验证码为空")
            return
        }
        if (passwordField.text == nil || passwordField.text == "") {
            SVProgressHUD.showInfo(withStatus: "密码为空")
            return
        }
        let uri = isForgetPassword ? YWNETNEW_forgetPassword : YWNET_register
        
        if isForgetPassword {
            SVProgressHUD.show(withStatus: "正在修改中...")
        } else {
            SVProgressHUD.show(withStatus: "正在注册中...")
        }
      
        
        if self.isForgetPassword {
            var auth: String? = nil
            YWAPI_NEW.post(YWNETNEW_forgetPassword, ["telephone": telephoneField.text!,
                                     "verifyCode": verifyCodeField.text!,
                                     "password": passwordField.text!]).then {[weak self] respone -> Void in
                                        if self == nil {
                                            return
                                        }
                     SVProgressHUD.showSuccess(withStatus: "修改密码成功")
                        self!.navigationController?.popViewController(animated: true)
                                        
                    }.catch {[weak self] error in
                     
                        SVProgressHUD.showInfo(withStatus: "验证码错误")
                      
                    }
        }else{
            self.resgiter()
          
        }

    }

    func resgiter() -> Void {
        
        var auth: String? = nil
        YWAPI_NEW.post(YWNETNEW_register, ["telephone":self.telephoneField.text,"verifyCode":verifyCodeField.text,"password":passwordField.text!,"inviterId":"0"]).then { data -> Promise<JSON> in
               auth = data["accessToken"].stringValue
            return YWAPI_NEW.fetchUserInfo(auth!)}.then{[weak self] userInfo -> Void in
           
                self?.onRegisterSuccess(auth: auth!, userInfo: userInfo)
            }.catch {
                [weak self] (error) in
                let errorCode = error as NSError
                SVProgressHUD.showInfo(withStatus: errorCode.domain)
       
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  func onRegisterSuccess(auth: String, userInfo: JSON) {
    
    YWAPI_NEW.fetchUserInfo(auth)
    
    self.navigationController?.dismiss(animated: true, completion: nil)
    SVProgressHUD.dismiss()
  }

}
