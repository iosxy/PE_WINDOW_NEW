//
//  PayViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/26.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "PayViewController.h"
#import "YXYScrollPages.h"
#import "MineGoodsViewController.h"
#import "YXYDatabaseManager.h"
#import "PayTableViewCell.h"
#import "SecondViewController.h"
#import "HomeDetailModel.h"
#import "AppDelegate.h"
#import "YXYTabbarController.h"

@interface PayViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataSource;

/** 滚动页 */
@property (nonatomic,strong) YXYScrollPages * scrollPages;

/** 内存缓存 */
@property (nonatomic,strong) NSMutableDictionary * viewControllers;

/** 数据库管理 */
@property (nonatomic,strong) YXYDatabaseManager * manager;

/** 当前滚动视图 */
@property (nonatomic,strong) UIScrollView * currentScrollView;
/** 当前页 */
@property (nonatomic,assign) NSUInteger currentIndex;


@end

@implementation PayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    YXYTabbarController * con = (YXYTabbarController *)delegate.window.rootViewController;
    UINavigationController * nav =  con.viewControllers[2];
    nav.tabBarItem.badgeValue = nil;
    UINavigationController * nav1 =  con.viewControllers[3];
    nav1.tabBarItem.badgeValue = nil;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [YXYDatabaseManager sharedManager];
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    [self createUI];
    
    [self addDropUpRefresh];
    

    
}

- (void)addDropUpRefresh
{
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
      
        [self.dataSource removeAllObjects];
        [self loadScrollView];
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
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(self.currentIndex * self.currentScrollView.width, 0, self.currentScrollView.width, self.currentScrollView.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 120;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    table.tag = 234 + self.currentIndex;
    self.tableView = table;
    
}

- (void)loadScrollView
{
    switch (self.currentIndex) {
        case 0:
        {
            //清空数据源
            [self.dataSource removeAllObjects];
            
                //创建视图
                [self createTableView];
                [self.tableView registerNib:[UINib nibWithNibName:@"PayTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAY"];
                
                [self.currentScrollView addSubview:self.tableView];
            
            //加载数据
            NSMutableArray * arr = (NSMutableArray *)[_manager findAllWithTableName:@"cart"];
            NSMutableArray * arr1 = (NSMutableArray *)[_manager findAllWithTableName:@"pay"];
            for (int i = 0 ;i < arr.count; i++) {
                [self.dataSource addObject:arr[i]];
                
                for (int j = 0; j < arr1.count; j++) {
                    if ([[arr1[j] num_iid] isEqualToString:[arr[i] num_iid]]) {
                        [arr1 removeObjectAtIndex:j];
                    }
                }
            }
            
            [self.dataSource addObjectsFromArray:arr1];
            
            if (self.dataSource.count != 0) {
                self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
            }
            else
            {
                self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
            }
            [self.tableView reloadData];
            
            
        }
            break;
        case 1:
        {
            //清空数据源
            [self.dataSource removeAllObjects];
           
            [self setupNavigationItem];
                //创建视图
                [self createTableView];
                [self.tableView registerNib:[UINib nibWithNibName:@"PayTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAY"];
                
                [self.currentScrollView addSubview:self.tableView];
            
            //加载数据
            NSArray * arr = [_manager findAllWithTableName:@"cart"];
            for (HomeDetailModel * model in arr) {
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
            
            
        }
            break;
        case 2:
        {
            [self setupNavigationItem];
                //清空数据源
                [self.dataSource removeAllObjects];
                //创建视图
                [self createTableView];
                [self.tableView registerNib:[UINib nibWithNibName:@"PayTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAY"];
                
                [self.currentScrollView addSubview:self.tableView];
                
           
            //加载数据
            NSArray * arr1 = [_manager findAllWithTableName:@"pay"];
            
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
            
        }
            break;
        case 3:
        {
            [self setupNavigationItem];
            
                //清空数据源
                [self.dataSource removeAllObjects];
                //创建视图
                [self createTableView];
                [self.tableView registerNib:[UINib nibWithNibName:@"PayTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAY"];
                
                [self.currentScrollView addSubview:self.tableView];
           
            //加载数据
            NSArray * arr1 = [_manager findAllWithTableName:@"pay"];
            
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
        }
            break;
        case 4:
        {
            [self setupNavigationItem];
                //清空数据源
                [self.dataSource removeAllObjects];
                //创建视图
                [self createTableView];
                [self.tableView registerNib:[UINib nibWithNibName:@"PayTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAY"];
                
                [self.currentScrollView addSubview:self.tableView];
                
           
            //加载数据
            NSArray * arr1 = [_manager findAllWithTableName:@"pay"];
            
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
            
        }
            break;
        default:
            
            break;

    }
    //去除下拉刷新控件
    [self.tableView.header endRefreshing];
    
}

- (void)createUI
{
    self.scrollPages = [[YXYScrollPages alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andTitles:@[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"] andCallBack:^(UIScrollView *scrollView, NSUInteger index) {
        self.currentScrollView = scrollView;
        self.currentIndex = index;
        [self loadScrollView];
    }];
    [self.view addSubview:self.scrollPages];
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
    if (tableView.tag == 235) {
        // 删除一条Cell
        //1.删除数据库
       // NSLog(@"%@",[self.dataSource[indexPath.row] num_iid]);
        [self.manager deleteFavoriteWithTableName:@"cart" andnum_iid:[self.dataSource[indexPath.row] num_iid]];
        //2.删除数据源
        [self.dataSource removeObjectAtIndex:indexPath.row];
        //3.删除视图
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self loadScrollView];
    }
    else if(tableView.tag == 236 || tableView.tag == 237 || tableView.tag == 238)
    {
        //1.删除数据库
        // NSLog(@"%@",[self.dataSource[indexPath.row] num_iid]);
        [self.manager deleteFavoriteWithTableName:@"pay" andnum_iid:[self.dataSource[indexPath.row] num_iid]];
        //2.删除数据源
        [self.dataSource removeObjectAtIndex:indexPath.row];
        //3.删除视图
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self loadScrollView];
    }
    else
    {
        
    }
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
    return 104;
}

@end
