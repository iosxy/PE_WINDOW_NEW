//
//  HomeTableViewCell.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/16.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadDataWithModel:(HomeDetailModel *)model
{
    [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLabel.text = model.title;
    
    self.nowPriceLable.text = [NSString stringWithFormat:@"¥%@",model.now_price];
    
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价:¥%@",model.origin_price];
    
    //self.on_SaleLabel.text = model.is_onsale;
    
    self.soldLabel.text = [NSString stringWithFormat:@"月销售%@笔",model.rp_sold];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
