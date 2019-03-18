//
//  PayTableViewCell.h
//  DiscountStore
//
//  Created by 游成虎 on 16/4/26.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDetailModel.h"

@interface PayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)loadDataWithModel:(HomeDetailModel *)model;


@end
