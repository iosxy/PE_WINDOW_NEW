//
//  ClassViewController.m
//  weiliao
//
//  Created by 游成虎 on 16/11/2.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "ClassViewController.h"
#import "YPhotoTableViewCell.h"
#import "YLittlePhotoTableViewCell.h"
#import "MJRefresh.h"

#define YNEWS_RUL @"http://ywapp.hryouxi.com/yuwanapi/app/listEveryDayStarNews"
@interface ClassViewController ()
/** 当前新闻*/
@property(nonatomic,assign)NSString * currentNew;
@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self.tableView registerClass:[YPhotoTableViewCell class] forCellReuseIdentifier:@"YPhotoTableViewCell"];
    [self.tableView registerClass:[YLittlePhotoTableViewCell class] forCellReuseIdentifier:@"YLittlePhotoTableViewCell"];
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
    [YCHNetworking postStartRequestFromUrl:[NSString stringWithFormat:YNEWS_RUL] andParamter:@{@"pageSize":@"10",@"pageNo":self.currentNew, @"userId" : @""} returnData:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            NSArray * dataArr = dic[@"data"][@"starNewsList"][@"list"];
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
    [YCHNetworking postStartRequestFromUrl:[NSString stringWithFormat:YNEWS_RUL] andParamter:@{@"pageSize":@"10",@"pageNo":self.currentNew, @"userId" : @""} returnData:^(NSData *data, NSError *error) {
        if (!error) {
            [self.dataList removeAllObjects];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            NSArray * dataArr = dic[@"data"][@"starNewsList"][@"list"];
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
    if ([data[@"cardType"] isEqualToString:@"BIG"]) {
        YPhotoTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"YPhotoTableViewCell"];
        [cell loadData:data];
        return  cell;
    }else {
         YLittlePhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YLittlePhotoTableViewCell"];
        [cell loadData:data];
        return  cell;
    }
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
