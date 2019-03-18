//
//  SecondViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/19.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SecondViewController.h"
#import "YXYDatabaseManager.h"
#import "CustomerViewController.h"
#import "AppDelegate.h"
#import "YXYTabbarController.h"

@interface SecondViewController ()

/** 数据库管理者*/
@property (nonatomic,strong)  YXYDatabaseManager * manager;


@property (nonatomic,assign) BOOL isAlreadyFavorite;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentPrice;

@property (weak, nonatomic) IBOutlet UILabel *orginalPrice;

@property (weak, nonatomic) IBOutlet UILabel *fullCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyAllLabel;

@property (weak, nonatomic) IBOutlet UIImageView *safePayImageView;

@property (weak, nonatomic) IBOutlet UIImageView *redImageView;

@property (weak, nonatomic) IBOutlet UIButton *customer;

@property (weak, nonatomic) IBOutlet UIButton *favorite;
@property (weak, nonatomic) IBOutlet UIButton *shoppingcart;

@property (weak, nonatomic) IBOutlet UIButton *immediatelyBuy;

@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置导航栏透明操作
    UIImage * image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // 判断是否收藏过...(判断数据库有没有)
    NSArray * goods1 = [_manager findAllWithTableName:@"favorite"];
    
    for (HomeDetailModel * model in goods1) {
        
        if ([model.num_iid isEqualToString:self.model.num_iid]) {
            [self.favorite setImage:[UIImage imageNamed:@"alreayfavority.png"] forState:UIControlStateNormal];
            _isAlreadyFavorite = YES;
            break;
            
        }else
        {
            [self.favorite setImage:[UIImage imageNamed:@"favority.png"] forState:UIControlStateNormal];
            _isAlreadyFavorite = NO;
        }
    }
    // 判断是否加入购物车过...(判断数据库有没有)
    NSArray * goods2 = [_manager findAllWithTableName:@"cart"];
    
    for (HomeDetailModel * model in goods2) {
        
        if ([model.num_iid isEqualToString:self.model.num_iid]) {
            self.shoppingcart.enabled = NO;
            [self.shoppingcart setTitle:@"已添加到购物车" forState:UIControlStateNormal];
            break;
            
        }
    }
    // 判断是否购买过...(判断数据库有没有)
    NSArray * goods3 = [_manager findAllWithTableName:@"pay"];
    
    for (HomeDetailModel * model in goods3) {
        
        if ([model.num_iid isEqualToString:self.model.num_iid]) {
            self.immediatelyBuy.enabled = NO;
            [self.immediatelyBuy setTitle:@"已购买" forState:UIControlStateNormal];
            break;
            
        }
    }


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    _manager = [YXYDatabaseManager sharedManager];
    
    //填充内容
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic_url] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = self.model.title;
    self.currentPrice.text = [NSString stringWithFormat:@"¥%@",self.model.now_price];
    self.orginalPrice.text = [NSString stringWithFormat:@"¥%@",self.model.origin_price];
    self.fullCountLabel.text = @"全场满29包邮";
    self.soldLabel.text = [NSString stringWithFormat:@"月销售%@笔",self.model.rp_sold];
    self.buyAllLabel.text = @"一站式购齐";
    
    self.safePayImageView.image = [UIImage imageNamed:@"quanzhifu1"];
    self.redImageView.image = [UIImage imageNamed:@"abc.png"];   
    
}
- (IBAction)custumerClicked:(id)sender {
    
    CustomerViewController * cus = [[CustomerViewController alloc]init];
    
    [self.navigationController pushViewController:cus animated:YES];
    
}
- (IBAction)favoriteClicked:(UIButton *)sender {

    if (_isAlreadyFavorite) {
        
        [self.favorite setImage:[UIImage imageNamed:@"favority.png"] forState:UIControlStateNormal];
        _isAlreadyFavorite = NO;
        
        //从数据库删除
       BOOL isSus = [_manager deleteFavoriteWithTableName:@"favorite" andnum_iid:self.model.num_iid];
        if (isSus) {
            
        }else
        {
            NSLog(@"删除失败");
        }
    }
    else
    {
        [self.favorite setImage:[UIImage imageNamed:@"alreayfavority.png"] forState:UIControlStateNormal];
            _isAlreadyFavorite = YES;
        
        //写入数据库
       BOOL isSus = [_manager addFavoriteWithTableName:@"favorite" andDictionary:@{@"num_iid":_model.num_iid,@"title":_model.title,@"origin_price":_model.origin_price,@"now_price":_model.now_price,@"pic_url":_model.pic_url}];
        if (isSus) {
           
        }
        else
        {
            NSLog(@"收藏失败");
        }
    }
    
    

    
}
- (IBAction)shoppingcartClicked:(id)sender {
    
    [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
    
   BOOL isSus = [_manager addFavoriteWithTableName:@"cart" andDictionary:@{@"num_iid":_model.num_iid,@"title":_model.title,@"origin_price":_model.origin_price,@"now_price":_model.now_price,@"pic_url":_model.pic_url}];
    if (isSus) {
        
        self.shoppingcart.enabled = NO;
        [self.shoppingcart setTitle:@"已添加到购物车" forState:UIControlStateNormal];
       
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
       YXYTabbarController * con = (YXYTabbarController *)delegate.window.rootViewController;
       UINavigationController * nav =  con.viewControllers[2];
        nav.tabBarItem.badgeValue = @"1";
        UINavigationController * nav1 =  con.viewControllers[3];
        nav1.tabBarItem.badgeValue = @"1";
    
    }
    else
    {
        NSLog(@"加入购物车失败");
    }

    
}
- (IBAction)immmediatelyClicked:(id)sender {
    
    [SVProgressHUD showSuccessWithStatus:@"购买成功"];
    
    BOOL isSus = [_manager addFavoriteWithTableName:@"pay" andDictionary:@{@"num_iid":_model.num_iid,@"title":_model.title,@"origin_price":_model.origin_price,@"now_price":_model.now_price,@"pic_url":_model.pic_url}];
    if (isSus) {
        self.immediatelyBuy.enabled = NO;
        [self.immediatelyBuy setTitle:@"已购买" forState:UIControlStateNormal];
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        YXYTabbarController * con = (YXYTabbarController *)delegate.window.rootViewController;
        UINavigationController * nav =  con.viewControllers[2];
        nav.tabBarItem.badgeValue = @"1";
        UINavigationController * nav1 =  con.viewControllers[3];
        nav1.tabBarItem.badgeValue = @"1";
    }
    else
    {
        NSLog(@"购买失败");
    }
    
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
