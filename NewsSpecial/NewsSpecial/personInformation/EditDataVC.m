//
//  EditDataVC.m
//  xiubo2.0
//
//  Created by iOS1 on 16/1/9.
//  Copyright © 2016年 王芝刚. All rights reserved.
//

#import "EditDataVC.h"
#import "UploadHeaderCell.h"
#import "DataCel1l.h"
#import "EditSignatureVC.h"
#import "ChangeNameVC.h"

@interface EditDataVC ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSData *_picData;
    UIImage *_image;
    NSString *_imagePath;
    UploadHeaderCell *_cell0;
    DataCel1l *_cell1;
    NSString  *_sexModifyTag;
    UIButton *_baocunBtn;
    
    
}
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)UITableView *editDataTV;
/**  */
@property (nonatomic,strong) NSMutableArray * listArray;

@end

@implementation EditDataVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)upload:(EditSignatureVC *)VC Signature:(NSString *)signature{
    self.signatureStr = signature;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDataSource];
    [self addTableView];
    [self personInfo];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //保存图片的路径 f6000087029147babf8bf9aae577c5a9
    _imagePath = [imageDocPath stringByAppendingPathComponent:@"image.png"];
}

- (void)personInfo {
    
}

- (void)saveInfomation {
    
}

- (void) returnView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addDataSource
{
    NSArray * arr1 = @[@{@"title":@"头像",},@{@"title":@"名字"}];
    NSArray * arr2 = @[@{@"title":@"性别"},@{@"title":@"职业"},@{@"title":@"个性签名"}];
    [self.listArray addObject:arr1];
    [self.listArray addObject:arr2];
}
- (void)addTableView {
    self.editDataTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    _editDataTV.showsVerticalScrollIndicator = NO;
    [_editDataTV registerNib:[UINib nibWithNibName:@"UploadHeaderCell" bundle:nil] forCellReuseIdentifier:@"UploadHeaderCell"];
    [_editDataTV registerNib:[UINib nibWithNibName:@"DataCel1l" bundle:nil] forCellReuseIdentifier:@"DataCel1l"];
    
    _editDataTV.delegate = self;
    _editDataTV.dataSource = self;
    
    [self.view addSubview:_editDataTV];
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        _cell0 = [_editDataTV dequeueReusableCellWithIdentifier:@"UploadHeaderCell"];
        _cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_cell0 == nil) {
            _cell0 = [[UploadHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UploadHeaderCell"];
        }
        return _cell0;
    }else
    {
        _cell1 = [_editDataTV dequeueReusableCellWithIdentifier:@"DataCel1l"];
        _cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_cell1 == nil) {
            _cell1 = [[DataCel1l alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DataCel1l"];
        }
        _cell1.nameLabel.text = self.listArray[indexPath.section][indexPath.row][@"title"];
        return _cell1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //头像
            [self changeImage];
        }else
        {
            //名字
            ChangeNameVC * changeName = [[ChangeNameVC alloc]init];
            changeName.title = @"名字";
            changeName.name = @"昵称";
            [self.navigationController pushViewController:changeName animated:NO];
            
        }
    }else
    {
        if (indexPath.row == 0) {
            //性别
            [self changeSex];
            
            
            
        }else if (indexPath.row == 1)
        {
            //职业
            
            
        }else
        {
            //个性签名
            [self goEditSignatureVC];
        }
    }
    
    
    
    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        return 70;
    } else {
        return 46;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 1;
//}

#pragma mark - 性别
- (void)changeSex{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //用户选择了男
        NSLog(@"用户选择了男");
    }];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //用户选择了女
        NSLog(@"用户选择了女");
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [alertVc addAction:picture];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

#pragma mark - 个性签名
- (void)goEditSignatureVC {
    EditSignatureVC *editSingatureVC = [[EditSignatureVC alloc]init];
    editSingatureVC.signStr = @"我是签名";
    [self.navigationController pushViewController:editSingatureVC animated:NO];
}

#pragma mark - 调用相册
- (void)changeImage {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //拍照
        [self takePhoto];
    }];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //从相册选择
        [self LocalPhoto];
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [alertVc addAction:picture];
    [self presentViewController:alertVc animated:YES completion:nil];
    

}
- (void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
//    [picker.navigationBar lt_setBackgroundColor:navColor];
//    picker.navigationBar.barTintColor = navColor;
//    picker.navigationBar.tintColor = FILL_COLOR;
//    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:FILL_COLOR}];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        [_editDataTV reloadData];
    }];
}

-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    if (image != nil) {
        //压缩图片，以便保存
       // image = [image imageScaledInterceptToSize:CGSizeMake(100, 100)];
        
        _picData = UIImagePNGRepresentation(image);
        
        //判断图片是不是png格式的文件
        //        if (UIImagePNGRepresentation(image)) {
        //            //返回为png图像。
        //            _picData = UIImagePNGRepresentation(image);
        //        }else {
        //            //返回为JPEG图像。
        //            _picData = UIImageJPEGRepresentation(image, 1.0);
        //        }
        //保存
        [[NSFileManager defaultManager] createFileAtPath:_imagePath contents:_picData attributes:nil];
        //        NSLog(@"%@",_imagePath);
    }
    //
    [picker dismissViewControllerAnimated:YES completion:^{
        _cell0.headerView1.image = image;
        _image = image;
        [_editDataTV reloadData];
    }];
    
    
}

-(void)viewDidLayoutSubviews
{
    if ([_editDataTV respondsToSelector:@selector(setSeparatorInset:)]) {
        [_editDataTV setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_editDataTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [_editDataTV setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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

@end
