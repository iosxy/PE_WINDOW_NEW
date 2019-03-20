//
//  YWArticleDetailTableViewCell.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/8/24.
//  Copyright © 2018年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON
class YWArticleDetailTableViewCell: UITableViewCell {

    var detailView = UIView()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    
        
    }
    func updateDetailView(view : UIView!) -> Void {
        
        self.detailView.removeFromSuperview()
        self.detailView = view
        self.contentView.addSubview(self.detailView)
        self.detailView.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
class YWArticleDetailHeaderTableViewCell: UITableViewCell {
    
    var detailView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.detailView = CommentHeaderView.loadFromNib()
        self.contentView.addSubview(self.detailView)
        self.detailView.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
class YWArticleDetailCommentTableViewCell: UITableViewCell {
    
    var detailView : CommentView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.detailView = CommentView.loadFromNib()
        
        self.contentView.addSubview(self.detailView)
        self.detailView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class YWArticleDetailNoCommentTableViewCell: UITableViewCell {
    
    var detailView : CommentEmptyView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.detailView = CommentEmptyView.loadFromNib()
        
        
        
        self.contentView.addSubview(self.detailView)
        self.detailView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
class YWArticleDetailRankingCell: UITableViewCell {
    var voteContentView = UIView()
    var rankLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none

        var voteIcon = UIImageView()
        voteIcon.image = UIImage.init(named: "card_icon_rank")
        voteContentView.addSubview(voteIcon)
        
        rankLabel.yw_font(size: 14)
        rankLabel.yw_textColor(value: 0x9d9d9d)
        rankLabel.text = "本周未上榜"
        voteContentView.addSubview(rankLabel)
        
        let voteButton = UIButton()
        voteButton.setImage(UIImage.init(named: "popular_button_vote"), for: UIControl.State.normal)
        voteButton.adjustsImageWhenHighlighted = false
        voteContentView.addSubview(voteButton)
        voteButton.addTarget(self, action: #selector(voteClick), for: UIControl.Event.touchUpInside)
        voteIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.left.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
        }
        rankLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(voteIcon.snp.right).offset(6)
            make.centerY.equalToSuperview()
        }
        voteButton.snp.makeConstraints { (make) in
            make.width.equalTo(71)
            make.height.equalTo(26)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(voteContentView)
        voteContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(19)
            make.height.equalTo(26)
        }
    }
    
    @objc func voteClick(){
        

        
    }
    func loadItem(item : JSON){
        
        var newTitle = ""
        newTitle = "本周人气排名：" + item["text"].stringValue
        
        var  attributeString = rankLabel.getAttributeStringWithString(newTitle, lineSpace: 0)
    
        
        let newTitleStr = newTitle as NSString
        let range = newTitleStr.range(of: item["text"].stringValue)
        
        
        self.rankLabel.attributedText = attributeString
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
