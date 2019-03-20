//
//  ConnectUsViewController.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/20.
//

import UIKit

class ConnectUsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       let label = UILabel()
        label.text = "官方客户服务邮箱:870465330@qq.com ,欢迎随时来邮件资讯  "
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            
        }
        
    }
    

   

}
