//
//  AvatarViewController.swift
//  Yuwan
//
//  Created by lqs on 2017/6/21.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit

class AvatarViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        avatarImageView.yw_setImage(with: YWAPI_NEW.getUserInfo()!["avatar"].url)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func change(_ sender: Any) {
        let alert = UIAlertController(title: "更换头像", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: {[weak self] (alertAction) in
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.allowsEditing = true
            camera.delegate = self
            self?.navigationController?.present(camera, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "从相册选择", style: .default, handler: {[weak self] (alertAction) in
            let camera = UIImagePickerController()
            camera.sourceType = .photoLibrary
            camera.allowsEditing = true
            camera.delegate = self
            self?.navigationController?.present(camera, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (alertAction) in
            
        }))
        self.navigationController?.present(alert, animated: true)
    }
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        avatarImageView.image = image
        picker.dismiss(animated: true)
        
      //  let jpeg = UIImageJPEGRepresentation(image!, 0.8)!
        
        let jpg = UIImage.jpegData(image!)
       
        YWAPI_NEW.upload(YWNETNEW_upload, "file", jpg(0.8)!).then { response in
           
//            YWAPI.post(YWNET_updateAvatar, ["avatar": response]).then { response -> Void in
//              //  let auth = YWAPI.getAuth()!
//               // YWAPI.fetchUserInfo(auth)
//              //  self.navigationController?.popViewController(animated: true)
//            }
            
            self.updateUserAvantar(url: response.stringValue)
        }
        
    }

    func updateUserAvantar(url : String){
        let userBean = YWAPI_NEW.getUserModel()
        userBean?.avatar = url
        
        YWAPI_NEW.post(YWNETNEW_updateUserInfo, ["userId" : YWAPI_NEW.getUserModel()?.id , "type" : "3" , "value" : url]).then {[weak self] respone -> Void in
            if self == nil {
                return
            }
            YWAPI_NEW.updateUserInfo(userInfo : (userBean?.covertToJsonString())!)
            
            self!.navigationController?.popViewController(animated: true)
            
        }
    }
    
}
