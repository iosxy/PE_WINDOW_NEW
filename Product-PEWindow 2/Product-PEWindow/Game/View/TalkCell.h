//
//  TalkCell.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
