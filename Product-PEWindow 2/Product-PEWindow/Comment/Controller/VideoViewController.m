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
@property(nonatomic,strong)NSMutableArray * deleteDataSource;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _deleteDataSource = [NSMutableArray array];
    _dataSource = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    AdjustsScrollViewInsetNever(self, self.tableView);

    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.rowHeight = 240;
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
        for (NSDictionary * obj in self.deleteDataSource) {
            if  ([_dataSource containsObject:obj]) {
                [_dataSource removeObject:obj];
            }
        }
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
        
        for (NSDictionary * obj in self.deleteDataSource) {
            if  ([_dataSource containsObject:obj]) {
                [_dataSource removeObject:obj];
            }
        }
        
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    }];
    
}

- (void)jubao {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择举报内容" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *skipAction = [UIAlertAction actionWithTitle:@"色情相关" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会24小时内核实并处理!"];
    }];
    UIAlertAction *skipAction2 = [UIAlertAction actionWithTitle:@"资料不当" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会24小时内核实并处理!"];
    }];
    UIAlertAction *skipAction3 = [UIAlertAction actionWithTitle:@"违法内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会24小时内核实并处理!"];
    }];
    UIAlertAction *skipAction4 = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会24小时内核实并处理!"];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:skipAction];
    [alertController addAction:skipAction2];
    [alertController addAction:skipAction3];
    [alertController addAction:skipAction4];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)delete:(UIButton *) button{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定屏蔽该条视频吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *skipAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.deleteDataSource addObject:self.dataSource[button.tag]];
        [self.dataSource removeObjectAtIndex:button.tag];
        [self.tableView reloadData];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:skipAction];
    [self presentViewController:alertController animated:YES completion:nil];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.reportButton addTarget:self action:@selector(jubao) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = indexPath.row;
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
