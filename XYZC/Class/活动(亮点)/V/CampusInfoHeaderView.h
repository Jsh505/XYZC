//
//  CampusInfoHeaderView.h
//  XYZC
//
//  Created by 贾仕海 on 2018/2/1.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampusDisplayListModel.h"
#import "EntArtListModel.h"

@interface CampusInfoHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *watchNumLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *dianzanButton;

@property (nonatomic, strong) CampusDisplayListModel * model;
@property (nonatomic, strong) EntArtListModel * entArtListModel;

@end
