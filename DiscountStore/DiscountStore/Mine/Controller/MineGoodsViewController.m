//
//  MineGoodsViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/18.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "MineGoodsViewController.h"
#import "YXYDatabaseManager.h"
#import "HomeDetailModel.h"
#import "SecondViewController.h"
#import "HomeTableViewCell.h"
#import "HomeDetailModel.h"

@interface MineGoodsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataSource;


@end

@implementation MineGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = self.myTitle;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self loadData];
    
    [self createTableView];
    
    
}

#pragma mark - lazyLoad
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


- (void)createTableView
{
    UITableView * table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [table registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HOMETABLECELL"];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 120;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tableView = table;
    
    
}

- (void)loadData
{
    YXYDatabaseManager * manager = [YXYDatabaseManager sharedManager];
    
    NSArray * resultsArr = [manager findAllWithTableName:@"favorite"];
    
    [self.dataSource setArray:resultsArr];
}

#pragma mark - 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HOMETABLECELL" forIndexPath:indexPath];
    
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //已经选中某一行
    SecondViewController *  second = [[SecondViewController alloc]init];
    second.hidesBottomBarWhenPushed = YES;
    second.model = self.dataSource[indexPath.row];
    
    [self.navigationController pushViewController:second animated:YES];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}





@end
