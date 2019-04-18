//
//  MineViewController.m
//  DiscountStore
//
//  Created by qianfeng on 16/4/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "MineViewController.h"
#import "MainDetailVC.h"
#import "MineTableViewCell.h"
#import "LoginViewController.h"
#import "MyFavoriteViewController.h"
#import "UserModel.h"
@interface MineViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView * tableView;
/**顶部图片 */
@property(nonatomic,strong)UIImageView* topImageView;
/**跟随线条 */
@property(nonatomic,strong)UIView* line;
/**数据源 */
@property(nonatomic,strong)NSMutableArray* dataSource;

@property (nonatomic,weak) UIButton * currentButton;

/** 头像 */
@property (nonatomic,strong) UIButton * photoImageView;

@property (nonatomic,strong)UILabel * namelabel;
//更改昵称
@property (nonatomic,strong) UIButton * updateName;
@property (nonatomic,strong) UIImage * currentImage;
@end

@implementation MineViewController


- (void)viewWillAppear:(BOOL)animated
{

    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"isLogin"]isEqualToString:@"isLogin"]) {
        _isLogin = YES;
    }else{
        _isLogin = NO;
    }
    [self dealHeaderView];
}
- (void)dealHeaderView {
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if (_isLogin == NO) {
        _namelabel.hidden = YES;
        _updateName.hidden = YES;
        [_photoImageView setTitle:@"请先登录" forState:UIControlStateNormal];
        [_photoImageView setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
        _photoImageView.enabled = YES;
    }else
    {
        [_photoImageView setTitle:@"" forState:UIControlStateNormal];
      //  _photoImageView.enabled = NO;
        _namelabel.hidden = NO;
        _updateName.hidden = NO;
        _namelabel.text = @"用户3847892";
        [_photoImageView setBackgroundImage:_currentImage forState:UIControlStateNormal];
        _photoImageView.adjustsImageWhenDisabled = NO;
        [UserModel shared].headImage = _currentImage;
        
    }
    NSString * nickName = [user objectForKey:@"currentUser"];
    if (nickName) {
        _namelabel.text = nickName;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentImage = [UIImage imageNamed:@"默认头像"];
    self.dataSource = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self buildUI];
    [self loadData];
    
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)buildUI
{
    
    
    
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height + 44 ;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height) style:UITableViewStyleGrouped];
    
    //去除间隔线
   // _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    _tableView.contentInset//额外的滑动区域
    _tableView.contentInset = UIEdgeInsetsMake(190, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //xcode6.3 Label 自适应cell高度问题 需要添加额外设置
    //允许自适应操作
    _tableView.rowHeight = UITableViewAutomaticDimension;
    //设置预计行高
    _tableView.rowHeight = 60.0;
    AdjustsScrollViewInsetNever(self, self.tableView);

    [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MINE"];
    
    [self.view addSubview:_tableView];
    //创建顶部视图
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -140, self.view.width,140)];
   _topImageView.backgroundColor = YCOLOR_BROWNCOLOR;
    _topImageView.image = [UIImage imageNamed:@"backImg.jpg"];
    //addsubview的方式加入到tableView上
    [_tableView addSubview:_topImageView];
    _photoImageView = [[UIButton alloc]init];
    _namelabel = [[UILabel alloc]init];
    _namelabel.textColor = RGB(0x333333);
    _namelabel.font = [UIFont systemFontOfSize:16];
    _updateName = [UIButton buttonWithType:UIButtonTypeCustom];
    [_updateName setImage:[UIImage imageNamed:@"更改昵称"] forState:UIControlStateNormal];
    [_updateName addTarget:self action:@selector(updateNameClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"isLogin"]isEqualToString:@"isLogin"]) {
        _isLogin = YES;
    }else{
        _isLogin = NO;
    }
    
    [_photoImageView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_photoImageView addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _photoImageView.backgroundColor = [UIColor whiteColor];
    _photoImageView.layer.cornerRadius = 40;
    _photoImageView.clipsToBounds = YES;
    _photoImageView.size = CGSizeMake(80, 80);
    _photoImageView.center = _topImageView.center;
    _photoImageView.centerY = _topImageView.centerY - 40;

    _namelabel.size = CGSizeMake(120, 30);
    _namelabel.center = _topImageView.center;
    _namelabel.textAlignment = NSTextAlignmentCenter;
    _namelabel.centerY = _topImageView.centerY + 30;
    _updateName.size = CGSizeMake(25, 25);
    _updateName.centerY = _namelabel.centerY;
    _updateName.left = _namelabel.right + 10;
    [_tableView addSubview:_updateName];
    [_tableView addSubview:_namelabel];
    [_tableView addSubview:_photoImageView];
    
    [self dealHeaderView];
    
}
- (void)updateNameClicked {
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField*userNameTextField = alertController.textFields.firstObject;
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * nickName = [userDefaults objectForKey:@"currentUser"];
        nickName = userNameTextField.text;
        _namelabel.text = userNameTextField.text;
        [userDefaults setObject:nickName forKey:@"currentUser"];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=@"请输入昵称";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)loginClicked:(UIButton *)button
{
    if (_isLogin) {
        [self changeImage:_photoImageView];
    }
    LoginViewController * vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)buttonClicked:(UIButton *)button{
    //切换描述(int)button.tag - 500;
    _currentButton = button;
    [_currentButton setTintColor:[UIColor lightGrayColor]];
}

- (void)changeImage:(UIButton *)button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入昵称" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self getFromLibrary];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getFromCamare];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)getFromLibrary{
    // 获取支持的媒体格式
    
    UIImagePickerController * _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    // 判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        // 1、设置图片拾取器上的sourceType
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 2、设置支持的媒体格式
        _imagePickerController.mediaTypes = @[mediaTypes[0]];
        // 3、其他设置
        _imagePickerController.allowsEditing = YES; // 如果设置为NO，当用户选择了图片之后不会进入图像编辑界面。
        // 4、推送图片拾取器控制器
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        
    }


    
}
- (void)getFromCamare{
    // 获取支持的媒体格式
    
    UIImagePickerController * _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    // 判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // 1、设置图片拾取器上的sourceType
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 2、设置支持的媒体格式
        _imagePickerController.mediaTypes = @[mediaTypes[0]];
        // 3、其他设置
        _imagePickerController.allowsEditing = YES; // 如果设置为NO，当用户选择了图片之后不会进入图像编辑界面。
        // 4、推送图片拾取器控制器
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        
    }
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerController *, id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
  
 
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerController *, id> *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
            UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
       //     _photoImageView.image = originalImage;
//            [_photoImageView setBackgroundImage:originalImage forState:UIControlStateNormal];
            _currentImage = originalImage;
        }
    }else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        // UIImage *editedImage = info[@"UIImagePickerControllerEditedImage"];
        // _headPortraitImageView.image = editedImage;
//        [_photoImageView setBackgroundImage:info[@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
      //  _headPortraitImageView.image = info[UIImagePickerControllerEditedImage];
        _currentImage = info[@"UIImagePickerControllerEditedImage"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

- (void)loadData
{
    
    NSArray * array = @[@[
                            @{@"title":@"我的收藏",@"icon":@"收藏"},
                            @{@"title":@"搜索",@"icon":@"search2"}
                          ],
                        @[
                            @{@"title":@"联系客服",@"icon":@"kefu"},
                            @{@"title":@"用户协议",@"icon":@"协议管理"},
                            @{@"title":@"意见反馈",@"icon":@"意见反馈"},
                            @{@"title":@"设置",@"icon":@"设置"}
                            ]
                          ];
    
    [_dataSource setArray:array];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MINE" forIndexPath:indexPath];
    
    [cell loadDataWithDictionary:_dataSource[indexPath.section][indexPath.row]];
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    float offset = scrollView.contentOffset.y;
    if (offset < -150) {
        //1.图片的顶部始终顶在屏幕上方(图片的顶点左边不断的在减小,减小的大小为上方留白)
        CGRect rect = _topImageView.frame;
        rect.origin.y = offset;
        //2.图片的高度随下拉而增大
        rect.size.height = -offset;
        //更改图片显示模式 无论如何缩放,显示比例不变
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.clipsToBounds = YES;
        //重置图片的坐标
        _topImageView.frame = rect;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
  if (indexPath.section == 0 && indexPath.row == 0) {
        //进入收藏
       if (_isLogin == NO) {
           [SVProgressHUD showSuccessWithStatus:@"请先登录"];
           return;
       }
        MyFavoriteViewController * vc = [[MyFavoriteViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    else if (indexPath.section == 0 && indexPath.row == 1) {
        //进入帖子
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"搜索";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        //进入客服
        if (_isLogin == NO) {
            [SVProgressHUD showSuccessWithStatus:@"请先登录"];
            return;
        }
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"客服";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        //进入设置
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"设置";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        //用户协议
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"用户协议";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        //意见反馈
        if (_isLogin == NO) {
            [SVProgressHUD showSuccessWithStatus:@"请先登录"];
            return;
        }
        MainDetailVC * vc = [[MainDetailVC alloc]init];
        vc.name = @"意见反馈";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
 
    
    
}




@end
