//
//  FindTrainingMainCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/8.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindTrainModel.h"

@interface FindTrainingMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *fuliLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *personNumLB;
@property (weak, nonatomic) IBOutlet UILabel *kechengTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (nonatomic, strong) FindTrainModel * model;

@end
