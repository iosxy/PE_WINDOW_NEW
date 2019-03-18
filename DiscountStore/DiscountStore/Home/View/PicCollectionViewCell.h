//
//  PicCollectionViewCell.h
//  DiscountStore
//
//  Created by 游成虎 on 16/4/18.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDetailModel.h"

@interface PicCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UILabel *originpriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;





- (void)loadDataWithModel:(HomeDetailModel *)model;
@end
