//
//  FirstViewController.m
//  weiliao
//
//  Created by 游成虎 on 16/11/2.
//  Copyright © 2016年 游成虎. All rights reserved.
//


#import "FirstViewController.h"
#import "NinaPagerView.h"
#import "MineViewController.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface FirstViewController ()<NinaPagerViewDelegate>

@property (nonatomic,strong) NinaPagerView *ninaPagerView;
@property (nonatomic,strong) NSMutableArray *channelArr;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
}
- (void)configUI
{
    [self.ninaPagerView removeFromSuperview];
    self.ninaPagerView = nil;
    [self.view addSubview:[self ninaPagerView]];
}
- (void)configData
{
    [self configUI];
//    @weakify(self)
//    [[BJAFNetwork shareManager]POST:API_URL_SERVER method: BJ_queryVideoChannelByShow parameters:@{} success:^(NSURLSessionDataTask * _Nullable dataTask, id  _Nonnull respone) {
//        @strongify(self)
//        if (CODE_JUDGE) {
//            if ([respone[@"data"][@"channelVOS"] isKindOfClass:[NSArray class]]) {
//                NSArray * channelArr = respone[@"data"][@"channelVOS"];
//                [self.channelArr addObjectsFromArray:[BJVideoTypeModel mj_objectArrayWithKeyValuesArray:channelArr]];
//                [self configUI];
//            }
//        }else{
//            [BJMBPManager showToast:respone[@"subMessage"] currentView:self.view];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
//
//    }];
}

#pragma mark - LazyLoad
- (NinaPagerView *)ninaPagerView {
    if (!_ninaPagerView) {
        NSArray *titleArray = [self ninaTitleArray];
        NSArray *vcsArray = [self ninaDetailVCsArray];
        CGRect pagerRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _ninaPagerView = [[NinaPagerView alloc] initWithFrame:pagerRect WithTitles:titleArray WithVCs:vcsArray];
        _ninaPagerView.ninaPagerStyles = NinaPagerStyleSlideBlock;
        _ninaPagerView.sliderBlockColor = [UIColor yellowColor];
        _ninaPagerView.sliderHeight = 33;
        
        _ninaPagerView.slideBlockCornerRadius = 2;
        _ninaPagerView.delegate = self;
        _ninaPagerView.selectTitleColor = [UIColor redColor];
        _ninaPagerView.unSelectTitleColor = [UIColor lightGrayColor];
        
        _ninaPagerView.titleFont = 13;
        _ninaPagerView.titleScale = 1.0;
        _ninaPagerView.underLineHidden = YES;
        _ninaPagerView.delegate = self;
    }
    return _ninaPagerView;
}
- (NSArray *)ninaTitleArray {
//
//    if (self.channelArr.count) {
//        NSMutableArray * titleArr = [NSMutableArray array];
//        //        [titleArr addObject:@"推荐"];
//        for (BJVideoTypeModel * model in self.channelArr) {
//            [titleArr addObject:model.channelName];
//        }
//        return titleArr;
//    }
    return @[@"模仿",
             @"娱乐",
             @"生活",
             @"小视频"
             ];
}
- (NSMutableArray *)channelArr
{
    if (_channelArr == nil) {
        _channelArr = [NSMutableArray array];
    }
    return _channelArr;
}
- (NSArray *)ninaDetailVCsArray {
    NSMutableArray * viewControllers = [NSMutableArray array];
    
//    if (self.channelArr.count) {
//
//        //        BJLifeViewController *recommend = [[BJLifeViewController alloc] init];
//        //        recommend.isRecommend = YES;
//        //        [viewControllers addObject:recommend];
//        for (BJVideoTypeModel * model in self.channelArr) {
////            if ([model.channelName isEqualToString:@"小视频"]) {
////                BJLittleVideoViewController * forthCrunVC = [[BJLittleVideoViewController alloc]init];
////                forthCrunVC.channelId = model.channelId;
////                [viewControllers addObject:forthCrunVC];
////            }else{
////
////            }
//            MineViewController *firstCrunVC = [[MineViewController alloc] init];
//            [viewControllers addObject:firstCrunVC];
//        }
//        return  viewControllers;
//    }
//    BJLifeViewController *firstCrunVC = [[BJLifeViewController alloc] init];
//    BJLifeViewController *secondCrunVC = [[BJLifeViewController alloc] init];
//    BJLifeViewController *threeCrunVC = [[BJLifeViewController alloc] init];
//    BJLittleVideoViewController * forthCrunVC = [[BJLittleVideoViewController alloc]init];
    MineViewController *firstCrunVC = [[MineViewController alloc] init];
    [viewControllers addObject:firstCrunVC];
//    return @[
//             firstCrunVC,
//             secondCrunVC,
//             threeCrunVC,
//             forthCrunVC,
//             ];
    return  viewControllers;
}

- (void)ninaCurrentPageIndex:(NSInteger)currentPage currentObject:(id)currentObject lastObject:(id)lastObject
{
//    [[BJVideoPlayView shared]resetPlayer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
