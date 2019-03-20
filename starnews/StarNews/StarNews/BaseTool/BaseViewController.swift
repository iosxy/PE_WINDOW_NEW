//
//  BaseViewController.swift
//  Yuwan
//
//  Created by 亚鑫柳 on 2017/9/17.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    private var loadingView : UIView!
    private var loadImageView : UIImageView!
    private var loadTextView : UILabel!
    
  override var shouldAutorotate: Bool {
    return true
  }
    var didApperCount = 0 //当前界面出现次数
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  func requestLogin() -> Bool {
    guard YWAPI_NEW.getAuth() != nil else {
      
      return false
    }
    return true
  }
  
  func isLogin() -> Bool {
    return true
    //return YWAPI_NEW.getUserModel()?.id != nil
  }
    func login() -> Void {
//        let vc = RootNavigationController(rootViewController: LoginViewController())
//        Utils.getNavigationController().present(vc, animated: true)
    }
  func enableLogPv() -> Bool {
    return true
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitleBar()
//        loadingView = UIView()
//        loadingView.backgroundColor = HEXCOLOR(0xf2f2f2)
//
//        loadTextView = UILabel()
//        self.statusImageView.snp.makeConstraints { make in
//            make.top.equalTo(80)
//            make.centerX.equalToSuperview()
//            make.height.width.equalTo(200)
//        }
//        self.statusImageView.addSubview(self.statusTextView)
//        self.statusTextView.yw_textColor(value: 0x9D9D9D)
//        self.statusTextView.yw_font(size: 15)
//        self.statusTextView.snp.makeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
      //  self.view.addSubview(loadingView)
        
    }
    func setNormalSetUp() -> Void {
        self.view.backgroundColor = HEXCOLOR(0xF2F2F2)
        self.showTitleBar()
        self.setupBackButton()
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if enableLogPv() {
     
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if enableLogPv() {
    
    }
  }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.didApperCount += 1
        
    }
  private func getViewName() -> String {
    let start = description.index(of: ".")
    if start == nil {
      return description
    }
    let begin = description.index(after: start!)
    let beginStr = description.substring(from: begin)
    let end = beginStr.index(of: ":")
    if end == nil {
      return beginStr
    }
    return beginStr.substring(to: end!)
  }
    
    func showLoadingView(){
        
        
    }
    func showLoadFaildView(){
        
        
    }
    func showLoadEmptyView(){
        
        
    }
    func hideLoadView(){
        
        
    }
}


