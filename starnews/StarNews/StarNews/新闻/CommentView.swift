//
//  CommentView.swift
//  Yuwan
//
//  Created by lqs on 2017/8/22.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
typealias commentListTapBlock = (_ contentId:String,_ parentId:String,_ userName:String?)->Void
class CommentView: UIView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var replyToContainer: UIView!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var talkButton: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var replayContentHeight: NSLayoutConstraint!
    var model : commentModel!
    var commentTapBlock:commentListTapBlock?
    var commentRefreshBlock : commentListTapBlock?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.talkButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addComment)))
        self.likeCount.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addLike)))
        self.likeCount.isUserInteractionEnabled = true
        self.likeButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addLike)))
        self.talkButton.isUserInteractionEnabled = true
        self.likeButton.isUserInteractionEnabled = true
        self.contentLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addComment)))
        self.contentLabel.isUserInteractionEnabled = true
    }
    
    func loadData(model:commentModel) ->Void
    {
       
        self.model = model
        
        self.likeCount.text = String(model.likeCount)
        self.likeButton.isHighlighted = model.commentLike!
        self.avatarImageView.yw_setImage(with: URL.init(string: model.userAvatar!))
        self.nickLabel.text = model.userName
        self.contentLabel.text = model.comment
        self.timeLabel.text = model.time?.compareCurrentTime(time: model.time!)
        self.likeButton.isHighlighted = model.commentLike!
        var arr = model.commentVo
        for view:UIView in replyToContainer.subviews {
            view.removeFromSuperview()
        }
        var lastLabel:UILabel? = nil
        var arrcount = Int(arr!.count)
        
        for (i , item) in replyToContainer.subviews.enumerated() {
            item.removeFromSuperview()
        }
        
        if model.twoCommentCount > 2 {
            arrcount = 3
        }
        for i in 0..<arrcount {
           
            var text:String? = nil
            if i < 2 {
                
                if i > (arr?.count)! - 1 {
                    text = ""
                }else {
                    let modelitem = arr![i]
                    if modelitem.userName == nil {
                        modelitem.userName = ""
                    }
                    
                    if (modelitem.replyName?.isEmpty)! {
                        //评论
                        text = modelitem.userName! + ": " + modelitem.comment!
                    }else {
                        //回复评论
                        text = modelitem.userName! + "回复" + modelitem.replyName! + ": " + modelitem.comment!
                    }
                }
                
            }else if i == 2 {
                text = "共" + String(self.model.twoCommentCount) + "条回复 >"
            }else {
                text = ""
            }
            
            //循环创建评论数据
            var label = UILabel()
            label.yw_font(size: 14)
            label.text = text
           // label.textColor = HEXCOLOR(0x212121)
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = kScreenWidth - 92   //必须设置这句话,不然高度计算会出错
            //设置富文本
            var attributstring  = label.getAttributeStringWithString(label.text!, lineSpace: 5) //行间距要写在计算高度的前面
            label.attributedText = attributstring
            replyToContainer.addSubview(label)
            if i == 0 {
                label.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(12)
                    make.top.equalToSuperview().offset(12)
                }
            }else
            {
                label.textColor = UIColor.black
                label.snp.makeConstraints { (make) in
                    make.left.equalTo((lastLabel?.snp.left)!)
                    make.top.equalTo((lastLabel?.snp.bottom)!).offset(5)
                    
                }
            }
            replyToContainer.layoutIfNeeded()
            if i == (arrcount - 1) {
                replayContentHeight.constant = label.bottom + 9.0
            }
            
            lastLabel = label
            
            if i < 2 {
                if i > (arr?.count)! - 1 {
                     label.text = text
                }else {
                    let modelitem = arr![i]
                    let userNameStr = modelitem.userName
                   
                    label.text = userNameStr
                }
                
            }else if i == 2{
                label.text = text
                label.yw_textColor(value: 0xff9800)
            }
            
            label.lineBreakMode = NSLineBreakMode.byCharWrapping
            //设置点击
            label.tag = i;
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap(tpag:))))
        }
        if arr?.count == 0 {
            replayContentHeight.constant = 0
        }
    }

    @objc func tap(tpag:UITapGestureRecognizer) -> Void {
       //进行回复评论
        if (commentTapBlock != nil)
        {
            if (tpag.view?.tag)! < 2 {
                let tapModel = self.model.commentVo[(tpag.view?.tag)!]
                if(tapModel.userId == nil || self.model.id == nil)
                {
                    commentTapBlock!("","","")
                    return
                }
                commentTapBlock!(String(tapModel.userId!), String(self.model.id!),tapModel.userName!)
            } else if tpag.view?.tag == 2{

               
            }
        }
    }
    
    @objc func addComment() -> Void
    {
        if YWAPI_NEW.getAuth() == nil {
            let vc = LoginViewController().inNavigationController()
            Utils.getNavigationController().present(vc, animated: true)
            return
        }
        //点评论按钮
        if (commentTapBlock != nil)
        {
            if(self.model.userId == nil || self.model.id == nil)
            {
                commentTapBlock!("","","")
                return
            }
            
            commentTapBlock!(String(self.model.userId!),String(self.model.id!),self.model.userName!)
        }
    }
    @objc func addLike() -> Void
    {
        if YWAPI_NEW.getAuth() == nil {
            let vc = LoginViewController().inNavigationController()
            Utils.getNavigationController().present(vc, animated: true)
            return
        }
        if self.likeButton.isHighlighted || YWAPI_NEW.getUserModel()?.id == nil{
            return
        }
        self.model.likeCount += 1
        self.model.commentLike = true
        self.likeButton.isHighlighted = true
        if YWAPI_NEW.getAuth() == nil {
            let vc = LoginViewController().inNavigationController()
            Utils.getNavigationController().present(vc, animated: true)
            return
        }
        YWAPI_NEW.post(YWNETNEW_addLikeCount, ["userId":YWAPI_NEW.getUserModel()?.id!,"id":self.model.id]).then{respon -> Void in
            
        }
        
        var likecount = Int((self.likeCount.text)!)
        
        likecount! += 1
        
        self.likeCount.text = NSString.init(format: "%d", likecount!) as String
        
    }
    
}
