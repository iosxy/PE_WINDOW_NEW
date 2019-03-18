//
//  MainDetailVC.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/25.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "MainDetailVC.h"
#import "NewsModel.h"
#import "CommentACell.h"
#import "CommentDetailVC.h"
#define SEARCH_URL @"http://u1.tiyufeng.com/section/content_list?portalId=15&contentType=%@&start=0&id=438&limit=18&clientToken=7c98ddd1d8cb729bf66791a192b43748&keywords=%@"

@interface MainDetailVC ()<UITableViewDataSource, UISearchBarDelegate,UITableViewDelegate>
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;
/** tablevIUe*/
@property(nonatomic,strong)UITableView * tabelView;

@end

@implementation MainDetailVC{
    UISearchBar * _search;
    UILabel * _sizeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if ([self.name isEqualToString:@"收藏"]) {
        [self loadFavoriteView];
    }
    else if ([self.name isEqualToString:@"客服"]){
        [self loadPhone];
    }else if ([self.name isEqualToString:@"设置"]){
        [self loadSetting];
    }else if ([self.name isEqualToString:@"更新"]){
        [self loadRefresh];
    }else if ([self.name isEqualToString:@"搜索"]){
        [self loadSearchData];
    }
}
- (void)loadFavoriteView
{
    
    
    
    
    
}
- (void)loadPhone
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen]bounds].size.width, 300)];
    label.text = @"    本公司客服电话为15515034137,欢迎随时来电咨询!";
    label.textColor = [UIColor brownColor];
    label.numberOfLines = 0;
    [self.view addSubview:label];
}
- (void)loadSetting
{
    UIButton * button = [[UIButton alloc]init];
    button.size = CGSizeMake(100, 100);
    button.center = self.view.center;
    button.layer.cornerRadius = 50;
    button.clipsToBounds = YES;
    
    [button setTitle:@"清空缓存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.backgroundColor = YCOLOR_BROWNCOLOR;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    _sizeLabel = [[UILabel alloc]init];
    _sizeLabel.frame = CGRectMake(button.origin.x, CGRectGetMaxY(button.frame) + 20, 100, 40);
   
    _sizeLabel.text = [NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]]];
    NSLog(@"%@",NSHomeDirectory());
    _sizeLabel.textColor = [UIColor blackColor];
    _sizeLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sizeLabel];
    [self.view addSubview:button];
    
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    //通过枚举遍历法遍历文件夹中的所有文件
    //创建枚举遍历器
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    //首先声明文件名称、文件大小
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //得到当前遍历文件的路径
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        //调用封装好的获取单个文件大小的方法
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);//转换为多少M进行返回
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (void)loadRefresh
{
   
}
- (void)buttonClick
{ [[SDImageCache sharedImageCache]clearDisk];
    [SVProgressHUD showSuccessWithStatus:@"清空缓存成功"];
    _sizeLabel.text = [NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]]];
}
#pragma mark - 搜索相关
- (void)loadSearchData{
   _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen]bounds].size.width, 44)];
    
    _search.placeholder = @"请输入您感兴趣的内容";
    _search.delegate =self;
    [self.view addSubview:_search];
    
    self.dataSource = [[NSMutableArray alloc]init];
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height -120 - 44) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 100;
    [table registerNib:[UINib nibWithNibName:@"CommentACell" bundle:nil] forCellReuseIdentifier:@"ACELL"];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];
    self.tabelView = table;
    self.tabelView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableBack.jpg"]];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentACell * cell = [tableView dequeueReusableCellWithIdentifier:@"ACELL"];
    NewsModel * model = self.dataSource[indexPath.row];
    cell.title.text = model.name;
    if (model.picList.count != 0) {
        [cell.picList sd_setImageWithURL:[NSURL URLWithString:model.picList[0]] ];
    }
    
    return cell;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  //  NSLog(@"键盘上的搜索按钮被点击了");
   // self.dataSource = nil;
    [self.dataSource removeAllObjects];
    NSString * canshu = @"5%7C8%7C29";
    NSString * search = _search.text;
    search = [_search.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * url = [NSString stringWithFormat:SEARCH_URL,canshu,search];
  //  NSLog(@"%@",url);
    [YCHNetworking startRequestFromUrl:url andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * arr = dic[@"results"];
        NSArray * models = [NSArray modelArrayWithClass:[NewsModel class] json:arr];
        [self.dataSource addObjectsFromArray:models];
        if (self.dataSource.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"没有找到相关内容"];
        }
        [self.tabelView reloadData];
    }];
    
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  //  _pointer = _dataSource;
    //[_tableView reloadData];
    // 释放第一响应者并清空文本
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_search resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentDetailVC * vc = [[CommentDetailVC alloc]init];
    NewsModel * model = self.dataSource[indexPath.row];

    vc.contentId = model.contentId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
