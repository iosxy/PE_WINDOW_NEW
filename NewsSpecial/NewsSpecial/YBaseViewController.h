//
//  YBaseViewController.h
//  weiliao
//
//  Created by 游成虎 on 2019/4/17.
//  Copyright © 2019年 游成虎. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic) NSMutableArray *dataList;
@end

NS_ASSUME_NONNULL_END
