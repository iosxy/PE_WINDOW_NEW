//
//  YPhotoTableViewCell.m
//  Product-PEWindow
//
//  Created by 游成虎 on 2019/4/18.
//  Copyright © 2019年 qianfeng. All rights reserved.
//

#import "YPhotoTableViewCell.h"

@implementation YPhotoTableViewCell

- (void)creatUI{
    self.contentView.backgroundColor = RGB(0xf5f7fb);
    UIView * bjView = [[UIView alloc]init];
    bjView.backgroundColor = [UIColor whiteColor];
//    [bjView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
    UIView *shadowView = [[UIView alloc]init];
    [self.contentView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    [self addShadowToView:shadowView withColor:[UIColor blackColor]];
    [shadowView addSubview:bjView];
    [bjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(shadowView);
    }];
    bjView.layer.masksToBounds = YES;
    bjView.layer.cornerRadius = 8;
    
    UIImageView * imageView = [[UIImageView alloc]init];
    _contentImage = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bjView addSubview:imageView];

    UILabel * titleLabel = [[UILabel alloc]init];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel = titleLabel;
    titleLabel.textColor = RGB(0x333333);
    [bjView addSubview:titleLabel];
    
    UILabel * authorLabel = [[UILabel alloc]init];
    authorLabel.text = @"张三";
    authorLabel.font = [UIFont systemFontOfSize:12];
    self.authorLabel = authorLabel;
    authorLabel.textColor = RGB(0x999999);
    [bjView addSubview:authorLabel];
    
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"4月15日";
    timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel = timeLabel;
    timeLabel.textColor = RGB(0x999999);
    [bjView addSubview:timeLabel];
    
    UILabel * photoNumLabel = [[UILabel alloc]init];
    photoNumLabel.textAlignment = NSTextAlignmentCenter;
    photoNumLabel.text = @"8张";
    photoNumLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.80];
    photoNumLabel.font = [UIFont systemFontOfSize:14];
    self.photoNumLabel = photoNumLabel;
    photoNumLabel.textColor = [UIColor whiteColor];
    [bjView addSubview:photoNumLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bjView);
        make.left.equalTo(bjView.mas_left);
        make.right.equalTo(bjView.mas_right);
        make.height.equalTo(@180);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.left.equalTo(imageView.mas_left).offset(8);
        make.right.equalTo(imageView.mas_right).offset(-8);
    }];
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.left.equalTo(titleLabel.mas_left);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(authorLabel.mas_centerY);
        make.left.equalTo(authorLabel.mas_right).offset(8);
    }];
    [photoNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom).offset(-20);
        make.height.equalTo(@20);
        make.width.equalTo(@35);
        make.right.equalTo(imageView.mas_right).offset(-15);
    }];
    photoNumLabel.layer.masksToBounds = YES;
    photoNumLabel.layer.cornerRadius = 4.0;
    
}
/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.1;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 4;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        
    }
    return self;
}
- (void)loadData:(NSDictionary *)data{
    self.data = data;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:data[@"imgurl"]]];
    self.titleLabel.text = data[@"shorttitle"];
    NSArray * photoArr = data[@"imgList"];
    self.photoNumLabel.text = [NSString stringWithFormat:@"%lu张",(unsigned long)photoArr.count];
    self.authorLabel.text = data[@"authorName"];
    NSString * timeStr = data[@"newstime"];
    self.timeLabel.text = [self getTimeFromTimestamp:timeStr.doubleValue];

}
#pragma mark ---- 将时间戳转换成时间

- (NSString *)getTimeFromTimestamp:(double)time{

    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];

    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =   [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self creatUI];
    return  self;
}

@end
