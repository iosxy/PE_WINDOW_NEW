//
//  FootBallDetailVC.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "FootBallDetailVC.h"
#import "FootBallTableViewCell.h"
#import "FootBallModel.h"
#import "GameWebTableViewCell.h"
#import "RedYellowModel.h"
#import "RedYellowModelTableViewCell.h"
//球队积分
#define POINTS @"http://u1.tiyufeng.com/v2/statistics/football/team/standings?leagueId=%@"
//球队盘路(网页)
#define PAN @"http://www.tiyufeng.com/mobile_app4.0/data/league/football/grail.html?id=%@"
//http://www.tiyufeng.com/mobile_app4.0/data/league/football/grail.html?id=3241
//进球
#define GOT_BALL @"http://www.tiyufeng.com/mobile_app4.0/data/league/football/shot.html?id=%@"
//http://www.tiyufeng.com/mobile_app4.0/data/league/football/shot.html?id=3241
//助攻
#define HELP @"http://www.tiyufeng.com/mobile_app4.0/data/league/football/assist.html?id=%@"
//http://www.tiyufeng.com/mobile_app4.0/data/league/football/assist.html?id=3241
//红黄牌
#define RED_YELLOW @"http://u1.tiyufeng.com/v2/statistics/football/player/cards?leagueId=%@&ran=1402768609"
//http://u1.tiyufeng.com/v2/statistics/football/player/cards?leagueId=3241&ran=1402768609
@interface FootBallDetailVC ()<UITableViewDataSource,UITableViewDelegate>
/** currentButton*/
@property(nonatomic,strong)UIButton * currentButton;
/** tableView*/
@property(nonatomic,strong)UITableView * tableView;
/** point*/
@property(nonatomic,strong)NSMutableArray * pointArr;
/** red*/
@property(nonatomic,strong)NSMutableArray * redArr;
@end

@implementation FootBallDetailVC{
    int _index;
}

- (void)viewDidLoad {
     self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableBack.jpg"]];
    [super viewDidLoad];
    [self initData];
    self.title = self.gameTitle;
    _index = 0;
    [self buildUI];
    [self loadData];
    [self setTableView];
      self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  
}
- (void)initData
{
    _pointArr = [[NSMutableArray alloc]init];
    _redArr = [[NSMutableArray alloc]init];
}
- (void)buildUI
{
    NSArray * buttonTitle = @[@"积分",@"盘路",@"进攻",@"助攻",@"红黄牌"];
    for (int i = 0; i < buttonTitle.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(55 +((self.view.bounds.size.width - 100)/5) * i, 100, ((self.view.bounds.size.width - 100)/5), 30)];
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


}
#pragma mark b表格视图相关
- (void)setTableView
{
    
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.height - 150) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"FootBallTableViewCell" bundle:nil] forCellReuseIdentifier:@"FOOTBALL"];
      [table registerNib:[UINib nibWithNibName:@"GameWebTableViewCell" bundle:nil] forCellReuseIdentifier:@"GAME"];
     [table registerNib:[UINib nibWithNibName:@"RedYellowModelTableViewCell" bundle:nil] forCellReuseIdentifier:@"RY"];
    _tableView = table;
    [self.view addSubview:table];
    
    
    if (_index == 0) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        label.tag = 101;
        label.backgroundColor = [UIColor lightGrayColor];
        label.text = @"                   球队                                 场次 胜    平    负  进/失   积分";
        label.font = [UIFont systemFontOfSize:12];
        _tableView.tableHeaderView = label;
    }
    
}
- (void)loadData
{
    
        [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:POINTS,self.gameID] andParamter:nil returnData:^(NSData *data, NSError *error) {
            if (error) {
                return;
            }
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            NSArray * result = dic[@"results"];
            NSArray * models = [NSArray modelArrayWithClass:[FootBallModel class] json:result];
            [_pointArr addObjectsFromArray:models];
            [_tableView reloadData];
            
            [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:RED_YELLOW,self.gameID] andParamter:nil returnData:^(NSData *data, NSError *error) {
                if (error) {
                    return;
                }
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
                NSArray * result = dic[@"results"];
                NSArray * models = [NSArray modelArrayWithClass:[RedYellowModel class] json:result];
                [_redArr addObjectsFromArray:models];
                [_tableView reloadData];
            } ];
            
        }];
    
    
    
   
}
#pragma mark - 表格视图相关

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{if (_index == 0){
     return _pointArr.count;
}else if (_index == 4){
    return _redArr.count;
}
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0) {
        FootBallModel * model = self.pointArr[indexPath.row];
        
        FootBallTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FOOTBALL"];
        
        cell.sort.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
        [cell.logo sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
        cell.teamName.text = model.teamName;
        //   [NSString stringWithFormat:@"%@ %@ %@ %@  %@/%@  %@",model.games,model.wins,model.draws ,model.losses,model.goalsFor,model.goalsAgainst,model.points];
        cell.games.text = model.games;
        cell.wins.text = model.wins;
        cell.draws.text = model.draws;
        cell.losses.text = model.losses;
        cell.goal.text = [NSString stringWithFormat:@"%@/%@",model.goalsFor,model.goalsAgainst];
        cell.points.text = model.points;
        return cell;
    }
    else if (_index == 1){
        GameWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GAME"];
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:PAN,self.gameID]]];
        [cell.GameWeb loadRequest:request];
        return cell;
        
    }
    else if (_index == 2){
        GameWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GAME"];
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOT_BALL,self.gameID]]];
        [cell.GameWeb loadRequest:request];
        return cell;
        
    }
    else if (_index == 3){
        GameWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GAME"];
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:HELP,self.gameID]]];
        [cell.GameWeb loadRequest:request];
        return cell;
        
    }else if (_index == 4){
        RedYellowModelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RY"];
        RedYellowModel * model = _redArr[indexPath.row];
        cell.teamName.text = model.teamName;
        cell.playerName.text = model.playerName;
        cell.redCards.text = model.redCards;
        cell.yellowCard.text = model.yellowCards;
        cell.sort.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
        [cell.teamLogo sd_setImageWithURL:[NSURL URLWithString:model.teamLogoUrl]];
        return cell;
        
    }
    
    
    
    
    return nil;
   
    
   
}
- (void)buttonClicked:(UIButton *)button
{
    UILabel * label = (id)[self.view viewWithTag:101];
    _index =(int)button.tag - 1000;
    if (_index == 0) {
        label.hidden = NO;
        label.text = @"                   球队                                 场次 胜    平    负  进/失   积分";
    }else if (_index == 4){
        label.hidden = NO;
          label.text = @"                球员             红                           黄          球队 ";
    }else{
        label.hidden = YES;
    }
    
    
    
    [_currentButton setSelected:NO];
    _currentButton = button;
    [_currentButton setSelected:YES];
    [_tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_index == 0 || _index == 4) {
        return 45;
    }
    return _tableView.frame.size.height;
}


@end
