//
//  HotGameDetail.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "HotGameDetail.h"
#import "TalkCell.h"
#import "TalkModel.h"
#import "GameSenceCell.h"
#import "GameSenceModel.h"
#import "FootSenceTableViewCell.h"
#import "YCHDataBaseManager.h"
#define BACK_IMG @"http://www.tiyufeng.com/mobile_app4.0/data/img/footballbg.png"
#define SCREEN_SIZE [[UIScreen mainScreen]bounds].size
#define TALK_URL @"http://u1.tiyufeng.com/comment/list?portalId=15&start=0&contentType=14&contentId=%@&limit=20&clientToken=7c98ddd1d8cb729bf66791a192b43748"
#define Game_Sence @"http://u1.tiyufeng.com/v2/statistics/basketball/game/live_text?gameId=%@&ran=7802690989"
#define GAME_FOOTBALL @"http://u1.tiyufeng.com/v2/statistics/football/game/live_text?gameId=%@&ran=7802690989"
@interface HotGameDetail ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

/** 头部视图 */
@property (nonatomic,strong) UIView * headerView;
/** 底部滑块 */
@property (nonatomic,strong) UIView * indicatorView;
/** 滚动视图 */
@property (nonatomic,strong) UIScrollView * scrollView;
/** 按钮标题 */
@property (nonatomic,strong) NSArray * titles;
/** 当前选中项 */
@property (nonatomic,weak) UIButton * currentButton;
/** leftTableView*/
@property(nonatomic,strong)UITableView * leftTableView;
/** rightTableView*/
@property(nonatomic,strong)UITableView * rightTableView;
/** manager*/
@property(nonatomic,strong)YCHDataBaseManager * manager;
/** leftDataSource*/
@property(nonatomic,strong)NSMutableArray * leftDataSource;
/** riughtDataSource*/
@property(nonatomic,strong)NSMutableArray * rightDataSource;

@end

@implementation HotGameDetail
- (void)viewWillAppear:(BOOL)animated
{
     self.rightTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableBack.jpg"]];
     self.leftTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableBack.jpg"]];
    [super viewWillAppear:animated];
//    //设置导航栏透明操作
    UIImage * image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
  
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIImage * image = [UIImage imageNamed:@""];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUI];
    
    [self createScrollView];
    [self createUI];
    [self loadLeftData];
    [self loadRightData];
}
- (void)initData
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(clicked)];
    
    _leftDataSource = [[NSMutableArray alloc]init];
    _rightDataSource =[[NSMutableArray alloc]init];
    _manager = [YCHDataBaseManager sharedManager];
}
- (void)clicked{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if (![[user objectForKey:@"isLogin"]isEqualToString:@"isLogin"]) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    NSDictionary * info = @{@"ID":self.model.ID, @"itemName":self.model.gameName,@"HomeName":self.model.homeName,@"GuestName":self.model.guestName,@"HomeScore":self.model.homeScore,@"GuestScore":self.model.guestScore,@"StartTime":self.model.startTime,@"HomePicUrl":self.model.homePicUrl,@"GuestPicUrl":self.model.guestPicUrl};
    if ([_manager isAlreadyFavorite:self.model.ID]) {
        [SVProgressHUD showErrorWithStatus:@"已收藏!"];
    }
    else if ([_manager adFavorite:info]){
         [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    }
    
   
}
- (void)loadLeftData
{
   // NSLog(@"%@",self.model.ID);

    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:TALK_URL,self.model.ID] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * results = dict[@"results"];
        NSArray * models = [NSArray modelArrayWithClass:[TalkModel class] json:results];
        [self.leftDataSource addObjectsFromArray:models];
        [self.leftTableView reloadData];
    }];
}
- (void)loadRightData
{
    NSString * url = [[NSString alloc]init];
    if ([self.model.itemName isEqualToString:@"篮球"]) {
        url = Game_Sence;
    }else
    {
        url = GAME_FOOTBALL;
    }
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:url,self.model.ID] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * results = dict[@"results"];
        NSArray * models = [NSArray modelArrayWithClass:[GameSenceModel class] json:results];
        [self.rightDataSource addObjectsFromArray:models];
        [self.rightTableView reloadData];
    }];
}
- (void)createUI
{
    _titles = @[@"现场"];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
  
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, SCREEN_SIZE.width, 40)];
    for (int i = 0; i < 1; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake( i * SCREEN_SIZE.width, 0, SCREEN_SIZE.width, 40)];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:YCOLOR_REDCOLOR forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            self.currentButton = button;
           // [self addSubViewsForIndex:i];
        }
        button.tag = 5678 + 1;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [_headerView addSubview:button];
        [self buttonClicked:button];
    }
    _indicatorView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 37, SCREEN_SIZE.width, 3)];
    
    _indicatorView.backgroundColor = YCOLOR_REDCOLOR;
    [_headerView addSubview:_indicatorView];
    
    [self.view addSubview:_headerView];
    
    //self.navigationItem.titleView = _headerView;
    
}
- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 250, [[UIScreen mainScreen] bounds].size.width, SCREEN_SIZE.height - 250)];
    self.scrollView.contentSize = CGSizeMake(self.titles.count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    self.scrollView.pagingEnabled = YES;
    //self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    [self addSubViews];
}
- (void)addSubViews
{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_SIZE.width, SCREEN_SIZE.height - 290) style:UITableViewStylePlain];
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.tag = 101;
    
    [_leftTableView registerNib:[UINib nibWithNibName:@"TalkCell" bundle:nil] forCellReuseIdentifier:@"TALK"];
    [self.scrollView addSubview:_leftTableView];
    
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width, 40, SCREEN_SIZE.width, SCREEN_SIZE.height - 290) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource =self;
    [_rightTableView registerNib:[UINib nibWithNibName:@"GameSenceCell" bundle:nil] forCellReuseIdentifier:@"sence"];
    [_rightTableView registerNib:[UINib nibWithNibName:@"FootSenceTableViewCell" bundle:nil] forCellReuseIdentifier:@"FOOTSENCE"];
    _rightTableView.tag = 102;
    UILabel * lael = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 40)];
    lael.text = @"比赛事件";
    lael.textAlignment = NSTextAlignmentCenter;
    lael.font = [UIFont systemFontOfSize:15];
    _rightTableView.tableHeaderView = lael;
    UILabel * backlael = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 40)];
    backlael.text = @"暂无比赛事件";
    backlael.textColor = [UIColor grayColor];
    backlael.textAlignment = NSTextAlignmentCenter;
    _rightTableView.backgroundView = backlael;
    [self.scrollView addSubview:_rightTableView];
    
    
    
}
- (void)buttonClicked:(UIButton *)button
{
    //1.切换选中按钮
    self.currentButton.selected = NO;
    button.selected = YES;
    self.currentButton = button;
    
  
    //3.滚动视图的偏移量
    [self.scrollView setContentOffset:CGPointMake((button.tag - 5678) * self.scrollView.bounds.size.width, 0) animated:NO];
    //4.填充子视图
    //[self addSubViewsForIndex:button.tag- 5678];
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%ld",self.leftDataSource.count);
    if (tableView.tag == 101) {
         return self.leftDataSource.count;
    }else
    {
        return self.rightDataSource.count;
        
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (tableView.tag == 101) {
        TalkModel * model = self.leftDataSource[indexPath.row];
        TalkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TALK"];
//        [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.headImg]];
        [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        cell.content.text = model.content;
       // NSLog(@"%@222222",model.content);
        cell.nickname.text = model.nickname;
        cell.createTime.text = model.createTime;
        return cell;
        
    }else if (tableView.tag == 102){
        if ([self.model.itemName isEqualToString:@"篮球"]) {
            GameSenceModel * model = self.rightDataSource[indexPath.row];
            GameSenceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sence"];
            cell.score.text = [NSString stringWithFormat:@"%@-%@",model.homeScore,model.guestScore];
            cell.time.text = [NSString stringWithFormat:@"第%@节 %@'%@''",model.quarter,model.minutes,model.seconds];
            cell.descript.text = model.descript;
            return cell;
        }
          FootSenceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FOOTSENCE"];
        GameSenceModel * model = self.rightDataSource[indexPath.row];
      
        
        cell.descriptLabel.text = model.descript;
        if (model.description == nil) {
            cell.descriptLabel.text = @"暂无比赛事件";
        }
           cell.timeLabel.text = [NSString stringWithFormat:@"%@'",model.minutes];
        if ([model.minutes isEqualToString:@"-1"]) {
            cell.timeLabel.text = @"";
        }
     
        return cell;
        
    }
    return nil;
    
  
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"1111");
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
  //  NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
  //  UIButton * button = (id)[self.view viewWithTag:currentPage + 5678];
    //[self buttonClicked:button];
    
}

- (void)setUI
{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    label.text = _model.gameName;
    label.textAlignment =  NSTextAlignmentCenter ;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView =label;
    if ([self.model.itemName isEqualToString:@"足球"]) {
        [self.backImage sd_setImageWithURL:[NSURL URLWithString:BACK_IMG]];
    }else{
        self.backImage.backgroundColor = YCOLOR_BROWNCOLOR;
    }
    
    [self setXIB];
    
}
- (void)setXIB{
    self.gameLable.text = [NSString stringWithFormat:@"%@ %@ %@",_model.leagueName,_model.gameRound,_model.startTime];
    self.time.text = _model.statusDesc;
    [self.homeLogo sd_setImageWithURL:[NSURL URLWithString:_model.homePicUrl]];
    [self.guessLogo sd_setImageWithURL:[NSURL URLWithString:_model.guestPicUrl]];
    self.gameSocre.text = _model.homeScore;
    self.guessSocre.text = _model.guestScore;
    self.leftCount.text = _model.homeSupports;
    self.rightCount.text = _model.guestSupports;
    self.leftUp.image = [UIImage imageNamed:@"leftUp"];
    self.rightUp.image = [UIImage imageNamed:@"rightUp"];
    self.progress.progress =  self.leftCount.text.floatValue/(self.rightCount.text.floatValue + self.leftCount.text.floatValue);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        return 100;
    }else{
        if ([self.model.itemName isEqualToString:@"篮球"]) {
            return 44;
        }else{
            return 80;
        }
    }
}

@end
