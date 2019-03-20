//
//  YWArticleDetailNewCell.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/11/8.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
class YWArticleDetailImageCell: UITableViewCell {

    var contentImageView : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentImageView = UIImageView()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.contentView.addSubview(contentImageView)
    }
    

    func loadItem(item : JSON){
        
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.clipsToBounds = true
        contentImageView.yw_setImage(with: item["image"]["url"].url)
        contentImageView.snp.remakeConstraints({ (make) in
            make.width.equalToSuperview().offset(-27)
            let width = item["image"]["width"].floatValue
            let height = item["image"]["height"].floatValue
            let aspectRatio = width > 0 && height > 0 ?  height / width : .pi
            make.height.equalTo(contentImageView.snp.width).multipliedBy(aspectRatio)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-13)
            make.top.equalToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class YWArticleDetailTextCell: UITableViewCell {
    
    var contentTextLabel : UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        contentTextLabel = UILabel()
        contentTextLabel.numberOfLines = 0
        contentTextLabel.textColor = UIColor(white: 0xf/255.0, alpha: 1)
        contentTextLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(contentTextLabel)
        contentTextLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-13)
            make.bottom.lessThanOrEqualTo(-10)
        }
    }
    func loadItem(item : JSON){
        contentTextLabel.text = item["text"].stringValue
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class YWArticleDetailTitleCell: UITableViewCell {
    
    var backImageView : UIImageView!
    var titleLabel : UILabel!
    var readCountButton : UIButton!
    var shareCountButton : UIButton!
    var sourceLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none

        backImageView = UIImageView()
        backImageView.contentMode = UIView.ContentMode.scaleAspectFill
        backImageView.clip(corner: 0)
        
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        readCountButton = UIButton()
        readCountButton.setButtonInfo("100", 12, HEXCOLOR(0x737373), UIControl.State.normal)
        readCountButton.setImage(UIImage.init(named: "rank_icon_read"), for: UIControl.State.normal)
        
        shareCountButton = UIButton()
        shareCountButton.setButtonInfo("100", 12, HEXCOLOR(0x737373), UIControl.State.normal)
        shareCountButton.setImage(UIImage.init(named: "essay_icon_share"), for: UIControl.State.normal)
        
        sourceLabel = UILabel()
        sourceLabel.yw_font(size: 12)
        sourceLabel.yw_textColor(value: 0x737373)
        
        self.contentView.addSubview(backImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(readCountButton)
        self.contentView.addSubview(shareCountButton)
        self.contentView.addSubview(sourceLabel)
        
        backImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kScreenWidth * 190 / 375)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(backImageView.snp.bottom).offset(28)
            make.right.equalToSuperview().offset(-14)
        }
        readCountButton.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.height.equalTo(16)
        }
        shareCountButton.snp.makeConstraints { (make) in
            make.left.equalTo(readCountButton.snp.right).offset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.height.equalTo(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-6)
        }
        sourceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(shareCountButton)
            make.rightMargin.equalTo(-10)
        }
        
    }
    
    func loadItem(item : JSON){
        
        
        var newItem : JSON!
        
        if item["type"] == "STARNEWS" {
            newItem = item["detail"]["starNews"]

        }else {
            newItem = item["detail"]["article"]
        }
        if newItem["cover"]["url"].stringValue == "" {
            backImageView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }else {
            backImageView.yw_setImageWithUrlStr(with: newItem["cover"]["url"].stringValue)
        }
        
        titleLabel.text = newItem["title"].stringValue
     
        sourceLabel.text = newItem["from"].stringValue + "·" + Utils.getDate(newItem["time"].int64Value , format: "yyyy-MM-dd")
        
        readCountButton.setTitle(" " +  Utils.shortNumberString(item["number"].numberValue) + "人看过", for: UIControl.State.normal)
        shareCountButton.setTitle(" " +  Utils.shortNumberString(item["shareNumber"].numberValue) + "人已分享", for: UIControl.State.normal)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class YWArticleDetailPlacehoderCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class YWArticleDetailUserListCell: UITableViewCell {
    var contentMiddleView : ActivityMiddleView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        contentMiddleView = ActivityMiddleView()
        self.addSubview(contentMiddleView)
        self.selectionStyle = UITableViewCell.SelectionStyle.none

        contentMiddleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentMiddleView.downView.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    func loadItem(item : JSON){
        contentMiddleView.loadUserName(name: item["text"].stringValue)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class ActivityMiddleView: UIView {
        var headerView = UIView()
        var upView = UIView()
        var downView = UIView()
        var namesLabel = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.addSubview(headerView)
            self.addSubview(upView)
            let topLine = UIView()
            topLine.backgroundColor = HEXCOLOR(0xF2F2F2)
            
            let listLabel = UILabel()
            listLabel.text = "中奖名单"
            listLabel.yw_textColor(value: 0x212121)
            listLabel.font = UIFont.boldSystemFont(ofSize: 16)
            
            let middleLine = UIView()
            middleLine.backgroundColor = HEXCOLOR(0xd8d8d8)
            
            namesLabel.text = "用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称用户昵称"
            namesLabel.yw_font(size: 16)
            namesLabel.yw_textColor(value: 0xff9800)
            namesLabel.numberOfLines = 0
            
            
            upView.addSubview(topLine)
            upView.addSubview(listLabel)
            upView.addSubview(middleLine)
            upView.addSubview(namesLabel)
            
            self.addSubview(downView)
            let bottomLine = UIView()
            bottomLine.backgroundColor = HEXCOLOR(0xF2F2F2)
            
            let detailLabel = UILabel()
            detailLabel.text = "活动详情"
            detailLabel.yw_textColor(value: 0x212121)
            detailLabel.font = UIFont.boldSystemFont(ofSize: 16)
            
            let downLine = UIView()
            downLine.backgroundColor = HEXCOLOR(0xd8d8d8)
            
            downView.addSubview(bottomLine)
            downView.addSubview(detailLabel)
            downView.addSubview(downLine)
            
            headerView.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(14)
            }
            
            self.upView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                //   make.height.equalTo(0)
                make.top.equalTo(headerView.snp.bottom)
                make.bottom.equalTo(namesLabel.snp.bottom).offset(14)
            }
            
            topLine.snp.makeConstraints { (make) in
                make.topMargin.equalTo(0)
                make.left.right.equalToSuperview()
                make.height.equalTo(8)
            }
            
            listLabel.snp.makeConstraints { (make) in
                make.leftMargin.equalTo(14)
                make.top.equalTo(topLine.snp.bottom).offset(14)
            }
            middleLine.snp.makeConstraints { (make) in
                make.leftMargin.rightMargin.equalTo(14)
                make.top.equalTo(listLabel.snp.bottom).offset(14)
                make.height.equalTo(0.5)
            }
            namesLabel.snp.makeConstraints { (make) in
                make.leftMargin.equalTo(14)
                make.rightMargin.equalTo(-14)
                make.top.equalTo(middleLine.snp.bottom).offset(14)
            }
            
            self.downView.snp.makeConstraints { (make) in
                
                make.top.equalTo(self.upView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(52)
                make.bottom.lessThanOrEqualToSuperview()
            }
            bottomLine.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(8)
            }
            detailLabel.snp.makeConstraints { (make) in
                make.leftMargin.equalTo(14)
                make.top.equalTo(bottomLine.snp.bottom).offset(14)
            }
            downLine.snp.makeConstraints { (make) in
                make.top.equalTo(detailLabel.snp.bottom).offset(14)
                make.leftMargin.rightMargin.equalTo(14)
                make.height.equalTo(0.5)

            }
            
        }
        func loadUserName(name:String!) -> Void {
            
            if name == "" {
                self.upView.isHidden = true
                self.upView.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(0)
                    make.top.equalTo(headerView.snp.bottom)
                }
                
            }else{
                self.upView.isHidden = false
                self.namesLabel.text = name
                self.upView.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    //   make.height.equalTo(0)
                    make.top.equalTo(headerView.snp.bottom)
                    make.bottom.equalTo(namesLabel.snp.bottom).offset(14)
                }
            }
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
class YWArticleDetailAboutCell: UITableViewCell {
    
    var titleLabel : UILabel!
    var topLine : UIView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        topLine = UIView()
        topLine.backgroundColor = HEXCOLOR(0xf2f2f2)
        self.contentView.addSubview(topLine)
        
        let view = UIView()
        view.backgroundColor = HEXCOLOR(0xff9800)
        self.contentView.addSubview(view)
        
        titleLabel = UILabel()
        titleLabel.yw_font(size: 18)
        titleLabel.yw_textColor(value: 0x212121)
        self.contentView.addSubview(titleLabel)
        topLine.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(8)
        }
        view.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(topLine.snp.bottom).offset(12)
            make.width.equalTo(4)
            make.height.equalTo(18)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view.snp.right).offset(12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YWArticleDetailAboutStarCell: YWArticleDetailAboutCell ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    var item : JSON!
    var collectionView : UICollectionView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 60, height: 87)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(aboutStarCell.self, forCellWithReuseIdentifier: "aboutStarCell")
        collectionView.backgroundColor = .clear
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(87)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-30)
        }
    }
    func loadItem(item : JSON){
        
            self.titleLabel.text = "相关明星"
            self.topLine.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        self.item = item
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.item["item"].arrayValue.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aboutStarCell", for: indexPath) as! aboutStarCell
        cell.loadItem(item: self.item["item"][indexPath.row])
        return cell
    }
    
    private class aboutStarCell : UICollectionViewCell {
        
        var headImage : UIImageView!
        var titleLabel : UILabel!
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            headImage = UIImageView()
            headImage.contentMode = UIView.ContentMode.scaleAspectFill
            //headImage.backgroundColor = .red
            headImage.clip(corner: 30)
            
            titleLabel = UILabel()
            titleLabel.yw_font(size: 14)
            titleLabel.yw_textColor(value: 0x212121)
            titleLabel.text = "名字"
            titleLabel.textAlignment = NSTextAlignment.center
            
            self.contentView.addSubview(titleLabel)
            self.contentView.addSubview(headImage)
            
            headImage.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(60)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(headImage.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
            }
        }
        func loadItem(item : JSON){
            
            headImage.yw_setImageWithUrlStr(with: item["image"]["url"].stringValue)
            titleLabel.text = item["title"].stringValue
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class YWArticleDetailAboutActivityCell: YWArticleDetailAboutCell ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  
    var item : JSON!
    var collectionView : UICollectionView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: kScreenWidth/2 - 50/2, height: 143)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(aboutArtivityCell.self, forCellWithReuseIdentifier: "aboutArtivityCell")
        collectionView.backgroundColor = .clear
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(143)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-30)
        }
    }
    func loadItem(item : JSON){
        self.item = item
        self.titleLabel.text = item["title"].stringValue
        
        if item["title"] == "相关活动" {
            self.topLine.snp.updateConstraints { (make) in
                make.height.equalTo(8)
            }
        }else {
            self.topLine.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.item["item"].arrayValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aboutArtivityCell", for: indexPath) as! aboutArtivityCell
        cell.loadItem(item: self.item["item"][indexPath.row])
        return cell
    }
    private class aboutArtivityCell : UICollectionViewCell {
      
        var headImage : UIImageView!
        var titleLabel : UILabel!
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            headImage = UIImageView()
            headImage.contentMode = UIView.ContentMode.scaleAspectFill
            //headImage.backgroundColor = .red
            headImage.clip(corner: 6)
            
            titleLabel = UILabel()
            titleLabel.yw_font(size: 14)
            titleLabel.yw_textColor(value: 0x212121)
            titleLabel.text = "活动标题"
            
            self.contentView.addSubview(titleLabel)
            self.contentView.addSubview(headImage)
            
            headImage.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(117)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(headImage.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
            }
        }
        func loadItem(item : JSON){
            
            headImage.yw_setImageWithUrlStr(with: item["image"]["url"].stringValue)
            titleLabel.text = item["title"].stringValue
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


