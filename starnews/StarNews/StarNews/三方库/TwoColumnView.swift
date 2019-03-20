//
//  TwoColumnView.swift
//  Yuwan
//
//  Created by lqs on 2017/7/19.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit

class TwoColumnView: UIView {

    
    @IBInspectable var leftRightMargin: CGFloat = 0
    @IBInspectable var upDownMargin: CGFloat = 0
    
    private var viewArray = Array<UIView>()
    
    var lastL: UIView? = nil
    var lastR: UIView? = nil
    
    func clearAllChildViews() {
        for view in self.viewArray {
            view.removeFromSuperview()
        }
        self.viewArray.removeAll()
        lastL = nil
        lastR = nil
    }
    
    func addChildView(_ view: UIView) {
        
        self.addSubview(view)
        self.viewArray.append(view)
        
        view.snp.makeConstraints({ (make) in
            if (self.viewArray.count % 2 == 1) {
                // left
                
                make.left.equalToSuperview()
                
                if (lastL == nil) {
                    make.top.equalToSuperview()
                    make.width.equalTo(self).multipliedBy(0.5).offset(-leftRightMargin / 2)
                } else {
                    make.width.equalTo(lastL!.snp.width)
                    make.top.equalTo(lastL!.snp.bottom).offset(upDownMargin)
                }
                
                lastL = view
                
            } else {
                // right
                
                make.left.equalTo(lastL!.snp.right).offset(leftRightMargin)
                make.width.equalTo(lastL!.snp.width)
                if (lastR == nil) {
                    make.top.equalTo(lastL!)
                } else {
                    make.top.equalTo(lastR!.snp.bottom).offset(upDownMargin)
                }
                
                lastR = view
            }
            
            make.bottom.lessThanOrEqualToSuperview()
        })
    }


}
