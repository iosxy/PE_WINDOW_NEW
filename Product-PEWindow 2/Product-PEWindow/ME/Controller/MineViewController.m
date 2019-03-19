//
//  MineViewController.m
//  DiscountStore
//
//  Created by qianfeng on 16/4/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "MineViewController.h"
#import "MainDetailVC.h"
#import "MineTableViewCell.h"
#import "LoginViewController.h"
#import "MyFavoriteViewController.h"
@interface MineViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
/**顶部图片 */
@property(nonatomic,strong)UIImageView* topImageView;
/**跟随线条 */
@property(nonatomic,strong)UIView* line;
/**数据源 */
@property(nonatomic,strong)NSMutableArray* dataSource;

@property (nonatomic,weak) UIButton * currentButton;

/** 头像 */
@property (nonatomic,strong) UIButton * photoImageView;


@end

@implementation MineViewController


- (void)viewWillAppear:(BOOL)animated
{

    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"isLogin"]isEqualToString:@"isLogin"]) {
        _isLogin = YES;
    }else{
        _isLogin = NO;
    }
    
    if (_isLogin == NO) {
        [_photoImageView setTitle:@"请先登录" forState:UIControlStateNormal];
        [_photoImageView setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
        _photoImageView.enabled = YES;
    }else
    {
        [_photoImageView setTitle:@"" forState:UIControlStateNormal];
        _photoImageView.enabled = NO;
        [_photoImageView setBackgroundImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
        _photoImageView.adjustsImageWhenDisabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self buildUI];
    [self loadData];
    
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)buildUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    //去除间隔线
   // _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    _tableView.contentInset//额外的滑动区域
    _tableView.contentInset = UIEdgeInsetsMake(190, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //xcode6.3 Label 自适应cell高度问题 需要添加额外设置
    //允许自适应操作
    _tableView.rowHeight = UITableViewAutomaticDimension;
    //设置预计行高
    _tableView.rowHeight = 60.0;
   
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MINE"];
    
    [self.view addSubview:_tableView];
    //创建顶部视图
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -140, self.view.width,140)];
   _topImageView.backgroundColor = YCOLOR_BROWNCOLOR;
    _topImageView.image = [UIImage imageNamed:@"backImg.jpg"];
    //addsubview的方式加入到tableView上
    [_tableView addSubview:_topImageView];
    _photoImageView = [[UIButton alloc]init];
   
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"isLogin"]isEqualToString:@"isLogin"]) {
        _isLogin = YES;
    }else{
        _isLogin = NO;
    }
    
    if (_isLogin == NO) {
         [_photoImageView setTitle:@"请先登录" forState:UIControlStateNormal];
        _photoImageView.enabled = YES;
    }else
    {
        [_photoImageView setTitle:@"" forState:UIControlStateNormal];
        _photoImageView.enabled = NO;
        [_photoImageView setBackgroundImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
    }
   
    [_photoImageView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_photoImageView addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _photoImageView.backgroundColor = [UIColor whiteColor];
    _photoImageView.layer.cornerRadius = 40;
    _photoImageView.clipsToBounds = YES;
    _photoImageView.size = CGSizeMake(80, 80);
    _photoImageView.center = _topImageView.center;
    //[_topImageView addSubview:_photoImageView];
    [_tableView addSubview:_photoImageView];
    
}

- (void)loginClicked:(UIButton *)button
{
    LoginViewController * vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)buttonClicked:(UIButton *)button{
    //切换描述(int)button.tag - 500;
    _currentButton = button;
    [_currentButton setTintColor:[UIColor lightGrayColor]];
}
- (void)loadData
{
    
    NSArray * array = @[@[
                            @{@"title":@"我的收藏",@"icon":@"收藏"},
                            @{@"title":@"搜索",@"icon":@"search2"}
                          ],
                        @[
                            @{@"title":@"联系客服",@"icon":@"kefu"},
                            @{@"title":@"用户协议",@"icon":@"协议管理"},
                            @{@"title":@"意见反馈",@"icon":@"意见反馈"},
                            @{@"title":@"设置",@"icon":@"设置"}
                            ]
                          ];
    
    [_dataSource setArray:array];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MINE" forIndexPath:indexPath];
    
    [cell loadDataWithDictionary:_dataSource[indexPath.section][indexPath.row]];
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    float offset = scrollView.contentOffset.y;
    if (offset < -150) {
        //1.图片的顶部始终顶在屏幕上方(图片的顶点左边不断的在减小,减小的大小为上方留白)
        CGRect rect = _topImageView.frame;
        rect.origin.y = offset;
        //2.图片的高度随下拉而增大
        rect.size.height = -offset;
        //更改图片显示模式 无论如何缩放,显示比例不变
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.clipsToBounds = YES;
        //重置图片的坐标
        _topImageView.frame = rect;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
  if (indexPath.section == 0 && indexPath.row == 0) {
        //进入收藏
       if (_isLogin == NO) {
           [SVProgressHUD showSuccessWithStatus:@"请先登录"];
           return;
       }
        MyFavoriteViewController * vc = [[MyFavoriteViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    else if (indexPath.section == 0 && indexPath.row == 1) {
        //进入帖子
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"搜索";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        //进入客服
        if (_isLogin == NO) {
            [SVProgressHUD showSuccessWithStatus:@"请先登录"];
            return;
        }
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"客服";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        //进入设置
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"设置";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        //用户协议
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"用户协议";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        //意见反馈
        if (_isLogin == NO) {
            [SVProgressHUD showSuccessWithStatus:@"请先登录"];
            return;
        }
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"意见反馈";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
 
    
    
}




@end
