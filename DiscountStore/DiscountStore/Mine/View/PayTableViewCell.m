//
//  PayTableViewCell.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/26.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadDataWithModel:(HomeDetailModel *)model
{
    if (model) {
        
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
        self.title.text = model.title;
        self.price.text = [NSString stringWithFormat:@"¥%@",model.now_price];
        self.descLabel.text = [NSString stringWithFormat:@"共一件商品 合计%@",model.now_price];
    }
    
}

@end
