//
//  MineTableViewCell.h
//  DiscountStore
//
//  Created by 游成虎 on 16/4/18.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

- (void)loadDataWithDictionary:(NSDictionary *)dict;


@end
