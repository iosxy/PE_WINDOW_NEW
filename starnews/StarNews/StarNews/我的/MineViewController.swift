//
//  MineViewController.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/19.
//

import UIKit

class MineViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView : UITableView!
    var cellName : [String]!
    var canPush = false
    var headView : MineHeadView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTitleBar()
        self.title = "我的"
        cellName = ["推送通知" , "清除缓存" , "免责声明" , "隐私政策" , "联系客服" , "退出登录"]
        tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kTopHeight)
            
        }
        headView = MineHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200))
        tableView.tableHeaderView = headView
        tableView.register(moreSettingCell.self, forCellReuseIdentifier: "moreSettingCell")
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        headView.setupUserInfo()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreSettingCell", for: indexPath) as! moreSettingCell
        if indexPath.row == 0 {
            cell.setup(title: cellName[indexPath.row], switchStatus: self.canPush, rightText: "", showBottom: false)
            cell.rightSwitch.addTarget(self, action: #selector(puchange(button:)), for: UIControl.Event.valueChanged)
        }else if indexPath.row == 1 {
            cell.setup(title: cellName[indexPath.row], switchStatus: nil, rightText: getCacheSizeStr(), showBottom: false)
        }else {
            cell.setup(title: cellName[indexPath.row], switchStatus: nil, rightText: "", showBottom: true)
        }
   
        return cell
        
    }
    @objc func puchange(button : UISwitch) {
        self.canPush = button.isOn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let cache = SDImageCache.shared()!
            cache.clearMemory()
            cache.clearDisk(onCompletion: {
                //     cell.rightLabel.text = self.getCacheSizeStr()
                self.tableView.reloadData()
            })
        }else if indexPath.row == 2 {
            
            let web = BaseWebViewController()
            web.loadUrl = YW_URL_SHARE +  "/disclaimer.html"
            Utils.getNavigationController().pushViewController(web, animated: true)
        }else if indexPath.row == 3 {
            
            let web = BaseWebViewController()
            web.loadUrl = YW_URL_SHARE +  "/privacy.html"
            Utils.getNavigationController().pushViewController(web, animated: true)
        }else if indexPath.row == 4 {
            let vc = ConnectUsViewController()
            Utils.getNavigationController().pushViewController(vc, animated: true)
        }else if indexPath.row == 5 {
            
            //退出登录
            YWAPI_NEW.clearAuth()
            YWAPI_NEW.clearAuth()
        }
        
        
        
    }
    func getCacheSizeStr() -> String {
        let size = SDImageCache.shared().getSize()
        if (size < 1000) {
            return String(format: "%dB", size)
        } else if (size < 1000 * 1000) {
            return String(format: "%.1fK", Double(size) / 1000)
        } else {
            return String(format: "%.1fM", Double(size) / 1000 / 1000)
        }
    }
    


}
