//
//  SenceViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SenceViewController.h"
#import "ClassModel.h"
#import "ObjectCollectionViewCell.h"
#import "SenceDetailViewController.h"

@interface SenceViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *objcetImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *objectCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;

@property (weak, nonatomic) IBOutlet UIView *myLabelView;

/** 数据源  对象 */
@property (nonatomic,strong) NSMutableArray * objectDataSource;
/** 数据源  标签 */
@property (nonatomic,strong) NSMutableArray * labelDataSource;

@end

@implementation SenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.myLabelView.userInteractionEnabled = YES;
    
    [self loadData];
    
    //设置collectionView
    [self setCollectionView];
}

#pragma mark - lazyLoad
- (NSMutableArray *)objectDataSource
{
    if (_objectDataSource == nil) {
        _objectDataSource = [[NSMutableArray alloc]init];
    }
    return _objectDataSource;
}

- (NSMutableArray *)labelDataSource
{
    if (_labelDataSource == nil) {
        _labelDataSource = [[NSMutableArray alloc]init];
    }
    return _labelDataSource;
}


- (void)loadData {
    
    [HttpRequest startRequestFromUrl:dSenceurl AndParameter:nil returnData:^(NSData *resultData, NSError *error) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        NSArray * objectArr = dict[@"sceneobject_list"];
        NSArray * labelArr = dict[@"scenelabel_list"];
        //object数据
        for (NSDictionary * obj in objectArr) {
            ClassModel * model = [ClassModel modelWithDictionary:obj];
            
            [self.objectDataSource addObject:model];
            
        }
        //label数据
        for (NSDictionary * obj in labelArr) {
            ClassModel * model = [ClassModel modelWithDictionary:obj];
            
            [self.labelDataSource addObject:model];
            
        }
        
        //刷新UI
        [self.objectCollectionView reloadData];
        //填充labelView;
        [self addLabelView];
        
    }];
    
    
}

#pragma mark - label相关
- (void)addLabelView
{
    for (int i = 0; i < self.labelDataSource.count; i++) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((i % 3) * (self.myLabelView.width / 3), 10 + (i / 3) * 30 + (i / 3) * 10, self.myLabelView.width / 3, 25)];
        
        //UILabel * label = [[UILabel alloc]init];
        
        label.userInteractionEnabled = YES;
        label.text = [NSString stringWithFormat:@"#%@   ",[self.labelDataSource[i] title]];
        label.font = [UIFont systemFontOfSize:15];
//        CGSize size = CGSizeMake(300, 100);
//        CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//        label.size = labelSize;
        label.layer.borderWidth = 1;
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 5;
        label.tag = 1000 + i;
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [label addGestureRecognizer:tap];
        
        [self.myLabelView addSubview:label];
        
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    //推入下一级视图
    SenceDetailViewController * sence = [[SenceDetailViewController alloc]init];
    
    UILabel * tapLabel = (UILabel *)tap.view;
    int index = (int)tapLabel.tag - 1000;
    ClassModel * model = self.labelDataSource[index];
    sence.myUrl = model.url;
    sence.myTitle = model.title;
    [self.navigationController pushViewController:sence animated:YES];
    
}

#pragma mark - collectionView相关
- (void)setCollectionView
{
    self.objectCollectionView.delegate = self;
    self.objectCollectionView.dataSource = self;
    self.objectCollectionView.backgroundColor = [UIColor whiteColor];
    [self.objectCollectionView registerNib:[UINib nibWithNibName:@"ObjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OBJECT"];
    
}

#pragma mark - 协议代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ObjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OBJECT" forIndexPath:indexPath];
    ClassModel * model = self.objectDataSource[indexPath.row];
    
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.objectDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.width - 20) / 3, (collectionView.height - 20) / 2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //推入下一级视图
    SenceDetailViewController * sence = [[SenceDetailViewController alloc]init];
    
    ClassModel * model = self.objectDataSource[indexPath.row];
    sence.myTitle = model.title;
    sence.myUrl = model.url;
    [self.navigationController pushViewController:sence animated:YES];
    
}





@end
