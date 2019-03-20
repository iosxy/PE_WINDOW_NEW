//
//  YWArtcileDetailViewController.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/6/22.
//  Copyright © 2018年 lqs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import SwiftyJSON
import PromiseKit
import SnapKit
import SVProgressHUD

class YWArticleDetailViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var isStarNews : Bool! = false
    var tableView : YWBaseTableView!
    var pageNo = 1
    var pageSize = 10
    var replayId : String? = nil
    var parentId : String? = nil //用于接受commentView回传的两个ID
    var refreshParentId : String? = nil
    var articleDataSource = [JSON]()
    var articleDetail : JSON!
    var commentDataSource : Array<commentModel>! = Array()
    var commentBarView : YWArticleAddCommentView!
    var maskView : UIView!
    var isNotifationComeIn = false
    var isActivity : Bool! = false
    var shareContentID : String!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.didApperCount > 1 && self.refreshParentId != nil {
            self.reloadSomeOneData(contentId: self.shareContentID, parentId: self.refreshParentId!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        
        self.reloadData()
        
        self.setCommentView()
        
        //        IQKeyboardManager.sharedManager().enable = false
        //        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        //        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        tableView.showLoadingView()
        self.commentBarView.isHidden = true
   
        NotificationCenter.default.addObserver(self, selector: #selector(commentKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(commentKeyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(commentKeyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    func setTableView(){
        tableView = YWBaseTableView.init(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(reloadData))
        tableView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(loadMoreComments))
        tableView.moreFooter.setTitle("一 已显示全部评论 一", for: .noMoreData)
        tableView.moreFooter.stateLabel.backgroundColor = .white
        
        tableView.mj_footer.isHidden = true
        tableView.register(YWArticleDetailImageCell.self, forCellReuseIdentifier: "YWArticleDetailImageCell")
        tableView.register(YWArticleDetailTextCell.self, forCellReuseIdentifier: "YWArticleDetailTextCell")
        tableView.register(YWArticleDetailTitleCell.self, forCellReuseIdentifier: "YWArticleDetailTitleCell")
        tableView.register(YWArticleDetailUserListCell.self, forCellReuseIdentifier: "YWArticleDetailUserListCell")
        tableView.register(YWArticleDetailHeaderTableViewCell.self, forCellReuseIdentifier: "YWArticleDetailHeaderTableViewCell")
        tableView.register(YWArticleDetailCommentTableViewCell.self, forCellReuseIdentifier: "YWArticleDetailCommentTableViewCell")
        tableView.register(YWArticleDetailNoCommentTableViewCell.self, forCellReuseIdentifier: "YWArticleDetailNoCommentTableViewCell")
        tableView.register(YWArticleDetailRankingCell.self, forCellReuseIdentifier: "YWArticleDetailRankingCell")
        tableView.register(YWArticleDetailAboutActivityCell.self, forCellReuseIdentifier: "YWArticleDetailAboutActivityCell")
        tableView.register(YWArticleDetailAboutStarCell.self, forCellReuseIdentifier: "YWArticleDetailAboutStarCell")
       
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kTopHeight)
            make.bottom.equalToSuperview().offset( -49 - bottomSafetyHeight)
        }
        
    }
    @objc func refresh() -> Void {
        
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Utils.cheackIsFirstRunningArticle() {
            //第一次进入此页面
     
        }
        if self.isNotifationComeIn{
            self.refresh()
        }
    }
    func setCommentView(){
        
        commentBarView = YWArticleAddCommentView.init(frame: .zero)
        commentBarView.commentButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addComment)))
        commentBarView.commentIcon.addTarget(self, action: #selector(addComment), for: UIControlEvents.touchUpInside)
        commentBarView.zanIcon.addTarget(self, action: #selector(likeButtonClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(commentBarView)
        commentBarView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(49 + bottomSafetyHeight)
        }
        maskView = UIView()
        maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.55)
        self.view.addSubview(maskView)
        maskView.isHidden = true
        maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func commentKeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            addCommentBottomConstraint?.update(offset: -keyboardSize.height)
            debugPrint("键盘高度为:\(keyboardSize.height)")
        }
        if (notification.name == UIResponder.keyboardWillHideNotification)
        {
            addCommentBottomConstraint?.update(offset: 0)
        }
    }
    
    var addCommentBottomConstraint: Constraint? = nil
    var addCommentView: AddCommentView? = nil
    
    @objc func addComment() {
        if YWAPI_NEW.getAuth() == nil {
            let vc = LoginViewController().inNavigationController()
            self.navigationController?.present(vc, animated: true)
            return
        }
        maskView.isHidden = false
        addCommentView = AddCommentView.loadFromNib()
        addCommentView!.publishButton.addTarget(self, action: #selector(publishComment(_:)), for: .touchUpInside)
        addCommentView!.cancelButton.addTarget(self, action: #selector(cancelComment(_:)), for: .touchUpInside)
        
        YWAPI_NEW.post(YWNETNEW_getCommentMsg).then {[weak self] respone -> Void in
            if self == nil {
                return
            }
            if self!.replayId == nil {
                self!.addCommentView?.contentTextView.text = respone["commentMsg"].stringValue
            }
        }
        self.view.addSubview(addCommentView!)
        addCommentView!.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            addCommentBottomConstraint = make.bottom.equalToSuperview().constraint
            make.height.equalTo(200)
        }
        addCommentView!.contentTextView.becomeFirstResponder()
    }
    
    @objc func cancelComment(_ sender: Any) {
        maskView.isHidden = true
        addCommentView?.removeFromSuperview()
        addCommentView = nil
        self.parentId = nil
        self.replayId = nil
    }
    var isLoadingComments = false
    @objc func publishComment(_ sender: Any) {
        if isLoadingComments {
            return
        }
        
        let contentId = self.shareContentID
        
        let conmmentString = addCommentView!.contentTextView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if conmmentString.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入评论内容")
            return
        }
        if self.parentId == nil &&  conmmentString.count < 10{
            SVProgressHUD.showInfo(withStatus: "评论需要10个字以上哦")
            return
        }
        SVProgressHUD.show(withStatus: "正在提交中...")
        isLoadingComments = true
        YWAPI_NEW.post(YWNETNEW_inserComment, ["contentId": contentId, "comment": conmmentString,"userId":YWAPI_NEW.getUserModel()?.id.stringValue,"parentId":self.parentId == nil ?"":self.parentId,"replyId":self.replayId == nil ? "" : self.replayId]).then {[weak self] response -> Void in
            if (self?.parentId != nil)
            {
                self?.reloadSomeOneData(contentId: contentId!, parentId: (self?.parentId)!)
            }else{
                self?.reloadComments()
                self?.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 1), at: UITableView.ScrollPosition.top, animated: false)
            }
            
            self?.cancelComment(sender)
            
            SVProgressHUD.dismiss()
            
           
            self?.isLoadingComments = false
            }.catch {[weak self] error in
                self?.isLoadingComments = false
                let er = error as NSError
                SVProgressHUD.showError(withStatus: er.domain)
                // SVProgressHUD.showError(withStatus: "")
        }
    }
    
    @objc func reloadData(){
        
        //文章详情接口
        //查询评论数接口
        //评论详情接口
        self.pageNo = 1
        when(fulfilled: [
            YWAPI_NEW.post(YWNETNEW_getContent, ["id":self.shareContentID,"userId":YWAPI_NEW.getUserModel()?.id == nil ? "":YWAPI_NEW.getUserModel()?.id]),
            YWAPI_NEW.post(YWNETNEW_queryOneComment, ["id": self.shareContentID,"userId":YWAPI_NEW.getUserModel()?.id,"pageNo":self.pageNo,"pageSize":10])
            
            ]).then {[weak self] respones -> Void in
                if self == nil {
                    return
                }
                
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.commentBarView.isHidden = false
                self?.tableView.hideStatusView()
                self?.articleDataSource.removeAll()
//                if respones[0]["detail"]["starNews"] != nil {
//                    self?.isStarNews = true
//                }else {
//                    self?.isStarNews = false
//                }
//                self?.isActivity = respones[0]["activity"].boolValue
//                if (self?.isStarNews)! {
//                    self?.articleDataSource = respones[0]["detail"]["starNews"]["articleItems"].arrayValue
//                }else {
//                    self?.articleDataSource = respones[0]["detail"]["article"]["articleItems"].arrayValue
//                }
                self?.articleDataSource = respones[0]["detail"]["article"]["articleItems"].arrayValue
                self?.articleDetail = respones[0]
                self?.articleDataSource.insert(JSON(), at: 0)
                // self?.reloadComments()
                self?.reloadCommentsWithData(respone: respones[1])
                //                let totalCount = respones[1]["total"].int
                //                if self?.pageNo == 1{
                //                    self?.commentDataSource?.removeAll()
                //                    if totalCount == respones[1]["commentList"].arrayValue.count {
                //                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                //                    }else{
                //                        self?.tableView.mj_footer.endRefreshing()
                //                    }
                //                }
                //                self?.commentBarView.loadData(id: respones[1])
                //                self?.tableView.mj_footer.isHidden = totalCount == 0 ? true : false
                //
                //                for (_,item) in respones[1]["commentList"].arrayValue.enumerated()
                //                {
                //                    let model = commentModel.deserialize(from: item.dictionaryObject)
                //                    self?.commentDataSource?.append(model!)
                //                    model?.commentVo.removeAll()
                //                    for (_,subItem) in item["commentVo"].arrayValue.enumerated()
                //                    {
                //                        let submodel = commentModel.deserialize(from: subItem.dictionaryObject)
                //                        model?.commentVo?.append(submodel!)
                //                    }
                //                }
                
                
                self?.tableView.reloadData()
                self?.tableView.mj_header.endRefreshing()
                
            }.catch {[weak self] (error) in
                if self == nil {
                    return
                }
                self!.commentBarView.isHidden = true
                self!.tableView.showFailedView()
                self!.articleDataSource.removeAll()
                self!.commentDataSource?.removeAll()
                self!.articleDetail = nil
                self?.tableView.reloadData()
        }
        
    }
    func reloadComments(){
        self.pageNo = 1
        YWAPI_NEW.post(YWNETNEW_queryOneComment, ["id": self.shareContentID,"userId":YWAPI_NEW.getUserModel()?.id,"pageNo":self.pageNo,"pageSize":10]).then{[weak self] respone -> Void in
            if self == nil {
                return
            }
            self?.reloadCommentsWithData(respone: respone)
        }
        
    }
    
    func reloadCommentsWithData(respone : JSON) {
        let totalCount = respone["total"].int
        if self.pageNo == 1{
            self.commentDataSource?.removeAll()
            if totalCount == respone["commentList"].arrayValue.count {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
        }
        self.commentBarView.loadData(id: respone)
        self.tableView.mj_footer.isHidden = totalCount == 0 ? true : false
        
        for (_,item) in respone["commentList"].arrayValue.enumerated()
        {
            let model = commentModel.deserialize(from: item.dictionaryObject)
            self.commentDataSource?.append(model!)
            model?.commentVo.removeAll()
            for (_,subItem) in item["commentVo"].arrayValue.enumerated()
            {
                let submodel = commentModel.deserialize(from: subItem.dictionaryObject)
                model?.commentVo?.append(submodel!)
            }
        }
        self.tableView.reloadData()
    }
    @objc func loadMoreComments(){
        self.pageNo += 1
        YWAPI_NEW.post(YWNETNEW_queryOneComment, ["id": self.shareContentID,"userId":YWAPI_NEW.getUserModel()?.id,"pageNo":self.pageNo,"pageSize":10]).then {[weak self] respone -> Void in
            if self == nil {
                return
            }
            if (self?.pageNo)! > 20 && !(self?.isActivity)!{
                self?.tableView.moreFooter.setTitle("仅展示最新200条评论哦", for: MJRefreshState.noMoreData)
                self?.tableView.moreFooter.endRefreshingWithNoMoreData()
                return
            }
            for (_,item) in respone["commentList"].arrayValue.enumerated()
            {
                let model = commentModel.deserialize(from: item.dictionaryObject)
                self?.commentDataSource?.append(model!)
                model?.commentVo.removeAll()
                for (_,subItem) in item["commentVo"].arrayValue.enumerated()
                {
                    let submodel = commentModel.deserialize(from: subItem.dictionaryObject)
                    model?.commentVo?.append(submodel!)
                }
            }
            let totalCount = respone["total"].int
            if totalCount == self?.commentDataSource?.count {
                self?.tableView.moreFooter.setTitle("- 没有更多内容了 -", for: MJRefreshState.noMoreData)
                
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else {
                self?.tableView.mj_footer.endRefreshing()
            }
            
            self?.tableView.reloadData()
        }
        
    }
    
    func reloadSomeOneData(contentId:String,parentId:String) -> Void{
        
        self.commentBarView.addCommentCount(1)
        
        YWAPI_NEW.post(YWNETNEW_listCommenByParentId, ["contentId":contentId,"parentId":parentId ,
                                                       "version" : 1 , "userId" : YWAPI_NEW.getUserModel()?.id]).then {[weak self] respone -> Void in
                                                        if self == nil {
                                                            return
                                                        }
                                                        
                                                        var newArr = Array<commentModel>()
                                                        for (_,item) in respone["replyList"].arrayValue.enumerated()
                                                        {
                                                            let model = commentModel.deserialize(from: item.dictionaryObject)
                                                            newArr.append(model!)
                                                        }
                                                        for i in 0..<self!.commentDataSource!.count
                                                        {
                                                            let yuanModel = self!.commentDataSource![i]
                                                            if yuanModel.id! == Int(parentId)!
                                                            {
                                                                yuanModel.twoCommentCount = respone["towCommentCount"].intValue
                                                                yuanModel.commentLike = respone["commentLike"].boolValue
                                                                yuanModel.likeCount = respone["likeCount"].intValue
                                                                yuanModel.commentVo = newArr
                                                                self!.commentDataSource![i] = yuanModel
                                                                self!.tableView.reloadRows(at: [IndexPath.init(row: i+1, section: 1)], with: UITableView.RowAnimation.none)
                                                            }
                                                        }
                                                        self!.replayId = nil
                                                        self!.parentId = nil
                                                        self!.refreshParentId = nil
        }
    }
    
    //    @objc func gotoCommentList(_ sender: Any) {
    //        let commentCount : Int = commentDataSource?.count ?? 0
    //        if commentCount > 0 {
    //            let vc = CommentViewController()
    //            vc.loadParam(self.shareContentID)
    //            Utils.getNavigationController().pushViewController(vc, animated: true)
    //        }
    //    }
    @objc func likeButtonClick()
    {
        if YWAPI_NEW.getAuth() == nil {
            let vc = LoginViewController().inNavigationController()
            self.navigationController?.present(vc, animated: true)
            return
        }
        if !self.commentBarView.zanIcon.isSelected{
            if self.commentBarView.zanCount.text?.count == 0
            {
                self.commentBarView.zanCount.text = "0"
            }
            
            self.commentBarView.zanIcon.isSelected = true
            var likecount = Int((self.commentBarView.zanCount.text)!)
            likecount! += 1
            self.commentBarView.zanCount.text = NSString.init(format: "%d", likecount!) as String
            
            YWAPI_NEW.post(YWNETNEW_addContentLikeCount, ["id":self.shareContentID,"userId":YWAPI_NEW.getUserModel()?.id.stringValue]).then{[weak self] respone -> Void in
                
              
                
                }.catch { (error) in
                    //  SVProgressHUD.showError(withStatus: "点赞" + YW_ERROR_ALERT)
                    
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return articleDataSource.count
        }
        if self.articleDetail == nil {
            return 0
        }
        return (commentDataSource!.count > 0 ? commentDataSource!.count : 1) + 1
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 && indexPath.section == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailTitleCell") as! YWArticleDetailTitleCell
                cell.loadItem(item: self.articleDetail)
                return cell
            }
            
            if articleDataSource[indexPath.row]["type"] == "RANKING" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailRankingCell") as! YWArticleDetailRankingCell
                cell.loadItem(item: articleDataSource[indexPath.row])
                return cell
            }
            if articleDataSource[indexPath.row]["type"] == "IMAGE" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailImageCell") as! YWArticleDetailImageCell
                cell.loadItem(item: articleDataSource[indexPath.row])
                return cell
            }
            
            if articleDataSource[indexPath.row]["type"] == "ACTIVITY_LIST" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailAboutActivityCell") as! YWArticleDetailAboutActivityCell
                cell.loadItem(item: self.isStarNews ? self.articleDetail["detail"]["starNews"]["activityRelevant"] : self.articleDetail["detail"]["article"]["activityRelevant"])
                return cell
            }
            if articleDataSource[indexPath.row]["type"] == "PRODUCT_LIST" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailAboutActivityCell") as! YWArticleDetailAboutActivityCell
                cell.loadItem(item: self.isStarNews ? self.articleDetail["detail"]["starNews"]["productRelevant"] : self.articleDetail["detail"]["article"]["productRelevant"])
                return cell
            }
            if articleDataSource[indexPath.row]["type"] == "STAR_LIST" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailAboutStarCell") as! YWArticleDetailAboutStarCell
                cell.loadItem(item: self.isStarNews ? self.articleDetail["detail"]["starNews"]["starRelevant"] : self.articleDetail["detail"]["article"]["starRelevant"])
                return cell
            }
            
            if articleDataSource[indexPath.row]["type"] == "TEXT" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailTextCell") as! YWArticleDetailTextCell
                cell.loadItem(item: articleDataSource[indexPath.row])
                return cell
                
            }
            if articleDataSource[indexPath.row]["type"] == "PRIZE_LIST" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailUserListCell") as! YWArticleDetailUserListCell
                cell.loadItem(item: articleDataSource[indexPath.row])
                return cell
            }
            
        }else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailHeaderTableViewCell", for: indexPath) as! YWArticleDetailHeaderTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
                
            }else {
                let commentCount : Int = commentDataSource?.count ?? 0
                if commentCount > 0 {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailCommentTableViewCell", for: indexPath) as! YWArticleDetailCommentTableViewCell
                    
                    let model = commentDataSource![indexPath.row - 1]
                    cell.detailView.commentTapBlock = {[weak self ](replayId:String,paraentId:String,userName:String?) ->Void in
                        self?.addComment()
                        self?.parentId = paraentId
                        self?.replayId = replayId
                        self?.addCommentView?.contentTextView.text = "回复" + userName! + ":"
                        //                        //回复评论
                    }
                    cell.detailView.commentRefreshBlock = {[weak self ](replayId:String,paraentId:String,userName:String?) ->Void in
                        
                        self?.refreshParentId = paraentId
                    }
                    cell.detailView.loadData(model:model)
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell
                } else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "YWArticleDetailNoCommentTableViewCell", for: indexPath) as! YWArticleDetailNoCommentTableViewCell
                    
                    cell.detailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addComment)))
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell
                }
                
            }
            return UITableViewCell()
        }
        
        return UITableViewCell()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
