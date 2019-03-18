//
//  MyFavoriteCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/27.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFavoriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *homeName;
@property (weak, nonatomic) IBOutlet UILabel *homeSocre;
@property (weak, nonatomic) IBOutlet UILabel *guestName;
@property (weak, nonatomic) IBOutlet UILabel *guestSocre;
@property (weak, nonatomic) IBOutlet UIImageView *HomeLogo;
@property (weak, nonatomic) IBOutlet UIImageView *GuestLogo;

@end
