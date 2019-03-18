//
//  FootBallTableViewCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootBallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sort;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *games;
@property (weak, nonatomic) IBOutlet UILabel *wins;
@property (weak, nonatomic) IBOutlet UILabel *draws;
@property (weak, nonatomic) IBOutlet UILabel *losses;

@property (weak, nonatomic) IBOutlet UILabel *goal;
@property (weak, nonatomic) IBOutlet UILabel *points;



//games wins,draws ,losses,goalsFor,goalsAgainst,points];
@end
