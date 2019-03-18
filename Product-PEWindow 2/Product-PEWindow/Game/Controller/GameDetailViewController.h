//
//  GameDetailViewController.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameDetailViewController : UIViewController
/** iD*/
@property(nonatomic,copy)NSString * gameID;
/** title*/
@property(nonatomic,copy)NSString * gametitle;

/** sortNo*/
@property(nonatomic,copy)NSString * sortNo;
@end
