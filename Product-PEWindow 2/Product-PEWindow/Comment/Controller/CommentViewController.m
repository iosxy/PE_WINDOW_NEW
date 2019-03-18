//
//  CommentViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/18.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "CommentViewController.h"
#import "MainModel.h"
#import "MainCell.h"
#import "DetailVC.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;
/** tableView*/
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self loadData];
    [self createTableView];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
}
- (void)initData
{
    self.dataSource = [[NSMutableArray alloc]init];
}
- (void)loadData
{
    NSArray * titleArr = @[@"NBA",@"天下足球",@"中国篮球",@"中国足球"];
    NSArray * logoArr = @[@"NBA.jpg",@"FootBall.jpg",@"chinaFoot.jpeg",@"china.png"];
    NSArray * circleId = @[@"13",@"446",@"15",@"440"];
    for (int i = 0; i < titleArr.count; i++) {
        MainModel * model = [[MainModel alloc]init];
        model.title = titleArr[i];
        model.logo = logoArr[i];
        model.circleId = circleId[i];
        [self.dataSource addObject:model];
    }

}
- (void)createTableView
{
    
    UITableView * table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil] forCellReuseIdentifier:@"MainCell"];
    self.tableView  =table;
    [self.view addSubview:table];
    
}
#pragma mark - tableView相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    MainModel * model = self.dataSource[indexPath.row];
    cell.logoImageView.image = [UIImage imageNamed:model.logo];
    cell.logoImageView.layer.cornerRadius = 40;
    cell.logoImageView.clipsToBounds = YES;
    cell.titleLabel.text = model.title;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailVC * vc = [[DetailVC alloc]init];
  vc.model = self.dataSource[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
