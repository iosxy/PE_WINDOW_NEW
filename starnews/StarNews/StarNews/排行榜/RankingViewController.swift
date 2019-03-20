//
//  RankingViewController.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/19.
//

import UIKit
import SwiftyJSON
import PromiseKit
import SVProgressHUD

public enum YWRankingDataSourceType : Int {
    case star_week = 0
    case star_month
    case star_total
    case movie_week
    case movie_month
    case movie_total
    case activity_week
    case activity_month
    case activity_total
}
class RankingViewController: BaseViewController ,UICollectionViewDataSource ,BaseCollectionViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var collectionView : YWBaseCollectionView!
    var dataSourceType : YWRankingDataSourceType?
    override func viewDidLoad() {
        self.showTitleBar()
        title = "作品热度排行榜"
        self.tabBarItem.title = "排行"
        self.dataSourceType = YWRankingDataSourceType(rawValue: 3)
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: kScreenWidth, height: 119)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = YWBaseCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(YWRankkingListProductCollectionViewCell.self, forCellWithReuseIdentifier: "YWRankkingListProductCollectionViewCell")
    
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.loadDataDelegate = self
        collectionView.showLoadingView()
        collectionView.triggerRefresh()
        collectionView.pageSize = 51
       
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kTopHeight)
        }
        //
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.triggerRefresh()
    }
    
    
    func loadCollectionViewData(isLoadMore: Bool, pageNo: Int) -> Promise<Void> {
        
        return Promise {[weak self] fulfill , reject in
            
            YWAPI_NEW.post(YWNETNEW_getRankingList, ["type":"OPUS","pageNo":pageNo,"pageSize":50 , "orderType" : (self?.dataSourceType!.rawValue)! - 3 + 1 , "userId" : ""]).then {[weak self] respone -> Void in
                if self == nil {
                    return
                }
                if pageNo == 1 {
                    self?.collectionView.dataSourceArr.removeAll()
                }
                for item in respone["rankingList"]["list"].arrayValue {
                    self?.collectionView.dataSourceArr.append(item)
                }
                self?.collectionView.judgeLoadMoreStatus(respone["rankingList"]["list"].count)
                fulfill(Void())
                }.catch { (er) in
                    reject(er)
            }
            
        }
        
    }
    
    
    var addLabel : UILabel?
    @objc func contribute(button : UIButton) {
//        if !self.isLogin() {
//            self.login()
//            return
//        }
//        let confirmVc = YWRankContributeConfirmView()
//        confirmVc.show(parent: self, completion: {
//        })
//        let item = self.collectionView.dataSourceArr[button.tag] as! JSON
//        confirmVc.setConfirmData(id: item["rankingId"].stringValue, name: "", type: "3")
//        confirmVc.onDismiss = {[weak self] status -> Void in
//            if status {
//
//                let cell = self?.collectionView.cellForItem(at: IndexPath.init(row: button.tag, section: 0)) as! YWRankkingListProductCollectionViewCell
//                self?.collectionView.triggerRefresh()
//                cell.showAddNumberAnimation {
//
//                }
//
//            }
//        }
    }
    
   
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        switch self.dataSourceType?.rawValue {
//        case 3:
//            return CGSize.init(width: kScreenWidth, height: 88)
//        case 4:
//            return CGSize.init(width: kScreenWidth, height: 88)
//        case 5:
//            return CGSize.init(width: kScreenWidth, height: 88)
//        default:
//            return CGSize.init(width: kScreenWidth, height: 107)
//        }
//
//    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.dataSourceArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YWRankkingListProductCollectionViewCell", for: indexPath) as! YWRankkingListProductCollectionViewCell
        cell.loadData(data : self.collectionView.dataSourceArr[indexPath.row] as! JSON  ,row : indexPath.row ,dataType : self.dataSourceType!)
        cell.contributeButton.tag = indexPath.row
//        cell.contributeButton.addTarget(self, action: #selector(contribute(button:)), for: UIControlEvents.touchUpInside)
        return cell
        
    }
}

class YWRankkingListProductCollectionViewCell: UICollectionViewCell {
    
    var headImageView : UIImageView!
    var nameLabel : UILabel!
    var directorLabel : UILabel!
    var directorNameLabel : UILabel!
    var starringLabel : UILabel!
    var premiereLabel : UILabel!
    var progressView : YWRankProgressView!
    var hotView : UIImageView!
    var hotLabel : UILabel!
    var rankView : UIImageView!
    var timeLabel : UILabel!
    var data : JSON!
    var contributeButton : UIButton!
    var elseRankView : UIButton!
    var searchRankLabel : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        
        headImageView = UIImageView()
        
        rankView = UIImageView()
        rankView.image = #imageLiteral(resourceName: "rank_icon_gold2")
        headImageView.contentMode = UIView.ContentMode.scaleAspectFill
        headImageView.clip(corner: 0)
        nameLabel = UILabel()
        nameLabel.text = "标题标题"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.yw_textColor(value: 0x212121)
        
        
        directorLabel = UILabel()
        directorLabel.yw_font(size: 14)
        directorLabel.yw_textColor(value: 0x737373)
        directorLabel.text = "本周热度"
        
        directorNameLabel = UILabel()
        directorNameLabel.yw_font(size: 14)
        directorNameLabel.yw_textColor(value: 0x0f0f0f)
        directorNameLabel.text = ""
        
        starringLabel = UILabel()
        starringLabel.yw_font(size: 14)
        starringLabel.yw_textColor(value: 0x737373)
        starringLabel.text = "主演："
        
        
        premiereLabel = UILabel()
        premiereLabel.yw_font(size: 14)
        premiereLabel.yw_textColor(value: 0x737373)
        premiereLabel.text = "我本周贡献热度："
        
        
        hotView = UIImageView()
        hotView.image = #imageLiteral(resourceName: "rank_icon_hot")
        
        hotLabel = UILabel()
        hotLabel.yw_font(size: 14)
        hotLabel.yw_textColor(value: 0x212121)
        hotLabel.text = "10万"
        
        timeLabel = UILabel()
        timeLabel.text = "10"
        timeLabel.yw_font(size: 14)
        timeLabel.yw_textColor(value: 0x0f0f0f)
        
        progressView = YWRankProgressView.init(frame: CGRect.zero)
        
        contributeButton = UIButton()
//        contributeButton.setBackgroundImage(#imageLiteral(resourceName: "rank_button_hot"), for: UIControl.State.normal)
//        contributeButton.setBackgroundImage(#imageLiteral(resourceName: "rank_button_hot_pre"), for: UIControl.State.disabled)
//
        elseRankView  = UIButton()
        elseRankView.setBackgroundImage(#imageLiteral(resourceName: "top_icon_else"), for: UIControl.State.normal)
        elseRankView.setTitleColor(HEXCOLOR(0x9d9d9d), for: UIControl.State.normal)
        elseRankView.titleLabel?.yw_font(size: 12)
        let bottomLine = UIView()
        bottomLine.backgroundColor = HEXCOLOR(0xf2f2f2)
        
        searchRankLabel = UILabel()
        searchRankLabel.isHidden = true
        searchRankLabel.yw_font(size: 13)
        
        self.contentView.addSubview(headImageView)
        self.contentView.addSubview(rankView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(directorLabel)
        self.contentView.addSubview(directorNameLabel)
        self.contentView.addSubview(starringLabel)
        self.contentView.addSubview(premiereLabel)
        
        self.contentView.addSubview(hotView)
        self.contentView.addSubview(hotLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(progressView)
        self.contentView.addSubview(contributeButton)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(elseRankView)
        self.contentView.addSubview(searchRankLabel)
        rankView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(8)
            make.width.equalTo(20)
            make.height.equalTo(24)
        }
        
        headImageView.snp.makeConstraints { (make) in
            make.width.equalTo(67 * yw_scale)
            make.height.equalTo(94)
            make.centerY.equalToSuperview()
            make.leftMargin.equalTo(12)
        }
        
        hotView.isHidden =  true
        hotView.snp.makeConstraints { (make) in
            
            make.left.equalTo(directorLabel.snp.right).offset(4)
            make.bottom.equalTo(directorLabel)
            make.width.height.equalTo(14)
            
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.top.equalTo(headImageView)
            make.height.equalTo(16)
        }
        
        
        
        starringLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.left.equalTo(nameLabel)
            make.height.equalTo(14)
        }
        
        
        premiereLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(headImageView)
            make.left.equalTo(nameLabel)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(premiereLabel.snp.right)
            make.bottom.equalTo(premiereLabel)
        }
        
        directorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(starringLabel.snp.bottom).offset(10)
            make.left.equalTo(nameLabel)
            make.height.equalTo(14)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(directorLabel.snp.right).offset(6)
            make.centerY.equalTo(directorLabel)
            make.width.equalTo(110 * yw_scale)
            make.height.equalTo(8)
        }
        hotLabel.snp.makeConstraints { (make) in
            make.left.equalTo(progressView.snp.right).offset(4)
            make.centerY.equalTo(progressView.snp.centerY)
        }
        contributeButton.snp.makeConstraints { (make) in
            make.width.equalTo(71)
            make.height.equalTo(26)
            make.rightMargin.equalTo(-12)
            make.bottomMargin.equalTo(-9)
        }
        elseRankView.isHidden = true
        elseRankView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.top.equalTo(6)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leftMargin.equalTo(12)
            make.rightMargin.equalTo(-12)
            make.height.equalTo(0.5)
        }
        searchRankLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.rightMargin.equalTo(-12)
        }
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tap(){
        
        
        YWAPI_NEW.post(YWNETNEW_getContent, ["id":self.data["id"].stringValue,"userId":""]).then {[weak self] respone -> Void in
            if self == nil {
                return
            }
            let vc = YWOtherDetailViewController()
            vc.shareContentID = (self?.data["id"].stringValue)!
            let detailView = MovieDetailView.loadFromNib()
            vc.detailView = detailView
            detailView.loadItem(respone)
            Utils.getNavigationController().pushViewController(vc, animated: true)
        }
        
        
        
        
    }
    
    func loadSearchData(data : JSON) {
        self.data = data
        hotLabel.text = data["realWeekRankingListNumber"].stringValue
        contributeButton.isEnabled = !data["status"].boolValue
        headImageView.yw_setImageWithUrlStr(with: data["cover"].stringValue, w: "148", h: "148")
        nameLabel.text = data["title"].stringValue
        //timeLabel.text = data["publishTimeStr"].stringValue
        starringLabel.text = "主演: " + data["majorStar"].stringValue
        timeLabel.text = data["userAddNumber"].stringValue
        if timeLabel.text == "0" {
            timeLabel.yw_textColor(value: 0x9d9d9d)
        }else {
            timeLabel.yw_textColor(value: 0x212121)
        }
        elseRankView.isHidden = true
        hotLabel.yw_textColor(value: 0x212121)
        rankView.isHidden = true
        progressView.isHidden = true
        hotView.isHidden = false
        rankView.isHidden = true
        hotLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(directorLabel)
            make.left.equalTo(hotView.snp.right).offset(4)
        }
        searchRankLabel.isHidden = false
        
        var searchTitle = ""
        if data["rank"].intValue > 50 {
            searchTitle = "本周未上榜"
           searchRankLabel.text = searchTitle
        }else {
            searchTitle = "本周排名：" + String(data["rank"].intValue)
            
            searchRankLabel.text = searchTitle
        }
    }
    
    
    func loadData(data : JSON , row : Int, dataType : YWRankingDataSourceType){
        
        self.data = data
        contributeButton.isEnabled = !data["status"].boolValue
        headImageView.yw_setImageWithUrlStr(with: data["cover"].stringValue, w: "148", h: "148")
        nameLabel.text = data["title"].stringValue
        hotLabel.text = Utils.shortNumberString(data["number"].numberValue)
        //timeLabel.text = data["publishTimeStr"].stringValue
        starringLabel.text = "主演: " + data["majorStar"].stringValue
        timeLabel.text = data["userAddNumber"].stringValue
        if timeLabel.text == "0" {
            timeLabel.yw_textColor(value: 0x9d9d9d)
        }else {
            timeLabel.yw_textColor(value: 0x212121)
        }
        progressView.setProgressData(rank: row, multiply: data["percentage"].doubleValue / 100.00)
        
        switch dataType {
        case .movie_week:
            directorLabel.text = "本周热度"
            hotLabel.text = data["realWeekRankingListNumber"].stringValue
            premiereLabel.text = "我本周贡献热度: "
            
            break
            
        case .movie_month:
            directorLabel.text = "本月热度"
            hotLabel.text = data["realMonthRankingListNumber"].stringValue
            premiereLabel.text = "我本月贡献热度: "
            contributeButton.isHidden = true
            break
        case .movie_total:
            directorLabel.text = "热度"
            premiereLabel.text = "我贡献过热度: "
            hotLabel.text = data["realRankingListNumber"].stringValue
            contributeButton.isHidden = true
            break
        default: break
            
        }
        
        switch row {
        case 0:
            self.resateViewState()
            rankView.image = #imageLiteral(resourceName: "rank_icon_gold2")
            hotLabel.yw_textColor(value: 0xff147d)
            break;
        case 1:
            self.resateViewState()
            rankView.image = #imageLiteral(resourceName: "rank_icon_silver2")
            hotLabel.yw_textColor(value: 0xff9800)
            break;
        case 2:
            self.resateViewState()
            rankView.image = #imageLiteral(resourceName: "rank_icon_copper2")
            hotLabel.yw_textColor(value: 0x7ba4f4)
            break;
        default:
            hotLabel.yw_textColor(value: 0x212121)
            rankView.isHidden = true
            progressView.isHidden = true
            hotView.isHidden = false
            rankView.isHidden = true
            hotLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(directorLabel)
                make.left.equalTo(hotView.snp.right).offset(4)
            }
            elseRankView.isHidden = false
            elseRankView.setTitle(String(row + 1), for: UIControl.State.normal)
            
            break;
        }
    }
    func resateViewState(){
        hotLabel.yw_textColor(value: 0xff9800)
        rankView.isHidden = false
        elseRankView.isHidden = true
        progressView.isHidden = false
        hotView.isHidden = true
        
        hotLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(progressView.snp.right).offset(4)
            make.centerY.equalTo(progressView.snp.centerY)
        }
        
    }
    func showAddNumberAnimation(completion: @escaping ()->Void){
        
        var addLabel : UILabel?
        addLabel = UILabel.init(frame: CGRect.init(x: kScreenWidth - 35, y:  60 , width: 20, height: 15))
        addLabel!.text = "+1"
        addLabel!.yw_textColor(value: 0xff9800)
        addLabel!.yw_font(size: 14)
        self.contentView.addSubview(addLabel!)
        
        UIView.animate(withDuration: 1, animations: {
            addLabel!.frame = CGRect.init(x: kScreenWidth - 35, y:  60 - 10 , width: 20, height: 15)
        }) { (end) in
            completion()
            addLabel!.removeFromSuperview()
            addLabel = nil
        }
        
    }
    
}
