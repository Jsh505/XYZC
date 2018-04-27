//
//  GiftCoustomeCCell.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/30.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCoustomeCCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, copy) NSString * isSeleted;

@end
