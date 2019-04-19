//
//  CartViewController.m
//  weiliao
//
//  Created by 游成虎 on 16/11/2.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "CartViewController.h"
#import "YSchedulingTableViewCell.h"

#define YLIST_RUL @"http://ywapp.hryouxi.com/yuwanapi/app/listCalendar"

@interface CartViewController ()
@property(nonatomic,assign)NSString * currentNew;
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self.tableView registerClass:[YSchedulingTableViewCell class] forCellReuseIdentifier:@"YSchedulingTableViewCell"];

    self.tableView.estimatedRowHeight = 260;
    self.tableView.header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.tableView.footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}
- (void)loadMoreData {
    self.currentNew = [NSString stringWithFormat:@"%d",self.currentNew.intValue + 1];
    [YCHNetworking postStartRequestFromUrl:[NSString stringWithFormat:YLIST_RUL] andParamter:@{@"pageSize":@"20",@"pageNo":self.currentNew, @"userId" : @"",@"type" : @"0"} returnData:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            NSArray * dataArr = dic[@"data"][@"catchList"][@"list"];
            [self.dataList addObjectsFromArray:dataArr];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
    }];
}
- (void)loadData
{
    _currentNew = @"1";
    [YCHNetworking postStartRequestFromUrl:[NSString stringWithFormat:YLIST_RUL] andParamter:@{@"pageSize":@"20",@"pageNo":self.currentNew, @"userId" : @"",@"type" : @"0"} returnData:^(NSData *data, NSError *error) {
        if (!error) {
            [self.dataList removeAllObjects];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            NSArray * dataArr = dic[@"data"][@"catchList"][@"list"];
            [self.dataList addObjectsFromArray:dataArr];
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.header endRefreshing];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = self.dataList[indexPath.row];
    YSchedulingTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"YSchedulingTableViewCell"];
    [cell loadData:data];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary * data = self.dataList[indexPath.row];
    //    YPhotoCommentViewController * comment = [[YPhotoCommentViewController alloc]init];
    //    comment.hidesBottomBarWhenPushed = YES;
    //    comment.data = data;
    //    [self.navigationController pushViewController:comment animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
