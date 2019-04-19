//
//  UploadHeaderCell.m
//  xiubo2.0
//
//  Created by iOS1 on 16/1/9.
//  Copyright © 2016年 王芝刚. All rights reserved.
//

#import "UploadHeaderCell.h"

@interface UploadHeaderCell ()


@property (weak, nonatomic) IBOutlet UILabel *photoLab;

@end

@implementation UploadHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _headerView1.layer.masksToBounds = YES;
    _headerView1.userInteractionEnabled = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
