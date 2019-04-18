//
//  MineViewController.m
//  weiliao
//
//  Created by 游成虎 on 16/11/2.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell1.h"
#import "MineTableViewCell2.h"
#import "EditDataVC.h"
#import "chargeVC.h"


#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
@interface MineViewController ()

@property (nonatomic,strong) NSMutableArray * listArray;

@end

@implementation MineViewController
{
    UITableView *_mineTableView;
    EditDataVC *_editDataVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addDataSource];
    [self addTableView];
    
    
    
    
}
- (void)addDataSource
{
    NSArray * arr0 = @[@"头像"];
    NSArray * arr1 = @[@{@"title":@"充值",@"image":@"kefu"},@{@"title":@"收益",@"image":@"kefu"}];
    NSArray * arr2 = @[@{@"title":@"认证",@"image":@"kefu"},@{@"title":@"设置",@"image":@"kefu"}];
    [self.listArray addObject:arr0];
    [self.listArray addObject:arr1];
    [self.listArray addObject:arr2];
}
- (void)addTableView {
//    self.tableView.style = UITableViewStyleGrouped;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell2" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell1" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell1"];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArray[section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MineTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        MineTableViewCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell1" forIndexPath:indexPath];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name.text = self.listArray[indexPath.section][indexPath.row][@"title"];
        cell.leftImage.image = [UIImage imageNamed:self.listArray[indexPath.section][indexPath.row][@"image"]];

        if (indexPath.section == 2 && indexPath.row == 1) {
            cell.rightLabel.hidden = YES;
        }
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //个人信息
        _editDataVC = [[EditDataVC alloc]init];
        _editDataVC.title = @"个人信息";
        [self.navigationController pushViewController:_editDataVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        //充值
        chargeVC * charge = [[chargeVC alloc]init];
        charge.title = @"充值";
        [self.navigationController pushViewController:charge animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        //收益
        
        
        
        
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        //认证
        
    }else {
        //设置
        
        
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }else {
        return 5;
    }
}

#pragma mark - lazy load
- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
