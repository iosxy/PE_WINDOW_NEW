//
//  HotGameDetail.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameHotModel.h"
@interface HotGameDetail : UIViewController
@property(nonatomic,strong)GameHotModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UILabel *gameLable;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *tiemLong;
@property (weak, nonatomic) IBOutlet UILabel *gameSocre;
@property (weak, nonatomic) IBOutlet UILabel *guessSocre;
@property (weak, nonatomic) IBOutlet UIImageView *homeLogo;

@property (weak, nonatomic) IBOutlet UIImageView *guessLogo;

@property (weak, nonatomic) IBOutlet UIImageView *leftUp;
@property (weak, nonatomic) IBOutlet UILabel *leftCount;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *rightCount;
@property (weak, nonatomic) IBOutlet UIImageView *rightUp;


@end
