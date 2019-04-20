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
    
    UIView * reportView = [[UIView alloc]init];
    reportView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:reportView];
    [reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    _reportButton = [[UIButton alloc]init];
    [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [_reportButton setImage:[UIImage imageNamed:@"jubao-2"] forState:UIControlStateNormal];
    [_reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reportView addSubview:_reportButton];
    
    _deleteButton = [[UIButton alloc]init];
    [_deleteButton setTitle:@"屏蔽" forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"blacklist"] forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reportView addSubview:_deleteButton];
    
    [_reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(reportView);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(40);
     //   make.width.mas_equalTo(100);
    }];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(reportView);
        make.right.mas_equalTo(-12);
        
    }];
    
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
