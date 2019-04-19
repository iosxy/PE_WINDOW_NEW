//
//  YSchedulingTableViewCell.h
//  NewsSpecial
//
//  Created by 游成虎 on 2019/4/19.
//  Copyright © 2019年 GetOn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSchedulingTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView  * bjView;
@property(nonatomic,strong)UIImageView * contentImage;
@property(nonatomic,strong)UIImageView * dianImageView;
@property(nonatomic,strong)UIView  * lineView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * addressLabel;
@property(nonatomic,strong)UILabel * timeLabel;
- (void)loadData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
