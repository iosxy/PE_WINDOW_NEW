//
//  YWClanderListTableViewCell.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/11/22.
//  Copyright © 2018 lqs. All rights reserved.
//

import UIKit

class YWClanderListTableViewCell: UITableViewCell {

    var clanderView : YWClanderListItemView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clanderView = YWClanderListItemView.init(frame: .zero)
      
        self.backgroundColor = .clear
        self.contentView.addSubview(self.clanderView)
        self.clanderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
