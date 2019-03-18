//
//  PicCollectionViewCell.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/18.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "PicCollectionViewCell.h"

@implementation PicCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)loadDataWithModel:(HomeDetailModel *)model
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLabel.text = model.title;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.now_price];
    
    self.originpriceLabel.text = [NSString stringWithFormat:@"¥%@",model.origin_price];
    self.saleLabel.text = [NSString stringWithFormat:@"月售%@笔",model.rp_sold];
    
    
}



@end
