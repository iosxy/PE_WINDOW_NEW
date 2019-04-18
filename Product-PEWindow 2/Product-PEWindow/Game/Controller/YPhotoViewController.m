//
//  YPhotoViewController.m
//  Product-PEWindow
//
//  Created by 游成虎 on 2019/4/18.
//  Copyright © 2019年 qianfeng. All rights reserved.
//

#import "YPhotoViewController.h"
#import "YPhotoTableViewCell.h"
#import "YPhotoCommentViewController.h"

@interface YPhotoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation YPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    AdjustsScrollViewInsetNever(self, self.tableView);
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.rowHeight = 260;
    [_tableView registerClass:[YPhotoTableViewCell class] forCellReuseIdentifier:@"YPhotoTableViewCell"];
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    _tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    [_tableView reloadData];
    [self.view addSubview:_tableView];
    [self reloadData];
    
}
- (void)reloadData{
    
    [YCHNetworking startRequestFromUrl:@"http://api.ttplus.cn/list/pics?lastid=" andParamter:nil returnData:^(NSData *data, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:result[@"content"][@"list"]];
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    }];
    
}
- (void)loadMoreData{
    
    NSString * lastId = [self.dataSource lastObject][@"pid"];
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:@"http://api.ttplus.cn/list/pics?lastid=%@",lastId] andParamter:nil returnData:^(NSData *data, NSError *error) {
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
    
    YPhotoTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"YPhotoTableViewCell"];
    [cell loadData:self.dataSource[indexPath.row]];
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary * data = self.dataSource[indexPath.row];
    YPhotoCommentViewController * comment = [[YPhotoCommentViewController alloc]init];
    comment.hidesBottomBarWhenPushed = YES;
    comment.data = data;
    [self.navigationController pushViewController:comment animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
