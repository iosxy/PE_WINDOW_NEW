//
//  FirstViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/18.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "FirstViewController.h"
#import "YXYScrollView.h"
#import "HomeModel.h"
#import "HomeDetailModel.h"
#import "HomeCollectionViewCell.h"
#import "HomeTableViewCell.h"
#import "PicCollectionViewCell.h"
#import "SecondViewController.h"
#import "DetailViewController.h"


@interface FirstViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * collectionView;

/**数据源 */
@property(nonatomic,strong)NSMutableArray * scrollDataSource;

/** collection数据源 */
@property (nonatomic,strong) NSMutableArray * collectionDataSource;

@property (nonatomic,strong) NSMutableArray * collectionSelectDataSource;

/** 下边数据源 */
@property (nonatomic,strong) NSMutableArray * tableViewDataSource;

@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int cid;

@property (nonatomic,strong) UIView * tableHeaderView;

@end

@implementation FirstViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏透明操作
    UIImage * image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createCollectionView];
    
    //添加collectionView数据源
    [self addCollectionDataSource];
    //添加collectionView
    [self addcollectionView];
    //请求数据
    [self loadScrollViewData];
    
    _cid = 0;
    _currentPage = 1;
    [self loadTableViewData];
    [self addDropUpRefresh];
    [self addDropDownRefresh];
    
    
    self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    
}

- (void)createCollectionView
{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - 60) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PIC"];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.tag = 666;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_collectionView];
    
}

- (void)addDropUpRefresh
{
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //清空数据,页数归一
        [self.scrollDataSource removeAllObjects];
        [self.tableViewDataSource removeAllObjects];
        
        _currentPage = 1;
        
        //重新请求
        [self loadScrollViewData];
        [self loadTableViewData];
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
       // [self loadScrollViewData];
        [self loadTableViewData];
    }];
    self.collectionView.footer = footer;
}

#pragma mark - 初始化
- (NSMutableArray *)scrollDataSource
{
    if (_scrollDataSource == nil) {
        _scrollDataSource = [[NSMutableArray alloc]init];
    }
    return _scrollDataSource;
}

- (NSMutableArray *)tableViewDataSource
{
    if (_tableViewDataSource == nil) {
        _tableViewDataSource = [[NSMutableArray alloc]init];
    }
    return _tableViewDataSource;
}
- (NSMutableArray *)collectionDataSource
{
    if (_collectionDataSource == nil) {
        _collectionDataSource = [[NSMutableArray alloc]init];
    }
    return _collectionDataSource;
}

- (NSMutableArray *)collectionSelectDataSource
{
    if (_collectionSelectDataSource == nil) {
        _collectionSelectDataSource = [[NSMutableArray alloc]init];
    }
    return _collectionSelectDataSource;
}


#pragma mark - 加载数据
- (void)loadScrollViewData
{
    [HttpRequest startRequestFromUrl:dscrollViewurl AndParameter:nil returnData:^(NSData *resultData, NSError *error) {
        if (!error) {
            //请求数据成功
            // NSLog(@"%@",resultData);
            NSDictionary * bannersDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * productArr = bannersDict[@"data"];
            
            NSMutableArray * array = [[NSMutableArray alloc]init];
            NSMutableArray * urlArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary * productsDict in productArr) {
                
                HomeModel * model = [[HomeModel alloc]init];
                
                [model modelSetWithDictionary:productsDict];
                
                [urlArr addObject:model.iphoneimgnew];
                
                [array addObject:model];
                
            }
            [self.scrollDataSource setArray:array];
            //创建广告滚动视图
            YKPicScrollView * topad = [YKPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 150) WithImageUrls:urlArr];
            topad.placeImage = [UIImage imageNamed:@"placeholder"];
            
            [topad setImageViewDidTapAtIndex:^(NSInteger index) {
                //webView
                DetailViewController * dvc = [[DetailViewController alloc]init];
                dvc.link = [self.scrollDataSource[index] link];
                dvc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:dvc animated:YES];

            }];
            [_collectionView addSubview:topad];

        }else
        {
            //请求数据失败
            NSLog(@"error = %@",error.localizedDescription);
        }
        
    }];
 
}

- (void)addCollectionDataSource
{
    NSArray * defultImage = @[@"select_btn_pressed",@"womem_btn_default",@"life_btn_default",@"man_btn_default",@"it_btn_default",@"sports_btn_default",@"makeup_btn_default",@"mother_btn_default",@"shoes_btn_default",@"recre_btn_default"];
    NSArray * pressedImage = @[@"select_btn_pressed",@"womem_btn_pressed",@"life_btn_pressed",@"man_btn_pressed",@"it_btn_pressed",@"sports_btn_pressed",@"makeup_btn_pressed",@"mother_btn_pressed",@"shoes_btn_pressed",@"recre_btn_pressed"];
    
    for (int i = 0; i < defultImage.count; i++) {
        
        //UIImage * image1 = [UIImage imageNamed:@"select_btn_default"];
        
        NSString * imagePath = [[NSBundle mainBundle]pathForResource:defultImage[i] ofType:@"png"];
        //设置图片
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
        
        [self.collectionDataSource addObject:image];
    }
    
    for (int i = 0; i < pressedImage.count; i++) {
        NSString * imagePath = [[NSBundle mainBundle]pathForResource:pressedImage[i] ofType:@"png"];
        //设置图片
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
        
        [self.collectionSelectDataSource addObject:image];
        
        
    }
}
- (void)loadTableViewData
{
    
    [HttpRequest startRequestFromUrl:[NSString stringWithFormat:dMainurl,_cid,_currentPage] AndParameter:nil returnData:^(NSData *resultData, NSError *error) {
        if (!error) {
            //请求数据成功
            [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            
            NSDictionary * bannersDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * productArr = bannersDict[@"list"];
            
            NSArray * result = [NSArray modelArrayWithClass:[HomeDetailModel class] json:productArr];
            
            [self.tableViewDataSource addObjectsFromArray:result];
            [self.tableViewDataSource removeObjectAtIndex:0];
            
            if (self.tableViewDataSource.count == 0) {
                self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
            }else
            {
                self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
            }
            
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

- (void)addcollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake( 0, 150, self.view.bounds.size.width, 60) collectionViewLayout:layout];
    
    collectionView.tag = 667;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HOMECOLLECTIONCELL"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [_collectionView addSubview:collectionView];
    
}


#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 667) {
        return self.collectionDataSource.count;
    }
    else
    {
        return self.tableViewDataSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 667) {
        
        HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HOMECOLLECTIONCELL" forIndexPath:indexPath];
        [cell loadDataWithArray:self.collectionDataSource[indexPath.row]];
        
        return cell;
    }
    else
    {
        PicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIC" forIndexPath:indexPath];
        
        [cell loadDataWithModel:self.tableViewDataSource[indexPath.row]];
        // NSLog(@"111");
        return cell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 667) {
        return CGSizeMake(self.view.width / 5, collectionView.height);
    }
    else
    {
        return CGSizeMake((self.view.width - 10) / 2, 200);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 667) {
        return 0;
    }
    else
    {
        return 10;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 667) {
        return 0;
    }
    else
    {
        return 0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //已经选中某一行
    if (collectionView.tag == 667) {
        
        self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
        
        HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [cell loadDataWithArray:self.collectionSelectDataSource[indexPath.row]];
        
        if (indexPath.row != 0) {
            
            NSIndexPath * indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
            
            HomeCollectionViewCell * cell0 = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath0];
            
            NSString * imagePath = [[NSBundle mainBundle]pathForResource:@"select_btn_default" ofType:@"png"];
            //设置图片
            UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
            
            [cell0 loadDataWithArray:image];

        }
        
        _cid = (int)indexPath.row;
        
        //删除数据源
        [self.tableViewDataSource removeAllObjects];
        [self loadTableViewData];
        [self.collectionView reloadData];
    }else
    {
        //已经选中某一行
        //进入商品详情页
//        
       SecondViewController * secondVC = [[SecondViewController alloc]init];
        secondVC.hidesBottomBarWhenPushed = YES;
        secondVC.model = self.tableViewDataSource[indexPath.row];
        [self.navigationController pushViewController:secondVC animated:YES];

    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 667) {
        HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell loadDataWithArray:self.collectionDataSource[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView.tag == 666) {
        return CGSizeMake(self.collectionView.width, 210);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
    
}




@end
