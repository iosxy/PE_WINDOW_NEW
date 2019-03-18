//
//  SortDetailViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/22.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SortDetailViewController.h"
#import "PicCollectionViewCell.h"
#import "SecondViewController.h"



@interface SortDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * collectionView;

/** 数据源 */
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,assign) int currentPage;

@property (nonatomic,copy) NSString * currentUrl;

@property (nonatomic,weak) UIButton * currentButton;

@property (nonatomic,strong) UIView * indicatorView;

@end

@implementation SortDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.view.backgroundColor = [UIColor yellowColor];
    
    _currentPage = 1;
    _currentUrl = self.url;
    self.navigationItem.title = self.myTitle;
    [self addButtons];
    
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

- (void)addButtons
{
    
    NSArray * buttonTitles = @[@"人气",@"销量",@"价格ˆ",@"价格ˇ"];
    
    //添加按钮
    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 38)];
    for (int  i = 0; i < buttonTitles.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * self.view.width / buttonTitles.count, 0, self.view.width / buttonTitles.count,35)];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:SELECTED_COLOR forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            self.currentButton = button;
        }
        button.tag = TAG_BEGIN + i;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [myView addSubview:button];
    }
    self.indicatorView = [[UIView alloc]initWithFrame:CGRectMake( 0.2 * (self.view.width / buttonTitles.count), myView.bounds.size.height - 3, 0.7 * (self.view.width / buttonTitles.count), 3)];
    self.indicatorView.backgroundColor = SELECTED_COLOR;
    [myView addSubview:self.indicatorView];

    [self.view addSubview:myView];
    
}

- (void)buttonClicked:(UIButton *)button
{
    //1.切换选中按钮
    self.currentButton.selected = NO;
    button.selected = YES;
    self.currentButton = button;
    //2.指示视图修改位置
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.frame = CGRectMake( button.frame.origin.x + 0.2 * (self.view.width / 4), self.indicatorView.frame.origin.y, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
    }];
    //3.修改url
    _currentPage = 1;
    [self changeUrl:button.tag - TAG_BEGIN];
    [self.dataSource removeAllObjects];
    [self loadData];
    [self.collectionView reloadData];
    
}


- (void)changeUrl:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            
            NSString * myUrl = [NSString stringWithFormat:dRenqiurl,self.cid,_currentPage];
            _currentUrl = myUrl;
            break;
        }
        case 1:
        {
            NSString * myUrl = [NSString stringWithFormat:dXiaoliangurl,_cid,_currentPage];
            _currentUrl = myUrl;
            break;
        }
        case 2:
        {
            NSString * myUrl = [NSString stringWithFormat:dPriceascurl,_cid,_currentPage];
            _currentUrl = myUrl;
            break;
        }
        case 3:
        {
            NSString * myUrl = [NSString stringWithFormat:dPricedescurl,_cid,_currentPage];
            _currentUrl = myUrl;
            break;
        }
            
        default:
            break;
    }

}




- (void)createCollectionView
{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 102, self.view.width, self.view.height - 102) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PIC"];
    
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
       [self changeUrl:_currentButton.tag - TAG_BEGIN];
        [self loadData];
    }];
    self.collectionView.footer = footer;
}


- (void)loadData
{
    [HttpRequest startRequestFromUrl:_currentUrl AndParameter:nil returnData:^(NSData *resultData, NSError *error) {
        
        if (!error) {
            
            
            NSDictionary * bannersDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * productArr = bannersDict[@"list"];
            
            NSArray * result = [NSArray modelArrayWithClass:[HomeDetailModel class] json:productArr];
          
            if (result.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
            }else
            {
              [self.dataSource addObjectsFromArray:result];
              //请求数据成功
              [SVProgressHUD showSuccessWithStatus:@"加载成功"];
              //重新加载数据
              [self.collectionView reloadData];
                
            }
            
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
    
        PicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIC" forIndexPath:indexPath];
        
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
