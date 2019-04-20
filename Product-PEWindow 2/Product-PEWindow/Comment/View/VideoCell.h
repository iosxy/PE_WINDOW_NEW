//
//  VideoCell.h
//  Product-PEWindow
//
//  Created by 欢瑞世纪 on 2019/3/31.
//  Copyright © 2019 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UITableViewCell
- (void)loadData:(NSDictionary *)data;
@property(nonatomic,strong)UIButton * reportButton;
@property(nonatomic,strong)UIButton * deleteButton;

@end

NS_ASSUME_NONNULL_END
