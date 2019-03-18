//
//  AddressViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "AddressViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AddressViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
/** 定位Manager */
@property (nonatomic, strong) CLLocationManager * manager;
/** <#name#> */
@property (nonatomic,strong) NSUserDefaults * address;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray * dataSource;
/** 地理编码*/
@property(nonatomic,strong)CLGeocoder * cooder;

@end

@implementation AddressViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"管理地址";
    [self createTableView];
    
    self.addressTextField.delegate = self;
    self.myButton.enabled = NO;
    //添加数据库
    _address = [NSUserDefaults standardUserDefaults];
    NSArray * arr = [_address objectForKey:@"address"];
    if (arr == nil) {
        [_address setObject:@[] forKey:@"address"];
    }
    [self.dataSource setArray:arr];
    [self.dataSource insertObject:@"地址:" atIndex:0];
    
}

- (CLLocationManager *)manager {
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        // 申请权限
        // 权限申请
        if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            // 申请前后台权限
            [_manager requestAlwaysAuthorization];
            // 前权限
            [_manager requestWhenInUseAuthorization];
        }
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _manager;
}
- (CLGeocoder *)cooder{
    if (_cooder == nil) {
        _cooder = [[CLGeocoder alloc]init];
    }
    return _cooder;
}
- (IBAction)location:(id)sender {
    
    // 点击的时候，开始定位
    [self.manager startUpdatingLocation];
    
}

- (void)createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}


- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)loadData
{
    //写入
    NSArray * arr = [_address objectForKey:@"address"];
    //转化为可变数组
    NSMutableArray * arrMul = [NSMutableArray arrayWithArray:arr];
    [arrMul addObject:_addressTextField.text];
    [_address setObject:arrMul forKey:@"address"];
    
    [self.dataSource insertObject:_addressTextField.text atIndex:1];
}

- (IBAction)buttonClicked:(id)sender {
    
    if (_addressTextField.text.length != 0) {
        
        [self loadData];
        [self.tableView reloadData];
        _addressTextField.text = @"";
        [_addressTextField resignFirstResponder];
        
        _addressTextField.clearsOnBeginEditing = YES;
        self.myButton.enabled = NO;
        
    }
    // 停止定位
    [self.manager stopUpdatingLocation];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    self.myButton.enabled = YES;
}

#pragma mark - 协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //NSLog(@"我在这里，你找到我了");
    // locations，按时间先后顺序排列
    //NSLog(@"%ld", locations.count);
    
    //<+21.12350000,+123.45600000> +/- 5.00m (speed -1.00 mps / course -1.00) @ 16/4/1 中国标准时间 上午10:22:33
    // 1.经纬度
    // 2.偏差量
    // 3.速度 （未获取到速度的时候，显示-1）
    // 4.course 航向
    // 5.altitude 海拔高度
    // 6.timestamp 时间戳
   CLLocation * loc = [locations lastObject];
    //NSLog(@"%@", loc);
    
   NSString * toward = nil;
    switch ((int)loc.course / 90) {
        case 0:
            toward = @"北偏东";
            break;
        case 1:
            toward = @"东偏南";
            break;
        case 2:
            toward = @"南偏西";
            break;
        case 3:
            toward = @"西偏北";
            break;
        default:
            break;
    }
    int angle = (int)loc.course % 90;
    
    static CLLocation * oldLoc;
    double distance = 0;
    if (oldLoc != nil) {
        distance = [loc distanceFromLocation:oldLoc];
    }
    oldLoc = loc;
    // 经纬度
    CLLocationCoordinate2D coor = loc.coordinate;
    NSMutableString * str = [NSMutableString stringWithFormat:@"%f",coor.longitude];
    if ([[str substringToIndex:1]isEqualToString:@"-"]) {
        NSRange range = {0,1};
        [str deleteCharactersInRange:range];
        NSLog(@"%.2f -- %@", coor.latitude, str);
    }
    //反地理编码
    CLLocation * loc1 = [[CLLocation alloc]initWithLatitude:coor.latitude longitude: str.floatValue];
    [self.cooder reverseGeocodeLocation:loc1 completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"地理反编码失败");
        }
        else {
            CLPlacemark* clp = placemarks[0];
            NSLog(@"%@--%@---%@",clp.name,clp.thoroughfare,clp.subAdministrativeArea);
            self.addressTextField.text = clp.name;
           self.myButton.enabled = YES;
        }
    }];
    [self.manager stopUpdatingLocation];
}



@end
