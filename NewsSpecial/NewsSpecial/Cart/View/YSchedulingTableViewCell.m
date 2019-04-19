//
//  YSchedulingTableViewCell.m
//  NewsSpecial
//
//  Created by 游成虎 on 2019/4/19.
//  Copyright © 2019年 GetOn. All rights reserved.
//

#import "YSchedulingTableViewCell.h"

@implementation YSchedulingTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        
    }
    return self;
}
- (void)creatUI{
    self.contentView.backgroundColor = RGB(0xf5f7fb);
    
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"4月15日";
    timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel = timeLabel;
    self.timeLabel.numberOfLines = 0;
    timeLabel.textColor = RGB(0x999999);
    [self.contentView addSubview:timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = MainColor;
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(60);
        make.width.equalTo(@1);
    }];
    
    UIView * bjView = [[UIView alloc]init];
    self.bjView = bjView;
    [self.contentView addSubview:bjView];
    bjView.backgroundColor = [UIColor whiteColor];
    [bjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.lineView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    bjView.layer.masksToBounds = YES;
    bjView.layer.cornerRadius = 8;
    
    UIImageView * imageView = [[UIImageView alloc]init];
    _contentImage = imageView;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [bjView addSubview:imageView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel = titleLabel;
    titleLabel.textColor = RGB(0x333333);
    titleLabel.numberOfLines = 0;
    [bjView addSubview:titleLabel];
    
    UILabel * authorLabel = [[UILabel alloc]init];
    authorLabel.text = @"";
    authorLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel = authorLabel;
    authorLabel.textColor = RGB(0x999999);
    [bjView addSubview:authorLabel];

    [self setUpConstrains];
}
- (void)setUpConstrains {
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjView);
        make.right.equalTo(self.bjView.mas_right);
        make.bottom.equalTo(self.bjView);
        make.height.equalTo(@100);
        make.width.equalTo(@100);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjView).offset(10);
        make.left.equalTo(self.bjView.mas_left).offset(10);
        make.right.equalTo(self.contentImage.mas_left).offset(-10);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.bjView.mas_left).offset(10);
        make.bottom.equalTo(self.bjView.mas_bottom).offset(-10);
    }];
    
}
- (void)loadData:(NSDictionary *)data{
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YW_URL_IMAGE,data[@"background"][@"url"]]]];
    self.titleLabel.text = data[@"title"];
    self.addressLabel.text = data[@"address"];
    NSMutableString * timeStr = [NSMutableString stringWithFormat:@"%@",data[@"dateStr"]];
//    self.timeLabel.text = [self getTimeFromTimestamp:timeStr.doubleValue];
    self.timeLabel.text = timeStr;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
