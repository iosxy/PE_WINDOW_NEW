//
//  fabuViewController.m
//  Product-PEWindow
//
//  Created by huhu on 2019/4/2.
//  Copyright © 2019年 qianfeng. All rights reserved.
//

#import "fabuViewController.h"
#import <AVKit/AVKit.h>
#import "VideoShared.h"
@interface fabuViewController()<UIImagePickerControllerDelegate>

@property(nonatomic,strong) NSURL * videoUrl;
@property(nonatomic,copy) UIButton * chooseButton;
@property(nonatomic,copy) UITextField * textField;
@property(nonatomic,strong) NSURL * filevideoUrl;
@property(nonatomic,strong) UIImage * photo;
@end

@implementation fabuViewController{
    float _count ;
    NSTimer *_timer;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"发布视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    _textField = [[UITextField alloc]init];
    
    _textField.placeholder = @"请输入视频标题";
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(isOldHorizontalPhone ? 100 : 30);
        make.left.mas_equalTo(self.view).offset(15);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view).offset(-15);
    }];
    
     _chooseButton = [UIButton new];
    [_chooseButton setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    _chooseButton.layer.cornerRadius = 5;
    _chooseButton.layer.borderColor = [UIColor grayColor].CGColor;
    _chooseButton.layer.borderWidth = 0.5;
    _chooseButton.layer.masksToBounds = YES;
    [self.view addSubview:_chooseButton];
    [_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.height.width.mas_equalTo(100);
        make.top.mas_equalTo(_textField.mas_bottom).offset(20);
    }];
    [_chooseButton addTarget:self action:@selector(chooseVideo) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)chooseVideo{
    
    NSLog(@"从相册选择");
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    
    picker.delegate=self;
    picker.allowsEditing=NO;
    picker.videoMaximumDuration = 1.0;//视频最长长度
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量
    
    //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
    //这里只选择展示视频
    picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    
    picker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self.navigationController presentViewController:picker animated:YES completion:^{
        
    }];
    
   
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]){
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        NSLog(@"url %@",url);
        self.videoUrl = url;
        [self cropWithVideoUrlStr:url start:0 end:60 completion:^(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess) {
             NSLog(@"outurl %@",outputURL);
            
            self.filevideoUrl = outputURL;
            UIImage * buttonImage =    [self thumbnailImageForVideo:outputURL atTime:0];
            self.photo = buttonImage;
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self.chooseButton setImage:buttonImage forState:UIControlStateNormal];

            }];
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
   
}
//视频裁剪
- (void)cropWithVideoUrlStr:(NSURL *)videoUrl start:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle
{
    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    //获取视频总时长
    Float64 duration = CMTimeGetSeconds(asset.duration);
    NSDate *datenow = [NSDate date];
     NSString *timeSp = [NSString stringWithFormat:@"%d", (long)[datenow timeIntervalSince1970]];
    NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@item.mp4",timeSp]];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    
    //如果文件已经存在，先移除，否则会报无法存储的错误
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:outputPath error:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
        
        exportSession.outputURL =  outputURL;
        //视频文件的类型
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        //输出文件是否网络优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //要截取的开始时间
        CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
        //要截取的总时长
        CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    NSLog(@"合成失败：%@", [[exportSession error] description]);
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                {
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    //成功
                    completionHandle(outputURL, endTime, YES);
                    
                }
                    break;
                default:
                {
                    completionHandle(outputURL, endTime, NO);
                } break;
            }
        }];
    }
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}
- (void)cancle{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)done{
    
    if([_textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入视频标题!"];
    }
    if (self.filevideoUrl == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择需要上传的视频"];
    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_textField.text forKey:@"title"];
    [dic setObject:self.filevideoUrl forKey:@"videourl"];
    [dic setObject:@"10086" forKey:@"type"];
    [dic setObject:self.photo forKey:@"cover"];
    [[VideoShared shared].videoArr addObject:dic];
   
  _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
    
    
}
- (void)timerGo{
    _count += 0.1;
    if (_count >= 1) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
         [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [SVProgressHUD showProgress:_count status:@"正在上传..."];
    }
    
    
    
    
}

@end
