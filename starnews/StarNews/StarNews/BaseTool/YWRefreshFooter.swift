//
//  YWRefreshFooter.swift
//  Yuwan
//
//  Created by PengFei on 1/28/18.
//  Copyright © 2018 lqs. All rights reserved.
//

import Foundation
import MJRefresh
class YWRefreshFooter: MJRefreshAutoNormalFooter {
    init() {
        super.init(frame: CGRect.zero)
        
        self.setTitle("加载更多数据中...", for: .idle)
        self.setTitle("加载更多数据中...", for: .pulling)
        self.setTitle("加载更多数据中...", for: .refreshing)
        self.setTitle("加载更多数据中...", for: .willRefresh)
        self.setTitle("- 没有更多内容了 -", for: .noMoreData)
        
        self.stateLabel.yw_font(size: 14)
        self.stateLabel.yw_textColor(value: 0x9D9D9D)
    }
    
    convenience init(refreshingBlock: @escaping () -> Void) {
        self.init()
        self.refreshingBlock = refreshingBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
