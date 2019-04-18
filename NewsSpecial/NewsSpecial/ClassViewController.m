//
//  ClassViewController.m
//  weiliao
//
//  Created by 游成虎 on 16/11/2.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "ClassViewController.h"

#define YNEWS_RUL @"http://u1.tiyufeng.com/section/content_list?portalId=15&start=%d&id=351&limit=20&clientToken=7c98ddd1d8cb729bf66791a192b43748"
@interface ClassViewController ()
/** 当前新闻*/
@property(nonatomic,assign)int currentNew;
@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}
- (void)loadData
{
    [self.view gifShowLoadingMeg:@"加载中"];
    //在网络数据未请求到的时候，提示正在加载中
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:YNEWS_RUL,_currentNew] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (!error) {
            if (_currentNew == 0) {
                [self.dataList removeAllObjects];
            }
            //YCHNetworking 是基于AFNetworking进行二次封装的数据请求类
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            //讲二进制数据转化为字典
            NSArray * dataArr = dic[@"results"];
//            NSArray * result = [NSArray modelArrayWithClass:[NewsModel class] json:dataArr];
            //通过YYModel对模型进行整体赋值
//            NSMutableArray * mutaleResult = [NSMutableArray arrayWithArray:result];
//            for (int i = 0; i < mutaleResult.count; i++) {
////                NewsModel * model =[[NewsModel alloc]init];
////                model = mutaleResult[i];
//            }
//            [self.dataList addObjectsFromArray:mutaleResult];
            //加载到数据源中
            [self.tableView reloadData];
            [self.view hideLoading];
        }else{
            [self.view hideLoading];
        }
    }];
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
