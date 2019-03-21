//
//  BaseWebViewController.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/20.
//

import UIKit

class BaseWebViewController: BaseViewController {

    var webView : UIWebView!
    var loadUrl : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView.init()
        self.view.addSubview(webView)
        self.showTitleBar()
        self.setupBackButton()
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kTopHeight)
        }
        if loadUrl == nil {
            return
        }
        webView.loadRequest(URLRequest.init(url: URL.init(string: loadUrl)!))
    }
    
   
   

}
