//
//  GameViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/18.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "GameViewController.h"
#import "GameModel.h"
#import "GameCollectionViewCell.h"
#import "GameDetailViewController.h"
#import "FootBallDetailVC.h"
#define GAME_URL @"http://u1.tiyufeng.com/board/recommend_board?portalId=15&clientToken=7c98ddd1d8cb729bf66791a192b43748"
@interface GameViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** collection*/
@property(nonatomic,strong)UICollectionView  * collectionView;
/** 数据源*/
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSArray * basketBalldataSource;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.basketBalldataSource = @[@"欧冠篮球",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    
     self.view.frame = CGRectMake(0, SafeAreaTopHeight, self.view.frame.size.width, self.view.frame.size.height - SafeAreaTopHeight);
    [self createCollectionView];
    
    [self loadData];
    _dataSource = [[NSMutableArray alloc]init];
    // 设置返回按钮
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)createCollectionView
{
 
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layOut];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"GameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ID"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
}
- (void)loadData
{
    //获取网络数据
    [YCHNetworking startRequestFromUrl:GAME_URL andParamter:nil returnData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
        NSArray * result = [NSArray modelArrayWithClass:[GameModel class] json:arr];
     //   NSLog(@"%@",[result.firstObject logoPath]);
        _dataSource.array = result;
        
        [_collectionView reloadData];
        
    }];
    
    
    
    
}
#pragma mark - collectionView相关

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameModel * model =self.dataSource[indexPath.row];
   //NSLog(@"%@",model.logoPath);
    GameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    [cell.Log sd_setImageWithURL:[NSURL URLWithString:model.logoPath]];
    cell.nameLabel.text =model.boardName;
   
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 设定每一个元素的大小
    return CGSizeMake(self.view.bounds.size.width / 4, self.view.bounds.size.width / 3);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    GameModel * model = self.dataSource[indexPath.row];
    NSString * gameID = model.json;
    NSRange range = {6,4};
    NSString * str2 = [gameID substringWithRange:range];
    //    NSLog(@"%@",model.ID);
    if ([model.sortNo isEqualToString:@"1"]||[model.sortNo isEqualToString:@"9"]||[str2 isEqualToString:@"4334"]) {
        GameDetailViewController * vc = [[GameDetailViewController alloc]init];
 
    vc.gameID = str2;
    vc.gametitle = model.boardName;
    vc.sortNo = model.sortNo;
        vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    }
else
    {
        FootBallDetailVC * fVC = [[FootBallDetailVC alloc]init];
        fVC.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        fVC.gameID = str2;
        fVC.gameTitle = model.boardName;
        fVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fVC animated:YES];
     
    }
    
}



@end
