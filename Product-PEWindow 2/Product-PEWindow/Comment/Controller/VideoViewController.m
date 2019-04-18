//
//  VideoViewController.m
//  Product-PEWindow
//
//  Created by 欢瑞世纪 on 2019/3/31.
//  Copyright © 2019 qianfeng. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "fabuViewController.h"
#import "VideoShared.h"
@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    _dataSource = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    AdjustsScrollViewInsetNever(self, self.tableView);

    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.rowHeight = 200;
    [_tableView registerClass:[VideoCell class] forCellReuseIdentifier:@"cell"];
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fabu"]  target:self action: @selector(fabu)];
    
    [_tableView reloadData];
    [self.view addSubview:_tableView];
    [self reloadData];
}

- (void)fabu{
    fabuViewController * vc = [[fabuViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc
                                    ];
    // [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)reloadData{
    
    [YCHNetworking startRequestFromUrl:@"http://api.ttplus.cn/list/video?lastid=" andParamter:nil returnData:^(NSData *data, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray: [VideoShared shared].videoArr];
        [self.dataSource addObjectsFromArray:result[@"content"][@"list"]];
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    }];
    
}
- (void)loadMoreData{
    NSString * lastId = [self.dataSource lastObject][@"pid"];
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:@"http://api.ttplus.cn/list/video?lastid=%@",lastId] andParamter:nil returnData:^(NSData *data, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        [self.dataSource addObjectsFromArray:result[@"content"][@"list"]];
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell loadData:self.dataSource[indexPath.row]];
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if ([self.dataSource[indexPath.row][@"type"]  isEqual: @"10086"]) {
        
        AVPlayerViewController * vc = [[AVPlayerViewController alloc]init];
        vc.player = [[AVPlayer alloc]initWithURL:self.dataSource[indexPath.row][@"videourl"] ];
        //  vc.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:url]];
        
        [vc.player play];
        [self.navigationController presentViewController:vc animated:true completion:^{
            
        }];
        
    }else {
        NSString * url = self.dataSource[indexPath.row][@"videourl"];
        
        AVPlayerViewController * vc = [[AVPlayerViewController alloc]init];
        vc.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:url]];
        //  vc.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:url]];
        
        
        [vc.player play];
        [self.navigationController presentViewController:vc animated:true completion:^{
            
        }];
    }
    
    
    
}

@end
