//
//  YWBaseTableView.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/12/20.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON
import SnapKit
protocol BaseTableViewDelegate: UITableViewDelegate {

    func loadTableViewData(isLoadMore : Bool , pageNo : Int) -> Promise<Void>
}

class YWBaseTableView: UITableView {
    var pageNo = 1
    var pageSize = 10 //默认分页大小
    weak var loadDataDelegate: BaseTableViewDelegate?
    private let statusImageView = UIImageView()
    private let statusTextView = UILabel()
    var moreFooter : YWRefreshFooter!
    private var refreshHeader: YWRefreshHeader? = nil
    var dataSourceArr : [Any]!
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initTableViewStateViews()
        self.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0.1))
    }
   
    private func initTableViewStateViews() {
        self.dataSourceArr = [Any]()
        refreshHeader = YWRefreshHeader(refreshingBlock: {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refresh()
        })
        
        self.mj_header = refreshHeader
        self.mj_header.endRefreshing()
      moreFooter = YWRefreshFooter(refreshingBlock: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.loadMore()
        })
        self.mj_footer = moreFooter
        self.addSubview(self.statusImageView)
        self.statusImageView.snp.makeConstraints { make in
            make.top.equalTo(80)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableFooterView = UIView.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.statusImageView.addSubview(self.statusTextView)
        self.statusTextView.yw_textColor(value: 0x9D9D9D)
        self.statusTextView.yw_font(size: 15)
        self.statusTextView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        self.backgroundColor = HEXCOLOR(0xF2F2F2)
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = HEXCOLOR(0xF2F2F2)
        self.moreFooter.isHidden = true
    }
    func triggerRefresh() {
        //一般用于初次加载的时候
        self.pageNo = 1
        
        self.refresh()
        
    }
    @objc func refresh(){
        self.pageNo = 1
         if let delegate = self.loadDataDelegate as? BaseTableViewDelegate {
            self.loadDataDelegate?.loadTableViewData(isLoadMore: false, pageNo: self.pageNo).then{ () -> Void in
                self.hideStatusView()
                self.mj_header.endRefreshing()
                if self.dataSourceArr.count == 0 {
                    self.showEmptyView()
                } else if self.dataSourceArr.count < self.pageSize {
                    self.moreFooter.endRefreshingWithNoMoreData()
                    self.moreFooter.state = .noMoreData
                }
                self.reloadData()
                }.catch(execute: { (error) in
                    self.showFailedView()
                })
        }
    }
    
    @objc func loadMore(){
        self.pageNo += 1
        if let delegate = self.loadDataDelegate as? BaseTableViewDelegate {
            self.loadDataDelegate?.loadTableViewData(isLoadMore: true, pageNo: self.pageNo).then{ () -> Void in
                
                self.reloadData()
                }.catch(execute: { (error) in
                    self.dataSourceArr.removeAll()
                    self.reloadData()
                    self.showFailedView()
                })
        }
       
    }
    func judgeLoadMoreStatus(_ count : Int) {
        self.moreFooter.isHidden = false
        
        if count < self.pageSize {
            self.moreFooter.state = .noMoreData
            self.moreFooter.endRefreshingWithNoMoreData()
        }else {
            self.moreFooter.endRefreshing()
        }
    }
    func showLoadingView() {
        statusImageView.isHidden = false
        statusTextView.isHidden = false
        statusImageView.image = UIImage.sd_animatedGIFNamed("loading" + (UIScreen.main.scale > 2 ? "@2x" : "@3x"))
        statusTextView.text = "努力加载中…"
    }
    func showEmptyView() {
        statusImageView.isHidden = false
        statusTextView.isHidden = false
        statusImageView.image = #imageLiteral(resourceName: "empty_list")
        statusTextView.text = ""
    }
    func showFailedView() {
        statusImageView.isHidden = false
        statusTextView.isHidden = false
        statusImageView.image = #imageLiteral(resourceName: "empty_loading")
        statusTextView.text = "加载失败，请检查网络设备"
        if self.mj_header != nil {
            self.mj_header.endRefreshing()
        }
        if self.mj_footer != nil {
            self.moreFooter.endRefreshing()
            self.mj_footer.isHidden = true
        }
        
        
    }
    func hideStatusView() {
        statusImageView.isHidden = true
        statusTextView.isHidden = true
        if self.mj_footer != nil && self.mj_header != nil {
            
            self.mj_header.endRefreshing()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
