//
//  CampusDisplayHeaderView.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampusDisplayListModel.h"
#import "EntArtListModel.h"

@interface CampusDisplayHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *watchNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@property (nonatomic, strong) CampusDisplayListModel * model;
@property (nonatomic, strong) EntArtListModel * entArtListModel;

@end
