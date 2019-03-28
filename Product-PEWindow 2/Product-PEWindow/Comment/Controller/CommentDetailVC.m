//
//  CommentDetailVC.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "CommentDetailVC.h"
#import "NSString+URLEncoding.h"
#import "GTMBase64.h"
#import "BCell.h"
#import "reportViewController.h"
#import "TCSendTextView.h"
#import "UserModel.h"

#define NEWS_DETAIL @"http://u1.tiyufeng.com/v2/post/detail?id=%@&portalId=15&clientToken=7c98ddd1d8cb729bf66791a192b43748"
#define TAKL @"http://u1.tiyufeng.com/v2/post/reply_list?postId=%@&sort=2&start=0&limit=18&portalId=15&clientToken=7c98ddd1d8cb729bf66791a192b43748"
@interface CommentDetailVC ()<UITableViewDataSource,UITableViewDelegate>
/** tableView*/
@property(nonatomic,strong)UITableView * tableView;
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,strong) TCSendTextView *sendTextView;

@end

@implementation CommentDetailVC{
    NSString * _content ;
    NSArray * _picList;
    UILabel * _label;
    UILabel * _label2;
    UILabel * _label3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    if (self.contentId == nil) {
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"举报" style:UIBarButtonItemStyleDone target:self action:@selector(report)];
        self.navigationItem.rightBarButtonItem = item;
            [self createTable];
            [self loadData];
        
    }else
    {
        [self createTable];
        [self loadNewsData];
        
    }
    [self buidlShare];
    [self setReplay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
  
}
- (void)dealloc{
    [self.sendTextView.textView removeObserver:self forKeyPath:@"frame"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setReplay{
    self.sendTextView.textView.text = nil;
    self.sendTextView.textView.placehold = @"发送评论";
}
- (void)report
{
    reportViewController * vc = [[reportViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    self.navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
}
- (void)initData
{
    //self.title = self.model.title;
    _dataSource = [[NSMutableArray alloc]init];
  
}
- (void)createTable
{
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, (isOldHorizontalPhone ? 64 : 88), [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - (isOldHorizontalPhone ? 64 : 88) - 50) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"TalkCell" bundle:nil] forCellReuseIdentifier:@"TALK"];
    [table registerNib:[UINib nibWithNibName:@"BCell" bundle:nil] forCellReuseIdentifier:@"B"];
    _label = [[UILabel alloc]init];
    _label.frame = CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 44);
    _label.numberOfLines = 0;
    _label.font = [UIFont boldSystemFontOfSize:16];
    _label.textAlignment = NSTextAlignmentCenter;
   
    _label2 = [[UILabel alloc]init];
    _label2.frame = CGRectMake(10, 50,70, 30);
    _label2.font = [UIFont systemFontOfSize:12];
    
    _label3 = [[UILabel alloc]init];
    _label3.frame = CGRectMake(70, 50,120, 30);
   _label3.font = [UIFont systemFontOfSize:12];
    [self refreshHeaderData];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 80)];
    [view addSubview:_label];
    [view addSubview:_label2];
    [view addSubview:_label3];
    table.tableHeaderView = view;
    [self.view addSubview:table];
    self.tableView = table;
}
- (void)refreshHeaderData {
    _label.text = self.model.title;
    _label2.text = self.model.nickName;
    _label3.text = self.model.createTime;
}
- (void)loadData
{
    NSMutableArray * arrModelTemp = [NSKeyedUnarchiver unarchiveObjectWithFileName:self.model.ID];
    if (arrModelTemp) {
        [self.dataSource addObjectsFromArray:arrModelTemp];
        [self.dataSource insertObject:@"" atIndex:0];
        [self.tableView reloadData];
        return;
    }
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:TAKL,self.model.ID] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
       NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * results = result[@"results"];
        NSArray * models = [NSArray modelArrayWithClass:[TalkModel class] json:results];
        [self.dataSource addObject:@""];
        [self.dataSource addObjectsFromArray:models];
        [self.tableView reloadData];
        NSLog(@"%@", [NSString stringWithFormat:@"%@" , result]);
    }];
    
}
- (void)loadNewsData
{
//    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, (isOldHorizontalPhone ? 64 : 88), [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - (isOldHorizontalPhone ? 64 : 88) - 50) style:UITableViewStyleGrouped];
//    table.dataSource = self;
//    table.delegate = self;
//    [table registerNib:[UINib nibWithNibName:@"TalkCell" bundle:nil] forCellReuseIdentifier:@"TALK"];
//    [table registerNib:[UINib nibWithNibName:@"BCell" bundle:nil] forCellReuseIdentifier:@"B"];
    [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:NEWS_DETAIL,self.contentId] andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSString * title = dict[@"title"];
        _content = dict[@"content"];
        NSString * nickname = dict[@"nickname"];
        NSString * createTime = dict[@"createTime"];
        _picList = [[NSArray alloc]init];
        _picList = dict[@"extParam"][@"picList"];
        self.model = [CommentModel new];
        self.model.title = title;
        self.model.ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        self.model.content = _content;
        self.model.nickName = nickname;
        self.model.createTime = createTime;
        self.model.picList = [NSMutableArray arrayWithArray:_picList];
        [self refreshHeaderData];
        [self.tableView reloadData];
        
        
        NSMutableArray * arrModelTemp = [NSKeyedUnarchiver unarchiveObjectWithFileName:self.model.ID];
        if (arrModelTemp) {
            [self.dataSource addObjectsFromArray:arrModelTemp];
            [self.dataSource insertObject:@"" atIndex:0];
            [self.tableView reloadData];
            return;
        }
        [YCHNetworking startRequestFromUrl:[NSString stringWithFormat:TAKL,self.contentId] andParamter:nil returnData:^(NSData *data, NSError *error) {
            if (error) {
                return;
            }
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            NSArray * results = result[@"results"];
            NSArray * models = [NSArray modelArrayWithClass:[TalkModel class] json:results];
            [self.dataSource addObject:@""];
            [self.dataSource addObjectsFromArray:models];
            [self.tableView reloadData];
            NSLog(@"%@", [NSString stringWithFormat:@"%@" , result]);
        }];
        
        
        
    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.contentId == nil) {
            NSData * data = [GTMBase64 decodeString:self.model.content];
            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSMutableString * muStr = [NSMutableString stringWithString:str];
            NSArray * arr1 = [muStr componentsSeparatedByString:@"<br />"];
            NSMutableArray * arr2 = [NSMutableArray arrayWithArray:arr1];
            for (int i = 0; i < arr2.count; i++) {
                NSString * obj = arr2[i];
                if ([obj rangeOfString:@"https:"].location != NSNotFound) {
                    [arr2 removeObjectAtIndex:i];
                }
                if ([obj rangeOfString:@"<br />"].location != NSNotFound) {
                    [arr2 removeObjectAtIndex:i];
                }
            }
            NSString * str3 = [arr2 componentsJoinedByString:@""];
            NSArray * arr3 =  [str3 componentsSeparatedByString:@"<p>"];
            NSString * str4 = [arr3 componentsJoinedByString:@""];
            if ([str4 rangeOfString:@"<p"].location != NSNotFound) {
                str4 = nil;
            }
            BCell * cell = [tableView dequeueReusableCellWithIdentifier:@"B"];
           
            cell.descript.text = str4;
            
            if (self.model.picList.count != 0) {
                [cell.img sd_setImageWithURL:[NSURL URLWithString:self.model.picList[0]]];
            }
            return cell;
        }
      
        
        NSData * data = [GTMBase64 decodeString:_content];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         BCell * cell = [tableView dequeueReusableCellWithIdentifier:@"B"];
    //字符串解析部分
        NSMutableString * muStr = [NSMutableString stringWithString:str];
      NSArray * arr1 = [muStr componentsSeparatedByString:@"</p>"];
        NSMutableArray * arr2 = [NSMutableArray arrayWithArray:arr1];
        for (int i = 0; i < arr2.count; i++) {
            NSString * obj = arr2[i];
            if ([obj rangeOfString:@"https:"].location != NSNotFound) {
                [arr2 removeObjectAtIndex:i];
            }
            if ([obj rangeOfString:@"<br />"].location != NSNotFound) {
                [arr2 removeObjectAtIndex:i];
            }
        }
        NSString * str3 = [arr2 componentsJoinedByString:@""];
        NSArray * arr3 =  [str3 componentsSeparatedByString:@"<p>"];
        NSString * str4 = [arr3 componentsJoinedByString:@""];
        if ([str4 rangeOfString:@"<p"].location != NSNotFound) {
            str4 = nil;
        }
           cell.descript.text = str4;
       // NSLog(@"%@",str);
        if (_picList.count != 0) {
            [cell.img sd_setImageWithURL:[NSURL URLWithString:_picList[0]]];
        }
        return cell;
    }
    
    else{
        
    TalkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TALK"];
    TalkModel * model = self.dataSource[indexPath.row];
    [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UserModel shared].headImage];
    cell.nickname.text = model.nickname;
    cell.createTime.text = model.createTime;
   // NSLog(@"%@",model.createTime);
    NSData * data = [GTMBase64 decodeString:model.content];
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    cell.content.text = str;
        return cell;}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BCell * cell = (BCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
         CGSize size = CGSizeMake(300, 1000);
         CGSize labelSize = [cell.descript.text sizeWithFont:cell.descript.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        
        return labelSize.height + 200;
    }
    return 60;
}


- (void)buidlShare
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"dianzan_s"] forState:UIControlStateSelected];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    
}
- (void)buttonClicked:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
    }
}
- (TCSendTextView *)sendTextView{
    if (!_sendTextView) {
        _sendTextView = [[TCSendTextView alloc]init];
        [_sendTextView setUp];
        _sendTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//        _sendTextView.bottom = (isOldHorizontalPhone ? self.view.height : self.view.height - 88);
        [_sendTextView.textView addObserver:self
                                 forKeyPath:@"frame"
                                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                    context:nil];
        WEAKSELF
        [_sendTextView setOnSendText:^(NSString * text) {
            [weakSelf sendComment:text];
            // 发送评论
        }];
        
        
        [self.view addSubview:_sendTextView];
        [_sendTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(isOldHorizontalPhone?0:-25);
            make.height.equalTo(@50);
            make.left.right.equalTo(self.view);
        }];
//        _sendTextView.bottom = (isOldHorizontalPhone ? self.view.height : self.view.height - 88);
    }
    return _sendTextView;
}
//发送评论
- (void) sendComment:(NSString*)text{
    [self.sendTextView.textView resignFirstResponder];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if (![[user objectForKey:@"isLogin"]isEqualToString:@"isLogin"]) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    TalkModel * model = [TalkModel new];
    model.nickname = @"用户3847892";
    NSString * nickName = [user objectForKey:@"currentUser"];
    if (nickName) {
        model.nickname = nickName;
    }
    model.createTime = [self getCurrentTimes];
    model.content = [GTMBase64 stringByEncodingData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    model.headImg = @"http";
    [self.dataSource addObject:model];
    [self.tableView reloadData];
    self.sendTextView.textView.text = nil;
    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
    [self cunDang];
}
//获取当前的时间

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

#pragma mark - keyboard
- (void)myKeyboardWillShow:(NSNotification *)notif{
//    self.keyboardShowing = YES;
    NSDictionary * userInfo = notif.userInfo;
//    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize kbSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //    CGSize kbEndSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat sendViewHeight = self.sendTextView.height;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + sendViewHeight, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height - sendViewHeight;
    [self.sendTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kbSize.height);
        make.height.equalTo(@50);
        make.left.right.equalTo(self.view);
    }];
//    [UIView animateWithDuration:duration animations:^{
////        CGRect frame = self.sendTextView.frame;
////        frame.origin.y = self.view.height - self.sendTextView.height - kbSize.height;
////
////        self.sendTextView.frame = frame;
//
//    }];
    
}
- (void)myKeyboardWillHide:(NSNotification *)notif{
    
//    self.keyboardShowing = NO;
    
    NSDictionary * userInfo = notif.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, self.sendTextView.height - (isOldHorizontalPhone ? 10 : 20), 0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView animateWithDuration:duration animations:^{
        [self.sendTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(isOldHorizontalPhone?0:-25);
            make.height.equalTo(@50);
            make.left.right.equalTo(self.view);
        }];
    }];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        
        //获取之前的值和现在的值
        CGRect frameNew = [change[NSKeyValueChangeNewKey] CGRectValue];
        CGRect frameOld = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGFloat offset = frameNew.size.height - frameOld.size.height;
        
        //修改sendTextView的位置和高度
        CGRect rect = self.sendTextView.frame;
        rect.size.height = frameNew.size.height + 14;
        rect.origin.y = rect.origin.y - offset;
        self.sendTextView.frame = rect;
        
        //修改tableview的contentinset,并移动
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.bottom += offset;
        self.tableView.contentInset = contentInset;
        //        [self.commentTabelView scrollToRowAtIndexPath:_indexPathLastVisible atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    
}
- (void)cunDang {
    
    NSMutableArray *thirdArray = [self.dataSource mutableCopy];
    [thirdArray removeObjectAtIndex:0];
    NSString * key = [NSString stringWithFormat:@"%@",self.model.ID];
//    [[NSUserDefaults standardUserDefaults] setValue:thirdArray forKey:key];
    //存档
    [NSKeyedArchiver archiveRootObject:thirdArray toFileName:key];
    
//    [[NSUserDefaults standardUserDefaults] setValue:self.dataSource forKey:self.model.ID];
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

@end
