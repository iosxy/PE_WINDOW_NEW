//
//  ShopCrowdProductCell.swift
//  Yuwan
//
//  Created by PengFei on 2017/11/11.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedItemBigCell: UICollectionViewCell {
  
  var bigContainer: UIView!
  
  var bigImageView: UIImageView!
  var bigTitleView: UILabel!
  var bigSourceView: UILabel!
  var bigDateView: UILabel!
  var bigVideoImageView: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.layer.cornerRadius = 6
    self.layer.masksToBounds = true
    
    bigContainer = UIView()
    self.addSubview(bigContainer)
    bigContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    bigImageView = UIImageView()
    bigImageView.contentMode = .scaleAspectFill
    bigImageView.clipsToBounds = true
    self.bigContainer.addSubview(bigImageView)
    bigImageView.snp.makeConstraints { make in
      make.left.top.width.equalToSuperview()
      make.height.equalTo(178)
    }
    
    bigTitleView = UILabel()
    bigTitleView.highlightedTextColor = HEXCOLOR(0x9d9d9d)
    bigTitleView.font = UIFont.systemFont(ofSize: 16)
    bigTitleView.textColor = HEXCOLOR(0x212121)
    bigTitleView.numberOfLines = 2
    bigTitleView.lineBreakMode = .byTruncatingTail
    self.bigContainer.addSubview(bigTitleView)
    bigTitleView.snp.makeConstraints { make in
      make.top.equalTo(bigImageView.snp.bottom).offset(12)
      make.left.equalToSuperview().offset(12)
      make.right.equalToSuperview().offset(-12)
    }
    
    bigSourceView = UILabel()
    bigSourceView.font = UIFont.systemFont(ofSize: 12)
    bigSourceView.textColor = HEXCOLOR(0x737373)
    self.bigContainer.addSubview(bigSourceView)
    bigSourceView.snp.makeConstraints { make in
      make.top.equalTo(bigTitleView.snp.bottom).offset(16)
      make.left.equalTo(bigTitleView.snp.left)
      make.bottom.equalToSuperview().offset(-10)
    }
    
    bigDateView = UILabel()
    bigDateView.font = UIFont.systemFont(ofSize: 12)
    bigDateView.textColor = HEXCOLOR(0x737373)
    self.bigContainer.addSubview(bigDateView)
    bigDateView.snp.makeConstraints { make in
      make.top.equalTo(bigTitleView.snp.bottom).offset(16)
      make.right.equalTo(bigTitleView.snp.right)
      make.bottom.equalToSuperview().offset(-10)
    }
    bigVideoImageView = UIImageView()
    bigVideoImageView.contentMode = .scaleAspectFill
    bigVideoImageView.clipsToBounds = true
  
    self.bigContainer.addSubview(bigVideoImageView)
    bigVideoImageView.snp.makeConstraints { make in
      make.width.height.equalTo(44)
      make.center.equalTo(bigImageView.snp.center)
    }
  }
  
  func setModel(model: JSON) {
    bigContainer.isHidden = false
  //  bigImageView.yw_setImage(with: model["cover"]["url"].url)
 
    
    bigImageView.yw_setImageWithUrlStr(with: model["cover"]["url"].stringValue, w: "200", h: "200")
   // bigImageView.yw_setImageWithUrlStr(with: model["cover"]["url"].stringValue)
    bigTitleView.text = model["title"].stringValue
    bigSourceView.text = model["source"].stringValue
    bigDateView.text = Utils.getDate(model["time"].int64Value * 1000, format: "yyyy/MM/dd")
    bigVideoImageView.isHidden = !(model["contentType"].stringValue == "VIDEO")
  
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


