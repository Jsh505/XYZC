//
//  ChoseLabelCCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModel.h"

@interface ChoseLabelCCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *labelImage;
@property (weak, nonatomic) IBOutlet UILabel *labelNameLB;

@property (nonatomic, strong) LabelModel * model;

@end
