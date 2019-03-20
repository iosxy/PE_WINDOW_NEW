//
//  AddCommentView.swift
//  Yuwan
//
//  Created by lqs on 2017/8/22.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddCommentView: UIView ,UITextViewDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextView.delegate = self
        
    }


    func textViewDidChange(_ textView: UITextView) {
        
        
        var nsTextContent = textView.text
        
        let existTextNum = nsTextContent?.count
        
        if (existTextNum! > 1000)
        {
            //截取到最大位置的字符
            let s = nsTextContent?.prefix(1000)
            textView.text = String(s!)
            SVProgressHUD.showInfo(withStatus: "评论字数要在10-1000之间哦~")
        }
        
        
    }
    
}

