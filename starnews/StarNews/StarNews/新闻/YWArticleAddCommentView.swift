//
//  YWArticleAddCommentView.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/11/9.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
class YWArticleAddCommentView: UIView {

    var commentButton : UILabel!
    var commentIcon : UIButton!
    var commentCount : UILabel!
    var zanIcon : UIButton!
    var zanCount : UILabel!
    var contentId : String!
    var commentBackView : UIView!
    var addCommentView : YWInputCommentView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        commentBackView = UIView()
        commentButton = UILabel()
        commentButton.isUserInteractionEnabled = true
        commentButton.text = "    说点什么吧(*^▽^*)"
        commentButton.yw_font(size: 14)
        commentButton.yw_textColor(value: 0x737373)
        
        commentButton.isUserInteractionEnabled = true
        commentButton.backgroundColor = HEXCOLOR(0xe0e0e0)
        commentButton.clip(corner: 16)
        
        commentIcon = UIButton()
        commentIcon.setImage(UIImage.init(named: "comment_icon"), for: UIControl.State.normal)
        commentIcon.addTarget(self, action: #selector(commentList), for: UIControl.Event.touchUpInside)
        commentCount = UILabel()
        commentCount.yw_font(size: 14)
        commentCount.yw_textColor(value: 0x737373)
        commentCount.text = "0"
        
        zanIcon = UIButton()
        zanIcon.setImage(UIImage.init(named: "essay_icon_zan"), for: UIControl.State.normal)
        zanIcon.setImage(UIImage.init(named: "essay_icon_yizan"), for: UIControl.State.selected)
        zanIcon.addTarget(self, action: #selector(addZan), for: UIControl.Event.touchUpInside)
        zanCount = UILabel()
        zanCount.yw_eqOtherLabel(label: commentCount)
        zanCount.text = "0"
        let commentLine = UIImageView()
        commentLine.image = UIImage.init(named: "comment_line")
        
        self.addSubview(zanCount)
        self.addSubview(zanIcon)
        self.addSubview(commentCount)
        self.addSubview(commentIcon)
        commentBackView.addSubview(commentButton)
        self.addSubview(commentLine)
        self.addSubview(commentBackView)
        commentLine.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        zanCount.snp.makeConstraints { (make) in
            make.top.equalTo(15.5)
            make.right.equalToSuperview().offset(-20)
        }
        zanIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(zanCount)
            make.right.equalTo(zanCount.snp.left).offset(6)
        }
        commentCount.snp.makeConstraints { (make) in
            make.centerY.equalTo(zanCount)
            make.right.equalTo(zanIcon.snp.left)
        }
        commentIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentCount)
            make.width.height.equalTo(40)
            make.right.equalTo(commentCount.snp.left).offset(6)
        }
        
        commentBackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentIcon)
            
            make.right.equalTo(commentIcon.snp.left).offset(-10)
            
            make.left.equalToSuperview().offset(10)
            
            make.height.equalTo(32)
           
        }
    
        commentButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func loadData(id : JSON){
//        self.contentId = id
//        YWAPI_NEW.post(YWNETNEW_getCommentAndLikeNumber,["contentId" : id,"userId":YWAPI_NEW.getUserModel()?.id]).then{[weak self] response -> Void in
//
//            self?.commentCount.text = String(response["commentNumber"].stringValue)
//            self?.zanIcon.isSelected = response["isLike"].boolValue
//            self?.zanCount.text = response["likeNumber"].stringValue
//        }
//        
        self.commentCount.text = id["totalComment"].stringValue
        self.zanCount.text = id["totalLike"].stringValue
        self.zanIcon.isSelected = id["like"].boolValue
    }
    func addCommentCount(_ count : Int) {
        let currentCount = Int(self.commentCount.text ?? "0")
        if currentCount != nil {
            self.commentCount.text = String(currentCount! + count)
        }
    }
    @objc func commentList(){
        
        
    }
    
    @objc func addZan(){
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


