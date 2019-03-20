//
//  MovieDetailView.swift
//  Yuwan
//
//  Created by lqs on 2017/7/12.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
typealias shareBlock = (_ result:Bool?)->Void
class MovieDetailView: UIView, Shareable {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var actorScrollView: UIScrollView!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var mainActorLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoContainerView: TwoColumnView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var seeCountLabel: UILabel!
    
    @IBOutlet weak var rankLable: UILabel!
    
    @IBOutlet weak var voteButton: UIButton!
    var item: JSON? = nil
    var movie: JSON? = nil
    var viewDidLoad : shareBlock?
    let shadowLayer = CAShapeLayer()
    var id: String? = nil
    var type: String? = nil
    
    weak var tableView: UITableView? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6
        containerView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        shadowLayer.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 6).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2.0)
        shadowLayer.shadowOpacity = 0.22
        shadowLayer.shadowRadius = 4
        
    }
    
    @IBAction func play(_ sender: Any) {
        let movie = item!["detail"]["movie"] != .null ? item!["detail"]["movie"] : item!["detail"]["tv"]
        let url = movie["url"].url
        if url != nil && !(url?.absoluteString.isEmpty)! {
//            let vc = WebViewController()
//            //vc.loadURL(url)
//            vc.loadURL(url, contentId: item!["id"].stringValue)
//            Utils.getNavigationController().pushViewController(vc, animated: true)
            
            let vc = BaseWebViewController()
            vc.loadUrl = url?.absoluteString
            Utils.getNavigationController().pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func expandDescription(_ sender: Any) {
        tableView?.beginUpdates()
        descriptionLabel.numberOfLines = 0
        tableView?.endUpdates()
        
        expandButton.isHidden = true
        
    }
    
    func loadDataWithId(id : String) {
        
        YWAPI_NEW.post(YWNETNEW_getContent, ["id" : id , "userId" : YWAPI_NEW.getUserModel()?.id == nil ? "" : YWAPI_NEW.getUserModel()?.id ]).then {[weak self] item -> Void in
            
            self?.loadItem(item)
            
            }.catch { (error) in
                if self.viewDidLoad != nil {
                    self.viewDidLoad!(false)
                }
        }
        
    }
    func laodRank(rank : NSNumber) -> Void {
        if rank.intValue < 51 && rank.intValue > 0{
            
            var newTitle = ""
            
            newTitle = "本周热度排名：" + rank.stringValue
            
            self.rankLable.text = newTitle
            
            
        }
    }
    
    func loadRankData(id : String){
        
        YWAPI_NEW.post(YWNETNEW_getContent, ["id" : id , "userId" : YWAPI_NEW.getUserModel()?.id == nil ? "" : YWAPI_NEW.getUserModel()?.id ]).then {[weak self] item -> Void in
            
            if item["rank"].intValue < 51 && item["rank"].intValue > 0 {
                self?.laodRank(rank: item["rank"].numberValue)
            }
            
            
            if self?.viewDidLoad != nil {
                self?.viewDidLoad!(true)
            }
            
            self?.seeCountLabel.text = Utils.shortNumberString(item["number"].numberValue)
            
            }.catch { (error) in
                if self.viewDidLoad != nil {
                    self.viewDidLoad!(false)
                }
        }
        
    }
    
    func loadItem(_ item: JSON) {
        
        self.loadRankData(id: item["id"].stringValue)
        self.id = item["id"].stringValue
        self.item = item
        if (item["detail"]["movie"] != .null) {
            self.type = "movie"
        } else {
            self.type = "tv"
        }
        let movie = item["detail"][self.type!]
        self.movie = movie
        self.seeCountLabel.text = Utils.shortNumberString(item["number"].numberValue)
        self.backgroundImageView.yw_setImage(with: movie["background"]["url"].url)
        self.coverImageView.yw_setImage(with: movie["cover"]["url"].url)
        
        self.titleLabel.text = movie["name"].stringValue
        self.directorLabel.text = movie["directors"].stringValue
        self.mainActorLabel.text = movie["majorStar"].stringValue
        self.typeLabel.text = movie["type"].stringValue
        if !movie["publishTimeStr"].stringValue.isEmpty {
            self.releaseDateLabel.text = movie["publishTimeStr"].stringValue
        } else {
            self.releaseDateLabel.text = Utils.getDate(movie["publishTime"].int64Value)
        }
        
        self.descriptionLabel.text = movie["description"].stringValue
        if Utils.lineNumber(label: self.descriptionLabel, text: movie["description"].stringValue) >= 5 {
            self.expandButton.isHidden = false
        } else {
            self.expandButton.isHidden = true
        }
        let url = movie["url"].url
        if url != nil && !(url?.absoluteString.isEmpty)! {
            self.playButton.isHidden = false
        } else {
            self.playButton.isHidden = true
        }
        var lastView: VerticalWorkView? = nil
        for starItem in movie["starItems"].arrayValue {
            let view = VerticalWorkView.loadFromNib()
            view.loadStarItem(starItem)
            
            self.actorScrollView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.height.lessThanOrEqualToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
                
                if lastView == nil {
                    make.left.equalToSuperview().offset(14)
                } else {
                    make.left.equalTo(lastView!.snp.right).offset(10)
                }
                make.right.lessThanOrEqualToSuperview().offset(-14)
            })
            
            lastView = view
        }
        
        for (i,photo) in movie["photos"].arrayValue.enumerated() {
            let aspectRatio = Utils.calcAspectRatio(image: photo)
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            self.photoContainerView.addChildView(imageView)
            imageView.yw_setImage(with: photo["url"].url)
            imageView.snp.makeConstraints({ (make) in
                make.width.equalTo(imageView.snp.height).multipliedBy(aspectRatio)
            })
            imageView.tag = i
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        }
        
        
    }
    @IBAction func voteClick(_ sender: Any) {
        
//
//        let vcs = Utils.getNavigationController().viewControllers
//        for vc in 0...vcs.count - 1{
//
//            if vcs[vc] as? YWHomeRankingViewController != nil {
//
//                Utils.getNavigationController().popToViewController(vcs[vc], animated: true)
//                return
//            }
//
//        }
//
//        let rankingVc = YWHomeRankingViewController()
//        rankingVc.defaultPage = 2
//        Utils.getNavigationController().pushViewController(rankingVc, animated: true)
        
    }
    
    func getContentId() -> String {
        return id!
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let vc = AlbumViewController()
        Utils.getNavigationController().pushViewController(vc, animated: true)
        vc.loadItems(self.movie!["photos"].arrayValue, page: sender.view!.tag)
    }
    
    func share() {
//        YWAPI.share(title: titleLabel.text!, suffix: " - 娱丸卡", description: descriptionLabel.text!, image: backgroundImageView.image!, url: YW_URL_SHARE +  "/detail/" + type! + ".html?id=" + id!)
        
    }
}
