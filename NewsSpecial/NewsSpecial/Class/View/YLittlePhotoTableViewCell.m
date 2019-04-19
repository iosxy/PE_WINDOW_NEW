//
//  YLittlePhotoTableViewCell.m
//  NewsSpecial
//
//  Created by 游成虎 on 2019/4/19.
//  Copyright © 2019年 GetOn. All rights reserved.
//

#import "YLittlePhotoTableViewCell.h"

@implementation YLittlePhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setUpConstrains {
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjView.mas_top);
        make.left.equalTo(self.bjView.mas_left);
        make.bottom.equalTo(self.bjView.mas_bottom);
        make.height.equalTo(@120);
        make.width.equalTo(@120);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjView.mas_top).offset(10);
        make.left.equalTo(self.contentImage.mas_right).offset(10);
        make.right.equalTo(self.bjView.mas_right).offset(-8);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.bjView.mas_bottom).offset(-10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authorLabel.mas_centerY);
        make.left.equalTo(self.authorLabel.mas_right).offset(8);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
