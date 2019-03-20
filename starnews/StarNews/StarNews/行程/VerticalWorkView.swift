//
//  VerticalWorkView.swift
//  Yuwan
//
//  Created by lqs on 2017/6/17.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
enum WorkType {
    case movie
    case tv
    case book
    case music
}
class VerticalWorkView: UIView ,WorkViewProtocol {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var actLabel: UILabel!
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  @IBAction func onTap(_ sender: Any) {
  }
  
  func loadContent(_ item: JSON, workType: WorkType, _ starId: Int64) {
    let movie = {() -> JSON in
      if (workType == .movie) {
        return item
      } else if (workType == .tv) {
        return item
      } else {
        return item
      }
    }()
    
    titleLabel.text = movie["name"].stringValue
    if (workType == .music) {
      let attributedString = NSMutableAttributedString()
        attributedString.append(NSMutableAttributedString(string: Utils.getDate(movie["time"].int64Value, format: "yyyy"), attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0x73/255.0, alpha: 1)]))
      actLabel.attributedText = attributedString
      imageView.snp.makeConstraints({ (make) in
        make.height.equalTo(90)
      })
    } else {
      if (starId == -1) {
        actLabel.snp.makeConstraints({ (make) in
          make.height.equalTo(0)
        })
//        let attributedString = NSMutableAttributedString()
//        attributedString.append(NSMutableAttributedString(string: Utils.getDate(movie["publishTime"].int64Value, format: "yyyy"), attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 0x73/255.0, alpha: 1)]))
//        actLabel.attributedText = attributedString
      } else {
        var flag: Bool = false
        for starItem in movie["starItems"].arrayValue {
          if starItem["name"].stringValue == item["starName"].stringValue {
            let attributedString = NSMutableAttributedString()
            if (starItem["role"].stringValue != "导演") {
                attributedString.append(NSMutableAttributedString(string: "饰 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0x21/255.0, alpha: 1)]))
            }
            attributedString.append(NSMutableAttributedString(string: starItem["role"].stringValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0x73/255.0, alpha: 1)]))
            
            actLabel.attributedText = attributedString
            flag = true
            break
          }
        }
        if !flag {
          actLabel.text = ""
        }
      }
    }
    imageView.yw_setImageWithUrlStr(with: movie["cover"]["url"].string, w: "100", h: "100")
    //imageView.yw_setImage(with: movie["cover"]["url"].url)
  }
  
  
  func loadStarItem(_ item: JSON) {
    
    titleLabel.text = item["name"].stringValue
    let attributedString = NSMutableAttributedString()
    if (item["role"].stringValue != "导演") {
        attributedString.append(NSMutableAttributedString(string: "饰 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0x73/255.0, alpha: 1)]))
    }
    attributedString.append(NSMutableAttributedString(string: item["role"].stringValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0x73/255.0, alpha: 1)]))
    
    actLabel.attributedText = attributedString
    imageView.yw_setImageWithUrlStr(with: item["cover"]["url"].string, w: "100", h: "100")

   // imageView.yw_setImage(with: item["cover"]["url"].url)
  }
}
