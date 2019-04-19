//
//  YPhotoCommentViewController.m
//  Product-PEWindow
//
//  Created by 游成虎 on 2019/4/18.
//  Copyright © 2019年 qianfeng. All rights reserved.
//

#import "YPhotoCommentViewController.h"
#import "TalkCell.h"
#import "TalkModel.h"
#import "UserModel.h"
#import "TCSendTextView.h"
#import "TCHorizontalScrollViewTool.h"

@interface YPhotoHeader : UIView

/** 图片管理器*/
@property (strong, nonatomic) TCHorizontalScrollViewTool *scrollViewTool;
@property (nonatomic, strong) UIView           * scrollBJView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel *feedLoc;
@property (nonatomic, strong) UIButton * dainZan;

@end

@implementation YPhotoHeader
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (UIButton *)dainZan {
    if (!_dainZan) {
        _dainZan = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dainZan setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [_dainZan setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateSelected];
        [_dainZan addTarget:self action:@selector(dianzanClicked:)];
        [self addSubview:_dainZan];
    }
    return _dainZan;
}
- (void)dianzanClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (UIView *)scrollBJView {
    if (!_scrollBJView) {
        _scrollBJView = [[UIView alloc]init];
        [self addSubview:_scrollBJView];
    }
    return _scrollBJView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(0xf6f6f6);
        [self addSubview:_lineView];
    }
    return _lineView;
}
- (void)setDataWith:(NSDictionary *)data {
    NSMutableArray * imageArr = [[NSMutableArray alloc]init];
    for (NSDictionary * obj in data[@"imgList"]) {
        [imageArr addObject:obj[@"picimgurl"]];
    }
    [self.scrollViewTool setImageUrls:imageArr];
    self.feedLoc.text = [NSString stringWithFormat:@"%@",data[@"title"]];
}
- (void)creatUI {
    self.scrollBJView.backgroundColor = [UIColor whiteColor];
    self.scrollBJView.layer.cornerRadius = 1.0;
    self.scrollBJView.layer.masksToBounds = YES;
    [self.scrollBJView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.equalTo(@260);
    }];
    [self.scrollBJView addSubview:self.scrollViewTool.horizontalScrollView];
    [self.feedLoc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollBJView.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    [self.dainZan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedLoc.mas_bottom).offset(0);
        make.right.equalTo(self).offset(-15);
        make.height.width.equalTo(@35);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}
#pragma mark - properties
- (TCHorizontalScrollViewTool *)scrollViewTool{
    if (!_scrollViewTool) {
        _scrollViewTool = [[TCHorizontalScrollViewTool alloc]init];
        _scrollViewTool.horizontalScrollView.frame = CGRectMake(0., 0., SCREEN_WIDTH, 260);
        _scrollViewTool.horizontalScrollView.layer.borderWidth = 1;
        _scrollViewTool.horizontalScrollView.layer.borderColor = RGB(0xf6f6f6).CGColor;
    }
    return _scrollViewTool;
}
-(UILabel *)feedLoc{
    if (!_feedLoc) {
        _feedLoc = [[UILabel alloc]init];
        _feedLoc.font = [UIFont systemFontOfSize:15];
        _feedLoc.textColor = RGB(0x333333);
        _feedLoc.numberOfLines = 2;
        [self addSubview:_feedLoc];
    }
    return _feedLoc;
}

@end


@interface YPhotoCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong) TCSendTextView *sendTextView;
@property (nonatomic,strong) YPhotoHeader * header;
@property (nonatomic, strong) UIView *emptyView;
@end

@implementation YPhotoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _dataSource = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    AdjustsScrollViewInsetNever(self, self.tableView);
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"TalkCell" bundle:nil] forCellReuseIdentifier:@"TALK"];
    [_tableView reloadData];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.header;
    _tableView.tableFooterView = self.emptyView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"举报" style:UIBarButtonItemStyleDone target:self action:@selector(jubao)];
    
    
    [self.header setDataWith:self.data];
    [self loadData];
    [self setReplay];
}
- (void)jubao {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择举报内容" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *skipAction = [UIAlertAction actionWithTitle:@"色情相关" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会尽快核实并处理!"];
    }];
    UIAlertAction *skipAction2 = [UIAlertAction actionWithTitle:@"资料不当" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会尽快核实并处理!"];
    }];
    UIAlertAction *skipAction3 = [UIAlertAction actionWithTitle:@"违法内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会尽快核实并处理!"];
    }];
    UIAlertAction *skipAction4 = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!我们会尽快核实并处理!"];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:skipAction];
    [alertController addAction:skipAction2];
    [alertController addAction:skipAction3];
    [alertController addAction:skipAction4];
    [self presentViewController:alertController animated:YES completion:nil];
 
    
}
- (void)loadData
{
    NSMutableArray * arrModelTemp = [NSKeyedUnarchiver unarchiveObjectWithFileName:[self modelID]];
    if (arrModelTemp) {
        self.emptyView.hidden = YES;
        [self.dataSource addObjectsFromArray:arrModelTemp];
        [self.tableView reloadData];
        return;
    }
}
- (void)dealloc{
    [self.sendTextView.textView removeObserver:self forKeyPath:@"frame"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) setReplay{
    self.sendTextView.textView.text = nil;
    self.sendTextView.textView.placehold = @"发送评论";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TalkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TALK"];
    TalkModel * model = self.dataSource[indexPath.row];
    if (model) {
       [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UserModel shared].headImage];
        cell.nickname.text = model.nickname;
        cell.createTime.text = model.createTime;
        NSData * data = [GTMBase64 decodeString:model.content];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        cell.content.text = str;
    }
    return  cell;
    
}
- (YPhotoHeader *)header {
    if (!_header) {
        _header = [[YPhotoHeader alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 290 + 25 + 30)];
    }
    return _header;
}
- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc]init];
        
        UILabel *label = [[UILabel alloc]init];
        label.tag = 10;
        label.text = @"暂无评论，还不快抢沙发";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGB(0XA8A8A8);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [_emptyView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyView.mas_centerX);
            make.centerY.equalTo(_emptyView.mas_centerY).offset(100);
        }];
        
        _emptyView.center =self.tableView.tableFooterView.center;
        _emptyView.hidden = NO;
    }
    return _emptyView;
}
- (NSString *)title {
    return @"图文详情";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
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
    self.emptyView.hidden = YES;
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
    NSString * key = [NSString stringWithFormat:@"%@",self.data[@"id"]];
    //存档
    [NSKeyedArchiver archiveRootObject:thirdArray toFileName:key];
    
    //    [[NSUserDefaults standardUserDefaults] setValue:self.dataSource forKey:self.model.ID];
}
- (NSString *)modelID {
    return [NSString stringWithFormat:@"%@",self.data[@"id"]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
