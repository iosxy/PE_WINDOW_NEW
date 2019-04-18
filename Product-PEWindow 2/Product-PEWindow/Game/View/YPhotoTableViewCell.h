//
//  YPhotoTableViewCell.h
//  Product-PEWindow
//
//  Created by 游成虎 on 2019/4/18.
//  Copyright © 2019年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPhotoTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * contentImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * authorLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * photoNumLabel;
@property(nonatomic,strong)NSDictionary * data;

- (void)loadData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
