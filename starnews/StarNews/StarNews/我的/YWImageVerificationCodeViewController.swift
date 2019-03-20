//
//  YWImageVerificationCodeViewController.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/7/27.
//  Copyright © 2018年 lqs. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import SVProgressHUD

class YWImageVerificationCodeViewController: BaseViewController {
    private weak var superVC: BaseViewController?
    var onDismiss: (() -> Void)?
    var onDone: (() -> Void)?
    var backView = UIView()
    var titleLabel = UILabel()
    var inputTextFild = UITextField()
    var imageCodeView = UIButton()
    var changeButton = UIButton()
    var doneButton = UIButton()
    var closeButton = UIButton()
    var telephone : String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.clip(corner: 12)
        backView.backgroundColor = .white
        titleLabel.text = "请输入图形验证码"
        titleLabel.yw_font(size: 16)
        titleLabel.yw_textColor(value: 0x212121)
        closeButton.setImage(#imageLiteral(resourceName: "code_icon_cancel"), for: UIControl.State.normal)
        closeButton.addTarget(self, action: #selector(cancel), for: UIControl.Event.touchUpInside)
        inputTextFild.clip(corner: 6, lineWidth: 1, lineColor: HEXCOLOR(0x9d9d9d))
        inputTextFild.keyboardType = UIKeyboardType.asciiCapable
        inputTextFild.becomeFirstResponder()
        changeButton.setTitle("看不清?换一张", for: UIControl.State.normal)
        changeButton.setTitleColor(HEXCOLOR(0x9d9d9d), for: UIControl.State.normal)
        changeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        changeButton.addTarget(self, action: #selector(changeImageCode), for: UIControl.Event.touchUpInside)
        doneButton.setImage(#imageLiteral(resourceName: "code_icon_gain"), for: UIControl.State.normal)
        doneButton.adjustsImageWhenHighlighted = false
        doneButton.addTarget(self, action: #selector(done), for: UIControl.Event.touchUpInside)
        imageCodeView.setBackgroundImage(#imageLiteral(resourceName: "image_placeholder"), for: UIControl.State.normal)
        imageCodeView.adjustsImageWhenHighlighted = false
        imageCodeView.addTarget(self, action: #selector(changeImageCode), for: UIControl.Event.touchUpInside)
  
        self.view.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(inputTextFild)
        backView.addSubview(changeButton)
        backView.addSubview(imageCodeView)
        backView.addSubview(doneButton)
        backView.addSubview(closeButton)
        
        
        backView.snp.makeConstraints { (make) in
           make.bottom.equalToSuperview()
            make.width.equalTo(315)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.height.width.equalTo(26)
        }
        
        inputTextFild.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(48)
        }
        imageCodeView.snp.makeConstraints { (make) in
            make.width.equalTo(110)
            make.height.equalTo(48)
            make.top.equalTo(inputTextFild.snp.top)
            make.right.equalToSuperview().offset(-20)
        }
        changeButton.snp.makeConstraints { (make) in
            make.width.equalTo(110)
            make.height.equalTo(35)
            make.top.equalTo(imageCodeView.snp.bottom)
            make.right.equalToSuperview().offset(-20)
        }

        doneButton.snp.makeConstraints { (make) in
            make.width.equalTo(275)
            make.height.equalTo(42)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }

     @objc private func done() {
        
        if self.onDone != nil {
            if !self.isImageCode(code:self.inputTextFild.text){
                SVProgressHUD.showError(withStatus: "验证码错误")
                self.changeImageCode()
                return
            }
            self.getSIMCode()
            
        }else {
            self.dismiss(animated: true) {
               
            }
        }
        
    }
    @objc private func changeImageCode() {

        YWAPI_NEW.post(YWNETNEW_getImg, ["telephone":self.telephone]).then {[weak self] respone -> Void in
            if self == nil {
                return
            }
            let imageStr = respone["img"].stringValue
            let image = UIImage.init(data: GTMBase64.decode(imageStr)!)
            self?.imageCodeView.setBackgroundImage(image, for: UIControl.State.normal)
            
            }.catch { (error) in
               
        }

    }
    func getSIMCode(){
        SVProgressHUD.show(withStatus: nil)
        YWAPI_NEW.post(YWNETNEW_generateVerifyCode, ["telephone":self.telephone,"cerificationCode":self.inputTextFild.text!]).then {[weak self]respone ->Void in
            
            
            self?.view.endEditing(true)
            SVProgressHUD.dismiss()
            self?.dismiss(animated: true) {
                if self?.onDone != nil {
                    self?.onDone!()
                }
            }
            }.catch { (error) in
                self.changeImageCode()
                let nserror = error as? NSError
                
                SVProgressHUD.showError(withStatus: nserror?.domain)
        }
        
    }
    
    @objc private func cancel() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: { [weak self] in
            if self?.onDismiss != nil {
                 self?.onDismiss?()
            }
        })
    }
    
    func show(parent: BaseViewController) {
        self.superVC = parent
        
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: self)
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = false
        formSheetController.contentViewCornerRadius = 0
        formSheetController.presentationController?.blurEffectStyle = .dark
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.contentViewSize = CGSize(width: 315, height: 250)
        formSheetController.contentViewControllerTransitionStyle = .fade
        parent.present(formSheetController, animated: true, completion: nil)
        self.changeImageCode()
    }
}
