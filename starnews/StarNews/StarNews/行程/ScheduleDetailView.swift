//
//  ScheduleDetailView.swift
//  Yuwan
//
//  Created by lqs on 2017/7/23.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON


class ScheduleDetailView: UIView, Shareable {


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var guestScrollView: UIScrollView!
    @IBOutlet weak var joinLabel: UILabel!
    
    @IBOutlet weak var joinAlertTopOffset: NSLayoutConstraint!
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var joinAlert: UILabel!
    var id: String? = nil;
    
    let shadowLayer = CAShapeLayer()
    var calendar: JSON? = nil;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6
        containerView.layer.insertSublayer(shadowLayer, at: 0)
        self.goBtn.addTarget(self, action: #selector(goBtnClick), for: UIControl.Event.touchUpInside)
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
    

    @objc func goBtnClick(){
        
//        let vc = ProductDetailViewController()
//        vc.productID = self.calendar!["productId"].intValue
//
//        Utils.getNavigationController().pushViewController(vc, animated: true)
    }
    
    func loadItem(_ item: JSON) {
        let content = item["content"] != JSON.null ? item["content"] : item
        self.id = content["id"].stringValue
        let detail = content["detail"]
        let calendar = detail["calendar"]
        self.calendar = detail["calendar"]
        backgroundImageView.yw_setImage(with: calendar["background"]["url"].url)
        
        titleLabel.text = calendar["title"].stringValue
        if !calendar["dateStr"].stringValue.isEmpty {
            var timeStr : String = calendar["dateStr"].stringValue
            if !calendar["timeStr"].stringValue.isEmpty {
                timeStr = timeStr + " " + calendar["timeStr"].stringValue
            }
            timeLabel.text = timeStr
        } else {
            timeLabel.text = Utils.getDate(calendar["time"].int64Value, format: "yyyy-MM-dd HH:mm")
        }
        locationLabel.text = calendar["address"].stringValue
        descriptionLabel.text = calendar["description"].stringValue
        joinLabel.text = calendar["joinInfo"].stringValue
        if joinLabel.text == "" {
            joinAlert.text = ""
        }
        self.goBtn.isHidden = !calendar["join"].boolValue
        var lastView: GuestView? = nil
        if calendar["guests"].arrayValue.count == 0 {
            self.guestLabel.text = ""
            joinAlertTopOffset.constant = 0
        }
        for (i, guest) in calendar["guests"].arrayValue.enumerated() {
            let guestView = GuestView.loadFromNib()
            guestView.nameLabel.text = guest["name"].stringValue
            guestView.avatarImageView.yw_setImage(with: guest["cover"]["url"].url)
            guestScrollView.addSubview(guestView)
            guestView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.lessThanOrEqualToSuperview()
                if lastView == nil {
                    make.left.equalToSuperview().offset(20)
                } else {
                    make.left.equalTo(lastView!.snp.right).offset(20)
                }
                make.right.lessThanOrEqualToSuperview().offset(-20)
            })
            let gestureRecognizer = UITapGestureRecognizer()
            gestureRecognizer.addTarget(self, action: #selector(tapAvatar(_:)))
            guestView.avatarImageView.isUserInteractionEnabled = true
            guestView.avatarImageView.addGestureRecognizer(gestureRecognizer)
            guestView.avatarImageView.tag = i
            lastView = guestView
        }
        
    }
    
    func getContentId() -> String {
        return id!
    }
    
    @IBAction func tapAvatar(_ sender: UITapGestureRecognizer) {
        if (calendar != nil) {
            let guest = calendar!["guests"][sender.view!.tag]
            let parameters: Dictionary<String, Any> = ["name": guest["name"].stringValue]
//            YWAPI_.get(YWNET_getStarByName, parameters).then { item -> Void in
//                let vc = YuwanCard3ViewController()
//                vc.shareContentType = YW_TYPE_STAR
//                vc.shareContentID = item["star"]["id"].stringValue
//                vc.loadStar(item)
//                Utils.getNavigationController().pushViewController(vc, animated: true)
//            }
        }
//        YWAPI.get("/product/products/" + sid).then { data -> Void in
//            let vc = ProductDetailViewController()
//            vc.loadItem(data)
//            Utils.getNavigationController().pushViewController(vc, animated: true)
//            }.catch(execute: { _ in
//            })
    }

    deinit {
        
    }
    func share() {
     
    }

}
