//
//  ClanderViewController.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/19.
//

import UIKit
import SwiftyJSON
import PromiseKit
class ClanderViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource, BaseTableViewDelegate {
    private let tableView = YWBaseTableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTitleBar()
        self.title = "明星行程"
        
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = HEXCOLOR(0xF2F2F2)
        self.tableView.separatorStyle = .none
        
        self.tableView.rowHeight = 94
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.loadDataDelegate = self
        self.tableView.showLoadingView()
        self.tableView.triggerRefresh()
        self.tableView.register(YWClanderListTableViewCell.self, forCellReuseIdentifier: "YWClanderListTableViewCell")
        self.tableView.snp.remakeConstraints { make in
            make.top.equalTo(kTopHeight)
            make.left.bottom.width.equalToSuperview()
        }
        
        
        
        
        
        
    }
    
    func loadTableViewData(isLoadMore: Bool, pageNo: Int) -> Promise<Void> {
        return Promise { fulfill, reject in
            
            YWAPI_NEW.post(YWNETNEW_listCalendar, ["type" : 0 , "pageNo" : self.tableView.pageNo , "pageSize" : 10]).then{ respone -> Void in
                if self == nil {
                    return
                }
                if !isLoadMore {
                    self.tableView.dataSourceArr.removeAll()
                }
                for item in respone["catchList"]["list"].arrayValue {
                    self.tableView.dataSourceArr.append(item)
                }
                self.tableView.moreFooter.isHidden = false
                self.tableView.moreFooter.endRefreshing()
                if respone["catchList"]["list"].count < self.tableView.pageSize {
                    self.tableView.dataSourceArr.append(JSON())
                    self.tableView.moreFooter.isHidden = true
                }
                
                fulfill(Void())
                }.catch(execute: { (error) in
                    reject(error)
                })
        }
    }

 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.tableView.dataSourceArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let item = self.tableView.dataSourceArr[section] as! JSON
        if item["id"].int == nil {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = self.tableView.dataSourceArr[section] as! JSON
        let contenView = UIView()
        let headerView = YWClanderListHeaderView.init(frame: .zero)
        contenView.addSubview(headerView)
        headerView.loadItem(item: item, section: section)
        headerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return contenView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YWClanderListTableViewCell", for: indexPath) as! YWClanderListTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let item = self.tableView.dataSourceArr[indexPath.section] as! JSON
        cell.clanderView.loadItem(item: item)
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        //跳转到行程详情
//        
//        
//        
//    }
    

}
