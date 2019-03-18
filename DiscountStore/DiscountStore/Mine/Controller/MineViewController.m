//
//  MineViewController.m
//  DiscountStore
//
//  Created by qianfeng on 16/4/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "MineViewController.h"
#import "MineGoodsViewController.h"
#import "MineModel.h"
#import "MineTableViewCell.h"
#import "YXYDatabaseManager.h"
#import "PayViewController.h"
#import "AddressViewController.h"
#import "SettingViewController.h"
#import "CustomerViewController.h"
#import "SaleServiceViewController.h"
#import "HuancunViewController.h"

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
@property (nonatomic,strong) UIImageView * photoImageView;


@end

@implementation MineViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _currentButton.tintColor = [UIColor colorWithWhite:0.3 alpha:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc]init];
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
    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //xcode6.3 Label 自适应cell高度问题 需要添加额外设置
    //允许自适应操作
    _tableView.rowHeight = UITableViewAutomaticDimension;
    //设置预计行高
    _tableView.rowHeight = 44.0;
   
    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MINE"];
    
    [self.view addSubview:_tableView];
    //创建顶部视图
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -150, self.view.width, 150)];
    _topImageView.image = [UIImage imageNamed:@"top_bg~iphone"];
    //addsubview的方式加入到tableView上
    [_tableView addSubview:_topImageView];
    
    _photoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headimage1.jpg"]];
    
    _photoImageView.layer.cornerRadius = 40;
    _photoImageView.clipsToBounds = YES;
    
    _photoImageView.size = CGSizeMake(80, 80);
    _photoImageView.center = _topImageView.center;
    
    [_tableView addSubview:_photoImageView];
    
    NSArray * imageArr = @[@"daifukuan_btn~iphone",@"daifahuo_btn~iphone",@"daishouhuo_btn~iphone",@"yiwancheng_btn~iphone",@"yiguanbi~iphone"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0 ; i < imageArr.count; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateHighlighted];
        
        button.frame = CGRectMake(40 * i + ((self.view.width - 50 - 40 * 5) / 4) * i + 20, 10, 40, 40);
        
        if (i == imageArr.count - 1) {
            button.frame = CGRectMake(40 * i + ((self.view.width - 50 - 40 * 5) / 4) * i + 20, 10, 50, 40);
        }
        
        button.tintColor = [UIColor colorWithWhite:0.3 alpha:1];
       
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = 500 + i;
        [view addSubview:button];
        
    }
    _tableView.tableHeaderView = view;
    
//    /右上按钮
//    UIBarButtonItem * buyItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(buyClicked)];
//    self.navigationItem.rightBarButtonItem = buyItem;
//    
}
//- (void)buyClicked
//{
//    
//}



- (void)buttonClicked:(UIButton *)button{
    //切换描述(int)button.tag - 500;
    _currentButton = button;
    [_currentButton setTintColor:[UIColor lightGrayColor]];
    
    if (button.tag - 500 == 4) {
        SaleServiceViewController * sale = [[SaleServiceViewController alloc]init];
        [self.navigationController pushViewController:sale animated:YES];
    }
    else
    {
        PayViewController * pay = [[PayViewController alloc]init];
        
        [self.navigationController pushViewController:pay animated:YES];
        
    }
   
    
}
- (void)loadData
{
    
    NSArray * array = @[@[@{@"title":@"全部订单",@"icon":@"im_friends_shangjia~iphone"},
                          @{@"title":@"我的收藏",@"icon":@"im_friends_fensi~iphone"},
                          @{@"title":@"收货地址",@"icon":@"im_chat_location~iphone"}
                          ],
                        @[
                          @{@"title":@"客服",@"icon":@"im_customservice_icon~iphone"},
                          @{@"title":@"您的建议",@"icon":@"mine_account_blue~iphone"}, @{@"title":@"设置",@"icon":@"productsManagement~iphone"}
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
        //进入全部订单
        PayViewController * pay = [[PayViewController alloc]init];
        
        [self.navigationController pushViewController:pay animated:YES];
    }
    
    else if (indexPath.section == 0 && indexPath.row == 1) {
        //进入我的收藏
        
        MineGoodsViewController * mine = [[MineGoodsViewController alloc]init];
        
        mine.myTitle = self.dataSource[indexPath.section][indexPath.row][@"title"];
        
        [self.navigationController pushViewController:mine animated:YES];
        
    }
    
    else if (indexPath.section == 0 && indexPath.row == 2) {
        //进入收货地址
        
        AddressViewController * address = [[AddressViewController alloc]init];
        
        [self.navigationController pushViewController:address animated:YES];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        //进入客服
        CustomerViewController * cus = [[CustomerViewController alloc]init];
        [self.navigationController pushViewController:cus animated:YES];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        //进入您的建议
        SettingViewController * setting = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    else
    {
        HuancunViewController * huan = [[HuancunViewController alloc]init];
        [self.navigationController pushViewController:huan animated:YES];
    }
    
    
    
}




@end
