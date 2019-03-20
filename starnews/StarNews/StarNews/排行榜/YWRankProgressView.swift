//
//  YWRankProgressView.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/10/17.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit

class YWRankProgressView: UIView {

    var upView : UIImageView!
    var bottomView : UIView!
    let lineWidth = 110.0
    let gradientLayer = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        upView = UIImageView()
        
        upView.clip(corner: 4)
        
        bottomView = UIView()
        bottomView.clip(corner: 4)
        bottomView.alpha = 0.5
        self.addSubview(bottomView)
        self.addSubview(upView)
        
        bottomView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        upView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-1)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
//        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        //设置渐变的主颜色
        
        //将gradientLayer作为子layer添加到主layer上
      //  upView.layer.addSublayer(gradientLayer)
        
    }
    
    func setProgressData(rank: Int , multiply: Double) {
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: lineWidth * multiply , height: 8)
        switch rank {
        case 0:
            bottomView.backgroundColor = HEXCOLOR(0xff1744)
          //  gradientLayer.colors = [HEXCOLOR(0xff695e).cgColor, HEXCOLOR(0xff1744).cgColor]
            upView.image = #imageLiteral(resourceName: "schedule_backgrd_top1")
            upView.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(-1)
                make.width.equalToSuperview().multipliedBy
            }
            break
        case 1:
           // gradientLayer.colors = [HEXCOLOR(0xffc900).cgColor, HEXCOLOR(0xff9800).cgColor]
           
            bottomView.backgroundColor = RGBACOLOR(211, 205, 0, 0.5)
            upView.image = #imageLiteral(resourceName: "schedule_photo_top2")
            upView.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(-1)
                make.width.equalToSuperview().multipliedBy(multiply)
            }
            
            break
        case 2:
          
            bottomView.backgroundColor = RGBACOLOR(135, 215, 239, 0.5)
          //  gradientLayer.colors = [HEXCOLOR(0x71d6f4).cgColor, HEXCOLOR(0x7295f4).cgColor]
            upView.image = #imageLiteral(resourceName: "schedule_photo_top3")
            upView.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(-1)
                make.width.equalToSuperview().multipliedBy(multiply)
            }
            break
        default:
            gradientLayer.colors = [HEXCOLOR(0xff695e).cgColor, HEXCOLOR(0xff1744).cgColor]
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
