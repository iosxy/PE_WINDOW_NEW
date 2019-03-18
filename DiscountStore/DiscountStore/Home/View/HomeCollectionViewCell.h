//
//  HomeCollectionViewCell.h
//  DiscountStore
//
//  Created by 游成虎 on 16/4/16.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;


- (void)loadDataWithArray:(UIImage *)image;

@end
