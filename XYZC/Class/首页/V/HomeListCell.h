//
//  HomeListCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionListModel.h"
#import "CultivateListModel.h"

@interface HomeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;

@property (nonatomic, strong) PositionListModel * model;
@property (nonatomic, strong) CultivateListModel * cultivateListModel;

@end
