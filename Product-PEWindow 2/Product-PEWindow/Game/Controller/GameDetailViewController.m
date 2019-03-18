//
//  GameDetailViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "GameDetailViewController.h"
#import "GameDetailCell.h"
#import "GameDetailModel.h"
#import "GameWebTableViewCell.h"

#define SORT_URL @"http://u1.tiyufeng.com/v2/statistics/basketball/team/ranking?leagueId=%@&conference=1"
#define SORT_URL2 @"http://u1.tiyufeng.com/v2/statistics/basketball/team/ranking?leagueId=%@&conference=2"
#define SORT_URL3 @"http://u1.tiyufeng.com/v2/statistics/basketball/team/ranking?leagueId=%@"
#define PAN_URL @"http://u1.tiyufeng.com/v2/statistics/basketball/team/trends?leagueId=%@&ran=2681426089"
#define GET_POINT @"http://www.tiyufeng.com/mobile_app4.0/data/league/basketball/scoring.html?id=%@"
#define BOARD @"http://www.tiyufeng.com/mobile_app4.0/data/league/basketball/rebound.html?id=%@"
#define HELP @"http://www.tiyufeng.com/mobile_app4.0/data/league/basketball/assist.html?id=%@"
#define MORE @"http://www.tiyufeng.com/mobile_app4.0/data/league/basketball/moreparameter.html?id=%@"
@interface GameDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 数据源*/
@property(nonatomic,strong)NSMutableArray  * dataSource;
/** 盘路数据源*/
@property(nonatomic,strong)NSMutableArray * panDataSource;
/** 表格视图*/
@property(nonatomic,strong)UITableView * tableView;
/** currentButton*/
@property(nonatomic,strong)UIButton * currentButton;
@property (nonatomic,assign)int index;
@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.bounds = [[UIScreen mainScreen]bounds];
     self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableBack.jpg"]];
   // NSLog(@"%@",_gameID);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = self.gametitle;
      self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    _dataSource = [[NSMutableArray alloc]init];
    _panDataSource = [[NSMutableArray alloc]init];
    
    [self buildTableView];
    [self buildUI];
    [self loadData];
}
//创建表格视图部分
- (void)buildTableView
{
    _index = 0;
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(10,150, self.view.width - 30 , self.view.bounds.size.height - 154) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"GameDetailCell" bundle:nil] forCellReuseIdentifier:@"GameCell"];
     [table registerNib:[UINib nibWithNibName:@"GameWebTableViewCell" bundle:nil] forCellReuseIdentifier:@"GAME"];
   // table.userInteractionEnabled = NO;
    [self.view addSubview:table];
    self.tableView = table;
    
    
}
//创建顶部UIBtton以及对表格透视图进行设置部分
- (void)buildUI
{
    NSArray * buttonTitle = @[@"排名",@"盘路",@"得分",@"篮板",@"助攻",@"更多"];
    for (int i = 0; i < buttonTitle.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(40 +((self.view.width - 100)/6) * i, 100, ((self.view.bounds.size.width - 100)/6), 30)];
        [button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
           button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = 1000 + i;
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.layer.borderWidth = 0.5;
        //[_tableView addSubview:button];
        [self.view addSubview:button];
    }
    UIButton * sort = (id)[self.view viewWithTag:1000];
    _currentButton = sort;
    [_currentButton setSelected:YES];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0,-100 , self.view.bounds.size.width, 20)];
    label.text = @"             战队名               胜  负   胜率";
    label.tag = 11;
    label.backgroundColor = [UIColor lightGrayColor];
   // [_tableView addSubview:label];
    _tableView.tableHeaderView = label;
  
}
//为Button添加点击相应事件
- (void)buttonClicked:(UIButton *)button
{
    _index =(int)button.tag - 1000;
    [_currentButton setSelected:NO];
    _currentButton = button;
    [_currentButton setSelected:YES];
    [_tableView reloadData];
   
}
- (void)loadData
{if (![_sortNo isEqualToString:@"9"]){
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:SORT_URL,_gameID] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * result = dic[@"results"];
        NSArray * models = [NSArray modelArrayWithClass:[GameDetailModel class] json:result];
        [self.dataSource addObject:models];
        
        [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:SORT_URL2,_gameID]andParamter:nil returnData:^(NSData *data, NSError *error) {
            if (error) {
                return;
            }
            NSDictionary * dic2 = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            NSArray * result = dic2[@"results"];
            NSArray * models2 = [NSArray modelArrayWithClass:[GameDetailModel class] json:result];
            [self.dataSource addObject:models2];
             [_tableView reloadData];
        }];
    }];
    
}else if ([_sortNo isEqualToString:@"9"]){
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:SORT_URL3,_gameID] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dic2 = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * result = dic2[@"results"];
        NSArray * models2 = [NSArray modelArrayWithClass:[GameDetailModel class] json:result];
        [self.dataSource addObjectsFromArray:models2];
        [_tableView reloadData];
    }];
}
    
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:PAN_URL,_gameID] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dic2 = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * result = dic2[@"results"];
        NSArray * models2 = [NSArray modelArrayWithClass:[GameDetailModel class] json:result];
        [self.panDataSource addObjectsFromArray:models2];
        
    }];
    
    
    
}

#pragma mark 代理相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![_sortNo isEqualToString:@"9"]) {
         if(_index == 0){
     return self.dataSource.count;
}else{
    return 1;
}
    }else
    {
        return 1;
    }
   
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![_sortNo isEqualToString:@"9"]) {
         if (_index == 0) {
         return [self.dataSource[section] count];
    }else if (_index == 1){
        return self.panDataSource.count;
    }
   else
       return 1;
    }else
    {
        return self.dataSource.count;
    }
   
    
   
    
}
//当点击Button之后，为Cell填充不同的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d",_index);
    if (_index == 0) {
        UILabel * label = (id)[self.view viewWithTag:11];
        label.hidden = NO;
        GameDetailModel * model = [[GameDetailModel alloc]init];
        if ([_sortNo isEqualToString:@"9"]) {
        model = self.dataSource[indexPath.row];
        }else{
           model  = self.dataSource[indexPath.section][indexPath.row];
        }
         
    GameDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
    cell.sortNo.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    [cell.teamLogo sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    cell.teamName.text = model.teamName;
    cell.winCount.text = model.winCount;
    cell.loseCount.text = model.loseCount;
    cell.winrate.text = [NSString stringWithFormat:@"%.1f",model.winRate.floatValue];
    return cell;
    
    }else if (_index == 1){
        UILabel * label = (id)[self.view viewWithTag:11];
        label.hidden = NO;
        GameDetailModel * model = self.panDataSource[indexPath.row];
        GameDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
        cell.sortNo.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
        [cell.teamLogo sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
        cell.teamName.text = model.teamName;
        cell.winCount.text = model.games;
        cell.loseCount.text = model.losses;
        cell.winrate.text = [NSString stringWithFormat:@"%.1f",model.winRate.floatValue/100];
        return cell;
    }else if (_index == 2){
        
        UILabel * label = (id)[self.view viewWithTag:11];
        label.hidden = YES;
        GameWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GAME"];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_POINT,_gameID]]];
        [cell.GameWeb loadRequest:request];
        return cell;
    }else if (_index == 3)
    {
        
        UILabel * label = (id)[self.view viewWithTag:11];
        label.hidden = YES;
        GameWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GAME"];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:BOARD,_gameID]]];
        [cell.GameWeb loadRequest:request];
        return cell;
    }else if (_index == 4){
        
        UILabel * label = (id)[self.view viewWithTag:11];
        label.hidden = YES;
        GameWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GAME"];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:HELP,_gameID]]];
        [cell.GameWeb loadRequest:request];
        return cell;
    }else if (_index == 5){
        
        UILabel * label = (id)[self.view viewWithTag:11];
        label.hidden = YES;
        GameWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GAME"];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:MORE,_gameID]]];
        [cell.GameWeb loadRequest:request];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{  if([_sortNo isEqualToString:@"9"]){
   // NSLog(@"%@",_sortNo);
    return nil;
}else{
    if (_index == 0) {
          if (section== 0) {
        return @"西部战区";
    }
    return @"东部战区";
        
    }
    return nil;
 
}
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        return 44;
    }else if (_index == 1){
        return 44;
    }
    return _tableView.frame.size.height;
}
@end











