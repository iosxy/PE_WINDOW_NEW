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
#define NEWS_DETAIL @"http://u1.tiyufeng.com/v2/post/detail?id=%@&portalId=15&clientToken=7c98ddd1d8cb729bf66791a192b43748"
#define TAKL @"http://u1.tiyufeng.com/v2/post/reply_list?postId=%@&sort=2&start=0&limit=18&portalId=15&clientToken=7c98ddd1d8cb729bf66791a192b43748"
@interface CommentDetailVC ()<UITableViewDataSource,UITableViewDelegate>
/** tableView*/
@property(nonatomic,strong)UITableView * tableView;
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation CommentDetailVC{
    NSString * _content ;
    NSArray * _picList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    if (self.contentId == nil) {
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"举报" style:UIBarButtonItemStyleDone target:self action:@selector(report)];
        self.navigationItem.rightBarButtonItem = item;
        
            [self loadData];
         [self createTable];
    }else
    {
        [self loadNewsData];
        
    }
    [self buidlShare];
  
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
    
    UITableView * table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"TalkCell" bundle:nil] forCellReuseIdentifier:@"TALK"];
    [table registerNib:[UINib nibWithNibName:@"BCell" bundle:nil] forCellReuseIdentifier:@"B"];
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 44);
    label.text = self.model.title;
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
   
    UILabel * label2 = [[UILabel alloc]init];
    label2.frame = CGRectMake(10, 50,70, 30);
    label2.text = self.model.nickName;
    label2.font = [UIFont systemFontOfSize:12];
    
    UILabel * label3 = [[UILabel alloc]init];
    label3.frame = CGRectMake(70, 50,120, 30);
    label3.text = self.model.createTime;
   label3.font = [UIFont systemFontOfSize:12];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 80)];
    [view addSubview:label];
    [view addSubview:label2];
    [view addSubview:label3];
    table.tableHeaderView = view;
    [self.view addSubview:table];
    self.tableView = table;
}
- (void)loadData
{
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
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - 64 - 44) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    [table registerNib:[UINib nibWithNibName:@"TalkCell" bundle:nil] forCellReuseIdentifier:@"TALK"];
    [table registerNib:[UINib nibWithNibName:@"BCell" bundle:nil] forCellReuseIdentifier:@"B"];
    
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
        
        
       
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 44);
        label.text = title;
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        
        UILabel * label2 = [[UILabel alloc]init];
        label2.frame = CGRectMake(10, 50,70, 30);
        label2.text = nickname;
        label2.font = [UIFont systemFontOfSize:12];
        
        UILabel * label3 = [[UILabel alloc]init];
        label3.frame = CGRectMake(70, 50,150, 30);
        label3.text = createTime;
        label3.font = [UIFont systemFontOfSize:11];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 80)];
        [view addSubview:label];
        [view addSubview:label2];
        [view addSubview:label3];
        table.tableHeaderView = view;
        [self.view addSubview:table];
        self.tableView = table;
        NSLog(@"%@", [NSString stringWithFormat:@"%@" , dict]);
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
    [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"headImg"]];
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
        BCell * cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
         CGSize size = CGSizeMake(300, 1000);
         CGSize labelSize = [cell.descript.text sizeWithFont:cell.descript.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        
        return labelSize.height + 200;
    }
    return 44;
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


@end
