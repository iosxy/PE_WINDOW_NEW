//
//  GameHotTableViewCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/21.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameHotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leagueName;
@property (weak, nonatomic) IBOutlet UILabel *gameRound;
@property (weak, nonatomic) IBOutlet UILabel *lotteryDesc;
@property (weak, nonatomic) IBOutlet UIImageView *homePicUrl;
@property (weak, nonatomic) IBOutlet UIImageView *guestPicUrl;
@property (weak, nonatomic) IBOutlet UILabel *homeName;


@property (weak, nonatomic) IBOutlet UIButton *addAlert;

@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * gameName;


@property (weak, nonatomic) IBOutlet UILabel *guestName;


@property (weak, nonatomic) IBOutlet UILabel *homeScore;
@property (weak, nonatomic) IBOutlet UILabel *guestSocre;
@property (weak, nonatomic) IBOutlet UILabel *statusDesc;

@property (weak, nonatomic) IBOutlet UILabel *startTime;

@property (weak, nonatomic) IBOutlet UILabel *zhibo;



@end









