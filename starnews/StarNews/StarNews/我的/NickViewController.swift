//
//  NickViewController.swift
//  Yuwan
//
//  Created by lqs on 2017/6/21.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SVProgressHUD

class NickViewController: BaseViewController {
 
    var inputTextView : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNormalSetUp()
        self.title = "昵称"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItem.Style.done, target: self, action: #selector(save(_:)))
        
        inputTextView = UITextField()
        inputTextView.text = YWAPI_NEW.getUserInfo()!["nick"].stringValue
        inputTextView.textColor = HEXCOLOR(0x9d9d9d)
        inputTextView.font = UIFont.systemFont(ofSize: 16)
        inputTextView.backgroundColor = .white
        inputTextView.clearButtonMode =  UITextField.ViewMode.always
        inputTextView.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 46))
        inputTextView.leftViewMode = UITextField.ViewMode.always

        self.view.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(46)
            make.top.equalToSuperview().offset(kTopHeight + 22)
        }
        
    }

    @objc func save(_ sender: Any) {
       
        var text = inputTextView.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        
        
        if (text?.count)! < 1 || (text?.count)! > 10 {
            SVProgressHUD.showInfo(withStatus: "昵称长度为1-10个字")
            return
        }
        
        SVProgressHUD.show(withStatus: "正在保存中...")

       let userBean = YWAPI_NEW.getUserModel()
       userBean?.nick = inputTextView.text
       
        YWAPI_NEW.post(YWNETNEW_updateUserInfo, ["userId" : YWAPI_NEW.getUserModel()?.id , "type" : "2" , "value" : text]).then {[weak self] respone -> Void in
            if self == nil {
                return
            }
            SVProgressHUD.showSuccess(withStatus: "保存成功")
       //     YWAPI.updateUserInfo(userInfo : (userBean?.covertToJsonString())!)
            
            self!.navigationController?.popViewController(animated: true)
            }.catch { (error) in
                let nserror = error as NSError
                SVProgressHUD.showInfo(withStatus: nserror.domain)
        }
        
        
//        YWAPI_NEW.post(YWNETNEW_updateUserName, ["userName": nickField.text!,"userId" : YWAPI_NEW.getUserModel()?.id]).then { data in
//            return YWAPI.fetchUserInfo(auth)
//        }.then { userInfo -> Void in
//            SVProgressHUD.dismiss()
//            YWAPI.setAuth(auth, userInfo)
//            self.navigationController?.popViewController(animated: true)
//        }.catch { error in
//            SVProgressHUD.showInfo(withStatus: "保存失败，请稍后重试")
//        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
