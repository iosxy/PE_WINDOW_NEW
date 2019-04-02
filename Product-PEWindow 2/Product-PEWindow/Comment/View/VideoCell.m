//
//  VideoCell.m
//  Product-PEWindow
//
//  Created by 欢瑞世纪 on 2019/3/31.
//  Copyright © 2019 qianfeng. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell()

@property(nonatomic,strong)UIImageView * contentImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)NSDictionary * data;
@end

@implementation VideoCell
- (void)creatUI{
    
    UIImageView * imageView = [[UIImageView alloc]init];
    _contentImage = imageView;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    _titleLabel = titleLabel;
    titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:titleLabel];
    
    UIImageView * play = [UIImageView new];
    play.image = [UIImage imageNamed:@"bofang"];
    [self.contentView addSubview:play];
    [play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    self.contentView.backgroundColor = UIColor.orangeColor;
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
    
    if (data[@"type"] == @"10086"){
        
        self.contentImage.image = data[@"cover"];
        self.titleLabel.text = data[@"title"];
        
        
    }else {
        
        [self.contentImage sd_setImageWithURL:[NSURL URLWithString:data[@"imgurl"]]];
        self.titleLabel.text = data[@"shorttitle"];
    }
    
   
    
    
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self =   [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self creatUI];
    return  self;
}
@end
