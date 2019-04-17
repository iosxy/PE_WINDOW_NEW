//
//  GameHotViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/21.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "GameHotViewController.h"
#import "GameHotModel.h"
#import "GameHotTableViewCell.h"
#import "HotGameDetail.h"
#import <EventKit/EventKit.h>
#define HotGame @"http://u1.tiyufeng.com/game/date_game_list?portalId=15&date=%@&clientToken=7c98ddd1d8cb729bf66791a192b43748"
@interface GameHotViewController ()<UITableViewDataSource,UITableViewDelegate>
/** tableView*/
@property(nonatomic,strong)UITableView * tableView;
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;
/** 总数据源*/
@property(nonatomic,strong)NSMutableArray * mainDataSource;
/** 当前时间*/
@property(nonatomic,copy) NSString*currentDateString;
/** day*/
@property(nonatomic,assign)int  currentDay;
@property(nonatomic,assign)int  currentMonth;
@property(nonatomic,assign)int  index;
@property(nonatomic,assign)int  mouthindex;

@end

@implementation GameHotViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
  
    [self changeDate];
     self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableBack.jpg"]];
    self.view.backgroundColor = YCOLOR_REDCOLOR;
    _mainDataSource = [[NSMutableArray alloc]init];
 
   
 
    [self loadData];
    [self createTableView];
     
}

- (void)changeDate
{
   
    NSDate*currentDate=[NSDate date];
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
   _currentDateString=[dateFormatter stringFromDate:currentDate];
    NSArray * dateArr = [_currentDateString componentsSeparatedByString:@"-"];
    _currentMonth = (int)[dateArr[1] integerValue];
    _currentDay = (int)[dateArr[2] integerValue];
   // NSLog(@"%@",_currentDateString);
    
    
}
- (void)createTableView
{//创建表格视图
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, (iPhoneX ? 84 : 0), SCREEN_WIDTH, SCREEN_HEIGHT - (iPhoneX ? 84 : 0)) style:UITableViewStyleGrouped];
//    table.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"GameHotTableViewCell" bundle:nil] forCellReuseIdentifier:@"HOT"];
    table.rowHeight = 149;
    self.tableView = table;
    //添加下拉收拾
    MJRefreshHeader * header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadLastDay];
    }];
    
    self.tableView.mj_header = header;
    //添加上拉操作
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        GameHotModel * model = self.mainDataSource.lastObject[0];
        NSString * date = model.startTime;
    
        NSRange rang = {8,2};
        NSString * day = [date substringWithRange:rang];
        _currentDay = day.intValue;
        _currentDay++;
        if (_currentDay == 31) {
            _currentDay = 1;
            _currentMonth++;
        }
        [self loadData];
        
    }];
    self.tableView.mj_footer = footer;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:table];
}
//数据源相关
- (void)loadData
{
    //请求数据源，加载数据
    [SVProgressHUD showWithStatus:@"正在加载" maskType:1];
    self.dataSource = [[NSMutableArray alloc]init];
    NSString * currentDate = [NSString stringWithFormat:@"2019-%.2d-%.2d",_currentMonth,_currentDay];
   [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:HotGame,currentDate] andParamter:nil returnData:^(NSData *data, NSError *error) {
       if (error) {
           return;
       }
       NSArray * results = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
       NSArray * models = [NSArray modelArrayWithClass:[GameHotModel class] json:results];
       [self.dataSource addObjectsFromArray:models];
       [_mainDataSource addObject:self.dataSource];
       [_tableView reloadData];
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
   }];
    [self.tableView.mj_footer endRefreshing];
    
}
- (void)loadLastDay
{
    GameHotModel * model = self.mainDataSource.firstObject[0];
    NSString * date = model.startTime;
    
    NSRange rang = {8,2};
    NSString * day = [date substringWithRange:rang];
    _currentDay = day.intValue;
    _currentDay--;
    if (_currentDay >= 31) {
        _currentDay = 0;
        _currentMonth++;
    }else if (_currentDay <= 0){
        _currentDay = 30;
        _currentMonth--;
    }
    self.dataSource = [[NSMutableArray alloc]init];
    NSString * currentDate = [NSString stringWithFormat:@"2019-%.2d-%.2d",_currentMonth,_currentDay];
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:HotGame,currentDate] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSArray * results = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * models = [NSArray modelArrayWithClass:[GameHotModel class] json:results];
        [self.dataSource addObjectsFromArray:models];
        [_mainDataSource insertObject:self.dataSource atIndex:0];
        
        [_tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    }];
    
    [self.tableView.mj_header endRefreshing];
    
}



#pragma mark - 表格视图相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mainDataSource.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainDataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameHotModel * model = self.mainDataSource[indexPath.section][indexPath.row];
    
    GameHotTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HOT"];
    cell.gameRound.text = model.gameRound;
    cell.startTime.text = model.startTime;
    cell.homeName.text = model.homeName;
    cell.guestName.text = model.guestName;
    cell.homeScore.text =model.homeScore;
    cell.guestSocre.text = model.guestScore;
    cell.statusDesc.text = model.statusDesc;
    cell.lotteryDesc.text = model.lotteryDesc;
    cell.leagueName.text = model.leagueName;
    [cell.homePicUrl sd_setImageWithURL:[NSURL URLWithString:model.homePicUrl]];
    [cell.guestPicUrl sd_setImageWithURL:[NSURL URLWithString:model.guestPicUrl]];
    cell.addAlert.tag = indexPath.section;
    [cell.addAlert addTarget:self action:@selector(addLert:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)addLert:(UIButton *)button {
    
   
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"添加到日历" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self saveEvent:self.mainDataSource[0][0]];
        
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
    }]];
 
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
-(void)saveEvent:(GameHotModel *)model
{
    //calshow:后面加时间戳格式，也就是NSTimeInterval
    //    注意这里计算时间戳调用的方法是-
    //    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSinceDate:2016];
    
    //    timeIntervalSinceReferenceDate的参考时间是2000年1月1日，
    //    [NSDate date]是你希望跳到的日期。
    
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    //06.07 使用 requestAccessToEntityType:completion: 方法请求使用用户的日历数据库
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误细心
                    // display error message here
                }
                else if (!granted)
                {
                    //被用户拒绝，不允许访问日历
                    // display access denied error message here
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    
                    //事件保存到日历
                    //06.07 元素
                    //title(标题 NSString),
                    //location(位置NSString),
                    //startDate(开始时间 2016/06/07 11:14AM),
                    //endDate(结束时间 2016/06/07 11:14AM),
                    //addAlarm(提醒时间 2016/06/07 11:14AM),
                    //notes(备注类容NSString)
                    
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title  = model.gameName;
                    event.location = model.leagueName;
                    
                    //                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    //                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    //06.07 时间格式
                    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setAMSymbol:@"AM"];
                    [dateFormatter setPMSymbol:@"PM"];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mmaaa"];
                    
                    //NSString * s = [dateFormatter stringFromDate:date];
                    NSDate *date = [dateFormatter dateFromString:model.startTime];
                   // NSLog(@"%@",s);
                    
                    //开始时间(必须传)
                    event.startDate = [date dateByAddingTimeInterval:60 * 2];
                    //结束时间(必须传)
                    event.endDate   = [date dateByAddingTimeInterval:60 * 5 * 24];
                    //                    event.endDate   = [[NSDate alloc]init];
                    //                    event.allDay = YES;//全天
                    
                    //添加提醒
                    //第一次提醒  (几分钟后)
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -1.0f]];
                    //第二次提醒  ()
                    //                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -10.0f * 24]];
                    
                    //06.07 add 事件类容备注
                    NSString * str = @"接受信息类容备注";
                    event.notes = [NSString stringWithFormat:@"%@",str];
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    NSLog(@"保存成功");
                    
                    //直接杀死进程
                   // exit(2);
                    
                }
            });
        }];
    }
    
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    GameHotModel * model = self.mainDataSource[section][0];
    NSString * date = model.startTime;
    NSString * newDate = [date substringToIndex:10];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.bounds.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    
    label.text = newDate;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter ;

    UIView * view = [[UIView alloc]init];
   [view addSubview:label];
    view.backgroundColor = RGB(0x64d3d8);
    view.alpha = 0.7;
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GameHotModel * model = self.mainDataSource[indexPath.section][indexPath.row];
    HotGameDetail * vc = [[HotGameDetail alloc]init];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

@end
