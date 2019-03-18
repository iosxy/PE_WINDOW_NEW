//
//  SortViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SortViewController.h"
#import "HotCollectionViewCell.h"
#import "ClassModel.h"
#import "SelectCollectionViewCell.h"
#import "SortDetailViewController.h"
#import "SortWebViewController.h"

@interface SortViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (nonatomic,strong) UICollectionView * collectionView;

/** 数据源  两个分组 */
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
   // self.view.frame = CGRectMake(10, 64, [[UIScreen mainScreen] bounds].size.width - 20, [[UIScreen mainScreen] bounds].size.height);
    
    //组织数据源
    [self createDataSource];
    
    //创建collectionView
    [self createCollectionView];
    
    //代理协议
    
    
}

#pragma mark - lazyLoad
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)createDataSource
{
    [HttpRequest startRequestFromUrl:dSorturl AndParameter:nil returnData:^(NSData *resultData, NSError *error) {
        if (!error) {
            //数据下载成功
            NSDictionary * sortDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray * arr1 = [[NSMutableArray alloc]init];
            NSMutableArray * categoryArr = sortDict[@"category"];
            [categoryArr removeObjectAtIndex:0];
            for (NSDictionary * dict in categoryArr) {
                ClassModel * model = [ClassModel modelWithDictionary:dict];
                [arr1 addObject:model];

            }
            NSMutableArray * arr2 = [[NSMutableArray alloc]init];
            NSMutableArray * market_campArr = sortDict[@"market_camp"];
            [market_campArr removeObjectAtIndex:0];
            for (NSDictionary * dict in market_campArr) {
                ClassModel * model = [ClassModel modelWithDictionary:dict];
                [arr2 addObject:model];
                
            }
            [self.dataSource addObject:arr1];
            [self.dataSource addObject:arr2];
            
            [_collectionView reloadData];
            
        }else
        {
            NSLog(@"error = %@",error);
        }
    }];
    
}


- (void)createCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 64, self.view.width - 20, self.view.height - 64 - 20 - 20) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    
    //添加两个头视图
    UIImageView * oneView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _collectionView.width, 50)];
    
    oneView.image = [UIImage imageNamed:@"hot"];
    
    [_collectionView addSubview:oneView];
    
    UIImageView * twoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 320, _collectionView.width, 50)];
    
    twoView.image = [UIImage imageNamed:@"sele"];
    
    [_collectionView addSubview:twoView];
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HOT"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SELE"];
    
    [self.view addSubview:_collectionView];
}


#pragma  mark - 协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HotCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HOT" forIndexPath:indexPath];
        
        ClassModel * model = self.dataSource[indexPath.section][indexPath.row];
        
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
        
        return cell;
    }
    else
    {
        SelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SELE" forIndexPath:indexPath];
        
        ClassModel * model = self.dataSource[indexPath.section][indexPath.row];
        
        [cell.myImage sd_setImageWithURL:[NSURL URLWithString:model.pic]];
        
        return cell;
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0){
        return 0;
    }
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0){
        return 0;
    }
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //热门分类
        
        return CGSizeMake(self.collectionView.width / 4, self.collectionView.width / 4);
    }
    else
    {
        //小编精选
        return CGSizeMake((self.collectionView.width - 10) / 2, 200);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.width, 50);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    
        //热门分类
        SortDetailViewController * sort = [[SortDetailViewController alloc]init];
        
        ClassModel * model = self.dataSource[indexPath.section][indexPath.row];
        
        sort.cid = model.cid;
        sort.url = model.url;
        //NSLog(@"%@",model.cid);
        sort.myTitle = model.text;
        
        sort.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sort animated:YES];
    }
    
    else
    {
        //小编精选.加载web
        SortWebViewController * sort = [[SortWebViewController alloc]init];
        ClassModel * model = self.dataSource[indexPath.section][indexPath.row];
        sort.url = model.url;
        sort.text = model.text;
        sort.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sort animated:YES];
        
    }
    
    
    
}




@end
