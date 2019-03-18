//
//  RedYellowModelTableViewCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedYellowModelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sort;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *redCards;
@property (weak, nonatomic) IBOutlet UILabel *yellowCard;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;

@end
