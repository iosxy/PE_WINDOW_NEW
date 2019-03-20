//
//  MineHeadView.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/20.
//

import UIKit

class MineHeadView: UIView {

    var avatarImageView : UIImageView!
    var nickLabel : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
      
        let headerView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 174))
        headerView.image = UIImage.init(named: "nav_backgrd")
        headerView.isUserInteractionEnabled = true
        avatarImageView = UIImageView.init(image: #imageLiteral(resourceName: "default_avatar"))
        headerView.addSubview(avatarImageView)
        nickLabel = UILabel()
        nickLabel.yw_textColor(value: 0xffffff)
        nickLabel.yw_font(size: 18)
        nickLabel.text = "登录/注册"
        nickLabel.isUserInteractionEnabled = true
        headerView.addSubview(nickLabel)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(12)
            make.width.height.equalTo(78)
        }
     
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.clip(corner: 39)
        nickLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(14)
        }

        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatar(sender:))))
        nickLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(name(sender:))))
          self.addSubview(headerView)
        setupUserInfo()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onUserInfoChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "YuwanUserInfoChanged"),
                                               object: nil)
    }
    @objc func onUserInfoChanged(notification: Notification) {
       
        
        setupUserInfo()
    }
    func setupUserInfo(){
        
        if YWAPI_NEW.getUserModel()?.id != nil {
            let userModel = YWAPI_NEW.getUserModel()
            nickLabel.text = userModel?.nick
            avatarImageView.yw_setImageWithUrlStr(with: userModel?.avatar)
        }else {
            
            nickLabel.text = "登录/注册"
            avatarImageView.image = #imageLiteral(resourceName: "default_avatar")
        }
      
    }
    @objc func avatar(sender: Any)
    {

        if YWAPI_NEW.getUserModel()?.id != nil {
            //修改头像
            let vc = AvatarViewController()
            Utils.getNavigationController().pushViewController(vc, animated: true)
        }else {
            let navigationController = RootNavigationController(rootViewController: LoginViewController())
            Utils.getNavigationController().present(navigationController, animated: true)
        }
       
    }
    @objc func name(sender: Any) {
        if YWAPI_NEW.getUserModel()?.id != nil {
            //修改昵称
            let vc = NickViewController()
            Utils.getNavigationController().pushViewController(vc, animated: true)
        }else {
            let navigationController = RootNavigationController(rootViewController: LoginViewController())
            Utils.getNavigationController().present(navigationController, animated: true)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
