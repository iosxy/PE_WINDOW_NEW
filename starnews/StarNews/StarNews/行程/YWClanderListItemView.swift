//
//  YWClanderListItemView.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/11/22.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
class YWClanderListItemView: UIView {

    
    var item : JSON!
    var backView : UIView!
    var lineView : UIView!
    var imageView : UIImageView!
    var titleLabel : UILabel!
    var placeBtn : UIButton!
    var goBtn : UIButton!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HEXCOLOR(0xf2f2f2)
        lineView = UIView()
        lineView.backgroundColor = HEXCOLOR(0xf3e7d5)
        
        backView = UIView()
        backView.backgroundColor = .white
        backView.clip(corner: 6)
        
        imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clip(corner: 0)
        titleLabel = UILabel()
        titleLabel.yw_font(size: 14)
        titleLabel.yw_textColor(value: 0x212121)
        titleLabel.numberOfLines = 0
        
        placeBtn = UIButton()
        placeBtn.setImage(UIImage.init(named: "route_icon_location"), for: UIControl.State.normal)
        placeBtn.setButtonInfo("", 12, HEXCOLOR(0x737373), UIControl.State.normal)
        goBtn = UIButton()
        goBtn.setImage(UIImage.init(named: "route_btn_join"), for: UIControl.State.normal)
        goBtn.adjustsImageWhenHighlighted = false
        
        
        self.addSubview(lineView)
        self.addSubview(backView)
        backView.addSubview(imageView)
        backView.addSubview(titleLabel)
        backView.addSubview(placeBtn)
        backView.addSubview(goBtn)
        
        
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(19)
            make.width.equalTo(2)
            make.top.bottom.equalToSuperview()
        }
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(94)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.right.equalToSuperview().offset(-12)
            make.left.equalTo(imageView.snp.right).offset(12)
        }
        placeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-12)
        }
        goBtn.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel)
            make.bottom.equalTo(placeBtn)
        }
        goBtn.addTarget(self, action: #selector(goBtnTap), for: UIControl.Event.touchUpInside)
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
    }
    func loadItem(item : JSON) {
        self.item = item
        imageView.yw_setImageWithUrlStr(with: item["thumbnail"]["url"].stringValue)
        titleLabel.text = item["title"].stringValue
        placeBtn.setTitle(" " + item["address"].stringValue, for: UIControl.State.normal)
        goBtn.isHidden = !item["join"].boolValue
        
    }
    @objc func tap(){
        
        let vc = YWOtherDetailViewController()
        
        let detailView = ScheduleDetailView.loadFromNib()
        detailView.timerStr =  self.item["dateStr"].stringValue
        vc.detailView = detailView
       
        var contentId = item!["id"].stringValue

        vc.shareContentID = contentId
        //  detailView.loadItem(item!)

        YWAPI_NEW.post(YWNETNEW_getContent, ["id" : contentId ,"userId":""]).then { respone -> Void in
            detailView.loadItem(respone)
            Utils.getNavigationController().pushViewController(vc, animated: true)
        }
        
    }
    @objc func goBtnTap(){
         
        self.tap()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
