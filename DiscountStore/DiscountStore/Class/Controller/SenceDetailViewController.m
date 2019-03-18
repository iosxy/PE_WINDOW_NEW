//
//  SenceDetailViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/22.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SenceDetailViewController.h"
#import "DescCollectionViewCell.h"
#import "SecondViewController.h"

@interface SenceDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * collectionView;

/** 数据源 */
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int cid;



@end

@implementation SenceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.view.backgroundColor = [UIColor yellowColor];
    
    _cid = 0;
    _currentPage = 1;
    
    self.navigationItem.title = self.myTitle;
    
    [self loadData];
    [self createCollectionView];
    
    [self addDropUpRefresh];
    [self addDropDownRefresh];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)createCollectionView
{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 60) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"DescCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DESC"];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_collectionView];
    
}

- (void)addDropUpRefresh
{
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //清空数据,页数归一
        [self.dataSource removeAllObjects];
        
        _currentPage = 1;
        
        //重新请求
        [self loadData];
        
        
    }];
    //设置动态图片
    NSArray * imageArray = @[[UIImage imageNamed:@"icon_loading_action1"],[UIImage imageNamed:@"icon_loading_action2"]];
    [header setImages:imageArray forState:MJRefreshStateRefreshing];
    
    
    self.collectionView.header = header;
}
-(void)addDropDownRefresh
{
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //页数增加, 重新加载数据
        _currentPage++;
        [self loadData];
    }];
    self.collectionView.footer = footer;
}


- (void)loadData
{
    [HttpRequest startRequestFromUrl:self.myUrl AndParameter:nil returnData:^(NSData *resultData, NSError *error) {
        if (!error) {
            //请求数据成功
            [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            
            NSDictionary * bannersDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * productArr = bannersDict[@"list"];
            
            NSArray * result = [NSArray modelArrayWithClass:[HomeDetailModel class] json:productArr];
            
            [self.dataSource addObjectsFromArray:result];
            //重新加载数据
            [self.collectionView reloadData];
            
            //去除下拉刷新控件
            [self.collectionView.header endRefreshing];
            [self.collectionView.footer endRefreshing];
            
        }else
        {
            //请求数据失败
            NSLog(@"error = %@",error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            //去除下拉刷新控件
            [self.collectionView.header endRefreshing];
            [self.collectionView.footer endRefreshing];
            
        }
        
    }];
    
}


#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DescCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DESC" forIndexPath:indexPath];
    
    [cell loadDataWithModel:self.dataSource[indexPath.row]];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.width - 10) / 2, 200);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //已经选中某一行
    SecondViewController * secondVC = [[SecondViewController alloc]init];
    secondVC.hidesBottomBarWhenPushed = YES;
    secondVC.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:secondVC animated:YES];
    
}


@end
