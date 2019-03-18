//
//  YCHThreeTableViewCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/18.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCHThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightUpImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightDown;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
