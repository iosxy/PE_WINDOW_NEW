//
//  MineTableViewCell.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/18.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)loadDataWithDictionary:(NSDictionary *)dict
{
    
    _iconImageView.image = [UIImage imageNamed:dict[@"icon"]];
    _myImageView.image = [UIImage imageNamed:@"mine_my_arrow_right~iphone"];
    _titleLabel.text = [dict objectForKey:@"title"];
    
    
}






@end
