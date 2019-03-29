//
//  DetailVC.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "DetailVC.h"
#import "CommentModel.h"
#import "CommentACell.h"
#import "CommentDetailVC.h"
#define TITLE_URL @"http://u1.tiyufeng.com/v2/circle/detail?id=%@&portalId=15&clientToken=7c98ddd1d8cb729bf66791a192b43748"
#define COMMENT @"http://u1.tiyufeng.com/v2/post/circle_list?circleId=%@&start=%d&limit=15&sort=1&portalId=15&clientToken=7c98ddd1d8cb729bf66791a192b43748"
@interface DetailVC ()<UITableViewDataSource,UITableViewDelegate>
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,assign)int currentPage;
@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = self.model.title;
    self.dataSource = [[NSMutableArray alloc]init];
    // 设置返回按钮
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self setUI];
    [self loadData];
    [self buildTableView];
}

- (void)setUI
{
    _currentPage = 0;
    self.logo.image = [UIImage imageNamed:self.model.logo];
   // [self.logo sd_setImageWithURL:[NSURL URLWithString:self.model.logo]];
    self.logo.layer.cornerRadius = 55;
    self.logo.clipsToBounds = YES;
    self.titleLabel.text = self.model.title;
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:TITLE_URL,self.model.circleId] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSString * bgPicUrl = dic[@"data"][@"bgPicUrl"];
        NSString * descript = dic[@"data"][@"description"];
        NSString * followCount =dic[@"data"][@"followCount"];
        self.descript.text = descript;
        self.descript.textColor = [UIColor whiteColor];
        self.favorite.text = [NSString stringWithFormat:@"关注:%@人",followCount];
        self.favorite.textColor = [UIColor whiteColor];
        [self.backView sd_setImageWithURL:[NSURL URLWithString:bgPicUrl]];
       // self.tableView.tableHeaderView = self.backView;
    }];
}
- (void)loadData
{
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:COMMENT,self.model.circleId,_currentPage] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * result = resultDic[@"results"];
        NSArray * models = [NSArray modelArrayWithClass:[CommentModel class] json:result];
        [self.dataSource addObjectsFromArray:models];
      //  NSLog(@"%@",self.dataSource);
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)buildTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentACell" bundle:nil] forCellReuseIdentifier:@"ACELL"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        _currentPage += 15;
        [self loadData];
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{//NSLog(@"%@",self.dataSource);
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel * model = self.dataSource[indexPath.row];
    CommentACell * cell = [tableView dequeueReusableCellWithIdentifier:@"ACELL"];
    cell.title.text = model.title;
    cell.nickName.text = model.nickName;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg]];
    if (model.picList.count != 0) {
          [cell.picList sd_setImageWithURL:[NSURL URLWithString:model.picList[0]]];
    }
  
    cell.upTime.text = model.updateTime;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 283;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CommentModel * model = self.dataSource[indexPath.row];
    CommentDetailVC * vc = [[CommentDetailVC alloc]init];
    vc.model= model;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
