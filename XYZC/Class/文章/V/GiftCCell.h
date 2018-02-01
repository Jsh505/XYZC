//
//  GiftCCell.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/29.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftLabelModel.h"

@interface GiftCCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *labelButton;

@property (nonatomic, strong) GiftLabelModel * model;

@end
