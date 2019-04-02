//
//  RooTableViewController.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/23.
//

import UIKit

class RooTableViewController: UIViewController {
    var webView : UIWebView!
    var loadUrl : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView.init()
        self.view.addSubview(webView)
       
        self.setupBackButton()
        webView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
            
        }
        if loadUrl == nil {
            return
        }
        webView.loadRequest(URLRequest.init(url: URL.init(string: loadUrl)!))
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
