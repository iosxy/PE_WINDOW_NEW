//
//  ShopCrowdProductCell.swift
//  Yuwan
//
//  Created by PengFei on 2017/11/11.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedItemNormalCell: UICollectionViewCell {

  var normalContainer: UIView!
  
  var normalImageView: UIImageView!
  var normalTitleView: UILabel!
  var normalSourceView: UILabel!
  var normalDateView: UILabel!
  var normalVideoImageView: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.layer.cornerRadius = 6
    self.layer.masksToBounds = true

    normalContainer = UIView()
    self.addSubview(normalContainer)
    normalContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    normalImageView = UIImageView()
    normalImageView.contentMode = .scaleAspectFill
    normalImageView.clipsToBounds = true
    self.normalContainer.addSubview(normalImageView)
    normalImageView.snp.makeConstraints { make in
      make.right.top.bottom.height.equalToSuperview()
      make.width.equalTo(148)
    }
    
    normalTitleView = UILabel()
    normalTitleView.font = UIFont.systemFont(ofSize: 16)
    normalTitleView.textColor = HEXCOLOR(0x212121)
    normalTitleView.highlightedTextColor = HEXCOLOR(0x9d9d9d)
    normalTitleView.numberOfLines = 2
    normalTitleView.lineBreakMode = .byTruncatingTail
    self.normalContainer.addSubview(normalTitleView)
    normalTitleView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.left.equalToSuperview().offset(12)
      make.right.equalTo(normalImageView.snp.left).offset(-12)
    }
    
    normalSourceView = UILabel()
    normalSourceView.font = UIFont.systemFont(ofSize: 12)
    normalSourceView.textColor = HEXCOLOR(0x737373)
    self.normalContainer.addSubview(normalSourceView)
    normalSourceView.snp.makeConstraints { make in
      make.left.equalTo(normalTitleView.snp.left)
      make.bottom.equalToSuperview().offset(-10)
    }
    
    normalDateView = UILabel()
    normalDateView.font = UIFont.systemFont(ofSize: 12)
    normalDateView.textColor = HEXCOLOR(0x737373)
    self.normalContainer.addSubview(normalDateView)
    normalDateView.snp.makeConstraints { make in
      make.right.equalTo(normalTitleView.snp.right)
      make.bottom.equalToSuperview().offset(-10)
    }
    
    normalVideoImageView = UIImageView()
    normalVideoImageView.contentMode = .scaleAspectFill
    normalVideoImageView.clipsToBounds = true

    self.normalContainer.addSubview(normalVideoImageView)
    normalVideoImageView.snp.makeConstraints { make in
      make.width.height.equalTo(44)
      make.center.equalTo(normalImageView.snp.center)
    }
  }
  
    
  func setModel(model: JSON) {
  //  normalContainer.isHidden = false
    normalImageView.yw_setImageWithUrlStr(with: model["cover"]["url"].stringValue, w: "150", h: "150")
  //  normalImageView.yw_setImageWithUrlStr(with: model["cover"]["url"].stringValue)
    normalTitleView.text = model["title"].stringValue
    normalSourceView.text = model["source"].stringValue
    if normalSourceView.text == "娱丸官方" {
        normalSourceView.text = "官方"
    }
    normalDateView.text = Utils.getDate(model["time"].int64Value * 1000, format: "yyyy/MM/dd")
    normalVideoImageView.isHidden = !(model["contentType"].stringValue == "VIDEO")
  }
   
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


