//
//  YWInputCommentView.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/12/3.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit

class YWInputCommentView: UIView {

    private var backMaskView : UIView!
    private var inputBackView : UIView!
    var publishButton : UIButton!
    var cancleButton : UIButton!
    var textView : UITextView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backMaskView = UIView()
        backMaskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.55)
      
        inputBackView = UIView()
        inputBackView.backgroundColor = .white
        
        cancleButton = UIButton()
        cancleButton.setButtonInfo("取消", 16, HEXCOLOR(0x737373), UIControl.State.normal)
        
        publishButton = UIButton()
        publishButton.setButtonInfo("发布", 16, HEXCOLOR(0xff9800), UIControl.State.normal)
        
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        
        self.addSubview(backMaskView)
        self.addSubview(inputBackView)
        inputBackView.addSubview(cancleButton)
        inputBackView.addSubview(publishButton)
        inputBackView.addSubview(textView)
        
        backMaskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        inputBackView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        cancleButton.snp.makeConstraints { (make) in
            make.left.top.equalTo(14)
        }
        publishButton.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.right.equalToSuperview().offset(-14)
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(publishButton.snp.bottom).offset(14)
            make.bottom.equalToSuperview().offset(-14)
            make.right.equalToSuperview().offset(-14)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
