//
//  YWClanderListHeaderView.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/11/22.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
class YWClanderListHeaderView: UIView {

    var timeIcon : UIImageView!
    var timeLabel : UILabel!
    var item : JSON!
    var upLine : UIView!
    var downLine : UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        timeIcon = UIImageView()
       
        self.backgroundColor = HEXCOLOR(0xf2f2f2)
        timeLabel = UILabel()
        timeLabel.yw_font(size: 14)
        timeLabel.yw_textColor(value: 0x737373)
        
         upLine = UIView()
        upLine.backgroundColor = HEXCOLOR(0xf3e7d5)
         downLine = UIView()
        downLine.backgroundColor = upLine.backgroundColor!
        
        self.addSubview(upLine)
        self.addSubview(downLine)
        self.addSubview(timeLabel)
        self.addSubview(timeIcon)
        
        timeIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(19)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            
        }
        upLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(timeIcon)
            make.width.equalTo(2)
            make.bottom.equalTo(timeIcon.snp.top)
        }
        downLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(timeIcon)
            make.width.equalTo(2)
            make.top.equalTo(timeIcon.snp.bottom)
        }
        
    }
    func loadItem(item : JSON , section : Int) {
        if section == 0 {
            upLine.isHidden = true
            timeIcon.image = UIImage.init(named: "route_icon_time")
        }else {
            upLine.isHidden = false
            timeIcon.image = UIImage.init(named: "route_icon_round")
        }
        //timeLabel.text = Utils.getDate(item["time"].int64Value, format: "M月d日")
        timeLabel.text = item["dateStr"].stringValue
        if item["id"].int == nil {
            //最后一行
            timeLabel.text = "暂无更多内容"
            downLine.isHidden = true
        }else {
            downLine.isHidden = false
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

