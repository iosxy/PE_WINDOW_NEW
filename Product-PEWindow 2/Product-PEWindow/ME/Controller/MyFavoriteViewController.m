//
//  MyFavoriteViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/27.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "YCHDataBaseManager.h"
#import "MyFavoriteCell.h"
#import "GameHotModel.h"
#import "HotGameDetail.h"
@interface MyFavoriteViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 表格*/
@property(nonatomic,strong)UITableView * tableView;
/** 疏忽元*/
@property(nonatomic,strong)NSMutableArray * dataSource;
/** manager*/
@property(nonatomic,strong) YCHDataBaseManager * manager;
@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc]init];
    self.title = @"我的收藏";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(click:)];
    [self loadData];
    [self createTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)click:(UIBarButtonItem *)item
{
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
- (void)loadData
{
    _manager = [YCHDataBaseManager sharedManager];
    NSArray * models = [_manager findAll];
    [self.dataSource addObjectsFromArray:models];
    
}
- (void)createTableView
{
    
    UITableView * table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"MyFavoriteCell" bundle:nil] forCellReuseIdentifier:@"MYCELL"];
    table.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableBack.jpg"]];
    [self.view addSubview:table];
    self.tableView = table;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFavoriteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL"];
    GameHotModel * model = self.dataSource[indexPath.row];
    cell.homeName.text = model.homeName;
    cell.homeSocre.text = model.homeScore;
    cell.guestName.text = model.guestName;
    cell.guestSocre.text = model.guestScore;
    cell.startTime.text = model.startTime;
    [cell.HomeLogo sd_setImageWithURL:[NSURL URLWithString:model.homePicUrl]];
    [cell.GuestLogo sd_setImageWithURL:[NSURL URLWithString:model.guestPicUrl]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GameHotModel * model = self.dataSource[indexPath.row];
    HotGameDetail * vc = [[HotGameDetail alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除相关

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

        // 删除一条Cell
        //1.删除数据库
        // NSLog(@"%@",[self.dataSource[indexPath.row] num_iid]);
    GameHotModel * model = self.dataSource[indexPath.row];
        [self.manager deleteFavorite:model.ID];
        //2.删除数据源
        [self.dataSource removeObjectAtIndex:indexPath.row];
        //3.删除视图
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
     }

@end
