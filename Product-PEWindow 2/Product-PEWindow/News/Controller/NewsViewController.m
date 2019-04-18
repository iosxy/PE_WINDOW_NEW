//
//  NewsViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/18.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsModel.h"
#import "YCHTwoTableViewCell.h"
#import "YCHThreeTableViewCell.h"
#import "YCHFourTableViewCell.h"
#import "CommentDetailVC.h"
#import "ADScrollView.h"
#import "DetailVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * scrollSource;
/** 表格视图*/
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)ADScrollView * adSC;
/** 当前新闻*/
@property(nonatomic,assign)int currentNew;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self refreshData];
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
 
//    AVPlayerViewController * vc = [[AVPlayerViewController alloc]init];
//    vc.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:@"https://vod.ttplus.cn/product/act-ss-m3u8-hd/e859d3d3e82e4a5586ebc8d61932ac33/video_news_229316.m3u8"]];
//    [self presentViewController:vc animated:true completion:nil];

}
- (void)loadData
{
    
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    //在网络数据未请求到的时候，提示正在加载中
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:YNEWS_RUL,_currentNew] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (!error) {
            if (_currentNew == 0) {
                [self.dataSource removeAllObjects];
            }
            //YCHNetworking 是基于AFNetworking进行二次封装的数据请求类
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            //讲二进制数据转化为字典
        NSArray * dataArr = dic[@"results"];
       NSArray * result = [NSArray modelArrayWithClass:[NewsModel class] json:dataArr];
            //通过YYModel对模型进行整体赋值
            NSMutableArray * mutaleResult = [NSMutableArray arrayWithArray:result];
            for (int i = 0; i < mutaleResult.count; i++) {
                NewsModel * model =[[NewsModel alloc]init];
                model = mutaleResult[i];
            }
            [_dataSource addObjectsFromArray:mutaleResult];
            //加载到数据源中
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
          [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            //提示加载成功
        }else
        {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            //提示加载失败
        }
    }];
}
- (void)initData
{
    _dataSource = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    //上拉加载
    
    
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //
    [_tableView registerNib:[UINib nibWithNibName:@"YCHTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"TWO"];
    
      [_tableView registerNib:[UINib nibWithNibName:@"YCHFourTableViewCell" bundle:nil] forCellReuseIdentifier:@"FOUR"];
    [self.view addSubview:_tableView];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    ADScrollView * sc = [[ADScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180)];
    self.adSC = sc;
    UITapGestureRecognizer* single = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognizer:)];
    single.numberOfTapsRequired = 1;
    [self.adSC addGestureRecognizer:single];
    [self loadScrollData];
    [self.adSC loadDataWithArray:@[@"NBA.jpg", @"世界杯.jpg", @"篮球.jpg", @"中国足球.jpg"]];
    _tableView.tableHeaderView = sc;
    
    
}
- (void)loadScrollData{
    self.scrollSource = [NSMutableArray new];
    NSArray * titleArr = @[@"NBA",@"天下足球",@"中国篮球",@"中国足球"];
    NSArray * logoArr = @[@"NBA.jpg",@"FootBall.jpg",@"chinaFoot.jpeg",@"china.png"];
    NSArray * circleId = @[@"13",@"446",@"15",@"440"];
    for (int i = 0; i < titleArr.count; i++) {
        MainModel * model = [[MainModel alloc]init];
        model.title = titleArr[i];
        model.logo = logoArr[i];
        model.circleId = circleId[i];
        [self.scrollSource addObject:model];
    }
}
- (void)singleTapRecognizer:(UIGestureRecognizer *)tap {
    NSUInteger currentPage = self.adSC.pageControl.currentPage;
    NSLog(@"%lu",(unsigned long)currentPage);
    DetailVC * vc = [[DetailVC alloc]init];
    vc.model = self.scrollSource[currentPage];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadMoreData
{
    _currentNew += 20;
  //  NSLog(@"%d",_currentNew);
    [self loadData];
  
}

#pragma mark - 代理相关

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;//返回行数
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NewsModel * model = _dataSource[indexPath.row];
   //对Cell的类型进行判断，返回为不同的Cell
    if (indexPath.row % 5 == 1) {
        YCHFourTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FOUR" forIndexPath:indexPath];
        cell.nameLabel.text = model.name;
        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.coverUrl]];
        
        return cell;
    }else {
        YCHTwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TWO" forIndexPath:indexPath];
        cell.descriptLabel.text = model.descript;
        cell.nameLabel.text = model.name;
        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.coverUrl]];
        
        return cell;
    }
//    if ([model.displayMode isEqualToString:@"2"]) {
//
//
//    }else{
//
//    }
    
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NewsModel * model = self.dataSource[indexPath.row];
    CommentDetailVC * vc = [[CommentDetailVC alloc]init];
    vc.contentId = model.contentId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NewsModel * model = _dataSource[indexPath.row];
    if (indexPath.row % 5 == 1) {
        return 250;
    }
    return 140;
}

- (void)refreshData
{
    [self loadData];
    if ( _tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
    }
//      _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

@end
