//
//  CartViewController.m
//  DiscountStore
//
//  Created by qianfeng on 16/4/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "CartViewController.h"
#import "YXYDatabaseManager.h"
#import "HomeDetailModel.h"
#import "PayTableViewCell.h"
#import "SecondViewController.h"
#import "YXYTabbarController.h"
#import "AppDelegate.h"


@interface CartViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataSource;
/** 数据库管理 */
@property (nonatomic,strong) YXYDatabaseManager * manager;


@end

@implementation CartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    YXYTabbarController * con = (YXYTabbarController *)delegate.window.rootViewController;
    UINavigationController * nav =  con.viewControllers[2];
    UINavigationController * nav1 =  con.viewControllers[3];
    nav1.tabBarItem.badgeValue = nil;
    nav.tabBarItem.badgeValue = nil;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [YXYDatabaseManager sharedManager];
    
    //self.navigationController.navigationBar.translucent = NO;
    
    //设置导航栏透明操作
    UIImage * image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    [self loadData];
    
    [self createTableView];
    
    [self addDropUpRefresh];

    [self setupNavigationItem];
}

- (void)addDropUpRefresh
{
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self.dataSource removeAllObjects];
        [self loadData];
        [self.tableView reloadData];
    }];
    //设置动态图片
    NSArray * imageArray = @[[UIImage imageNamed:@"icon_loading_action1"],[UIImage imageNamed:@"icon_loading_action2"]];
    [header setImages:imageArray forState:MJRefreshStateRefreshing];
    self.tableView.header = header;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建视图
    UITableView * table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 120;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = table;
    [self.tableView registerNib:[UINib nibWithNibName:@"PayTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAY"];
    [self.view addSubview:self.tableView];
}

- (void)loadData
{
    //加载数据
    [self.dataSource removeAllObjects];
    
    NSArray * arr1 = [_manager findAllWithTableName:@"cart"];
    
    for (HomeDetailModel * model in arr1) {
        [self.dataSource addObject:model];
    }
    if (self.dataSource.count != 0) {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    }
    else
    {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    }
    [self.tableView reloadData];
    //去除下拉刷新控件
    
    [self.tableView.header endRefreshing];

}


#pragma mark - 编辑模式
- (void)setupNavigationItem {
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(itemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)itemClicked:(UIBarButtonItem *)item {
    // 切换表格视图的状态
    // 获取表格视图是否处于编辑状态
    BOOL isEditing = _tableView.isEditing;
    if (isEditing == YES) {
        // 结束编辑状态
        [_tableView setEditing:NO animated:YES];
        item.title = @"编辑";
    }else {
        // 切换为编辑状态
        [_tableView setEditing:YES animated:YES];
        item.title = @"完成";
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.删除数据库
    // NSLog(@"%@",[self.dataSource[indexPath.row] num_iid]);
    [self.manager deleteFavoriteWithTableName:@"cart" andnum_iid:[self.dataSource[indexPath.row] num_iid]];
    //2.删除数据源
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //3.删除视图
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    if (self.dataSource.count != 0) {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    }
    else
    {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    }
    
}


#pragma mark - 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PAY" forIndexPath:indexPath];
    
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController * second = [[SecondViewController alloc]init];
    
    HomeDetailModel * model = self.dataSource[indexPath.row];
    second.model = model;
    second.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:second animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

@end
