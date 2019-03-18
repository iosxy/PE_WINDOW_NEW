//
//  DetailVC.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"
@interface DetailVC : UIViewController
@property(nonatomic,strong)MainModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *favorite;
@property (weak, nonatomic) IBOutlet UILabel *descript;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
