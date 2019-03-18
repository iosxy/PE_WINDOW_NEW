//
//  GameDetailCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sortNo;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *winCount;
@property (weak, nonatomic) IBOutlet UILabel *loseCount;
@property (weak, nonatomic) IBOutlet UILabel *winrate;

@end
