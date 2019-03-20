//
//  moreSettingCell.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/20.
//

import UIKit

class moreSettingCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var rightSwitch: UISwitch!
    var rightLabel: UILabel!
    var rightArrowImage: UIImageView!
    var bottomLineView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle =  UITableViewCell.SelectionStyle.none
        titleLabel = UILabel()
        titleLabel.yw_font(size: 16)
        titleLabel.yw_textColor(value: 0x212121)
        self.contentView.addSubview(titleLabel)
        rightSwitch = UISwitch()
        rightSwitch.onTintColor = HEXCOLOR(0xf19d38)
        self.contentView.addSubview(rightSwitch)
        rightLabel = UILabel()
        rightLabel.yw_textColor(value: 0x737373)
        rightLabel.yw_font(size: 14)
        self.contentView.addSubview(rightLabel)
        bottomLineView = UIView()
        bottomLineView.backgroundColor = HEXCOLOR(0xf2f2f2)
        self.contentView.addSubview(bottomLineView)
        
        rightArrowImage = UIImageView()
        rightArrowImage.image = #imageLiteral(resourceName: "list_more")
        self.contentView.addSubview(rightArrowImage)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(18)
        }
        rightSwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightSwitch)
        }
        rightArrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalTo(18)
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, switchStatus: Bool?, rightText: String, showBottom: Bool) {
        contentView.height = 52
        titleLabel.text = title
        if (switchStatus == nil) {
            rightSwitch.isHidden = true
        } else {
            rightSwitch.isHidden = false
            rightSwitch.isOn = switchStatus!
        }
        if (switchStatus == nil && (rightText == nil || rightText == "")) {
            rightArrowImage.isHidden = false
        } else {
            rightArrowImage.isHidden = true
        }
        bottomLineView.isHidden = !showBottom
        rightLabel.text = rightText
        self.selectionStyle = rightSwitch.isHidden ? .default : .none
    }
}
