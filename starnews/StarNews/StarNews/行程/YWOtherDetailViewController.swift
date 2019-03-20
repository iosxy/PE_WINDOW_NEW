//
//  MovieViewController.swift
//  Yuwan
//
//  Created by lqs on 2017/7/12.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import SVProgressHUD
import HandyJSON
import MJRefresh
protocol Shareable {
    func share()
    
    func getContentId() -> String
}


class YWOtherDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var detailView: UIView? = nil
    let noMoreView = UIView()
    var replayId : String? = nil
    var parentId : String? = nil //用于接受commentView回传的两个ID
    var pageNo = 1
    var jumpCommentId : String? = nil
    var sectionCount = 0
    var isNotifationComeIn = false
    var tableView: YWBaseTableView!
    var shareContentID : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = YWBaseTableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kTopHeight)
        }
//        if let movieDetailView = detailView as? MovieDetailView {
//            // hack...
//            movieDetailView.tableView = tableView
//        }

        
        self.tableView.register(YWArticleDetailTableViewCell.self, forCellReuseIdentifier: "YWArticleDetailTableViewCell")
        self.tableView.reloadData()
        
        if self.detailView as? MovieDetailView != nil {
            self.tableView.showLoadingView()
            let view = detailView as! MovieDetailView
            view.viewDidLoad = {[weak self] result -> Void in

                if result! {
                    self?.tableView.hideStatusView()
                    self?.tableView.reloadData()
                }else{
                    self?.tableView.showFailedView()
                    self?.tableView.reloadData()
                }
            }
        }
    }

  @objc func popToPresentVC() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailTableViewCell", for: indexPath) as! YWArticleDetailTableViewCell
        if cell.detailView == detailView {
            return cell
        }
        cell.updateDetailView(view : detailView)
        return cell
    }


}
