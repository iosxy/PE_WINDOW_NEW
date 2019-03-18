//
//  DescCollectionViewCell.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "DescCollectionViewCell.h"

@implementation DescCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadDataWithModel:(HomeDetailModel *)model
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLabel.text = model.title;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.now_price];
    
    self.originpriceLabel.text = [NSString stringWithFormat:@"原价¥%@",model.origin_price];
   
    
    
}

@end
