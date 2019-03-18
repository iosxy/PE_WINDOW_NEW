//
//  GameSenceCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSenceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *descript;
@property (weak, nonatomic) IBOutlet UIView *backVIew;

@end
