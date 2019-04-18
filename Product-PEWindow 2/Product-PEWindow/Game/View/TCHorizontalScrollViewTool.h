//
//  TCHorizontalScrollViewTool.h
//  GetOn
//
//  Created by Katherine on 2017/3/22.
//  Copyright © 2017年 Tonchema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCHorizontalScrollview.h"
#import "TCImageDownloadView.h"

@interface TCHorizontalScrollViewTool : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) TCHorizontalScrollview *horizontalScrollView;

@property (nonatomic, assign) CGSize imageViewSize;

@property (nonatomic, strong) NSArray *imagUrls;


//设置图片URLS
- (void)setImageUrls:(NSArray *)imageUrls;

//移除所有的ImageView
- (void)removeAllImages;
//Masonry实现
- (void)setImageURLs:(NSArray *)imageURLs;

//Masonry
- (void)removeAllImagesM;

@end
