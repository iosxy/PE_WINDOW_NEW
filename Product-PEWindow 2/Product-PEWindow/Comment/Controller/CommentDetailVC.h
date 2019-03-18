//
//  CommentDetailVC.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "TalkCell.h"
#import "TalkModel.h"
@interface CommentDetailVC : UIViewController
/** */
@property(nonatomic,strong)CommentModel * model;
/** contentid*/
@property(nonatomic,copy)NSString * contentId;

@end
