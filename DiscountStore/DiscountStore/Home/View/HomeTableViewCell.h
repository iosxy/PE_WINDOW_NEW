//
//  HomeTableViewCell.h
//  DiscountStore
//
//  Created by 游成虎 on 16/4/16.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDetailModel.h"

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *on_SaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLable;


@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;


- (void)loadDataWithModel:(HomeDetailModel *)model;

@end
