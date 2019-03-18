//
//  CommentACell.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "CommentACell.h"

@implementation CommentACell

- (void)awakeFromNib {
   
    self.headImg.layer.cornerRadius = 16;
    self.headImg.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
