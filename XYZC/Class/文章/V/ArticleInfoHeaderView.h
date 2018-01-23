//
//  ArticleInfoHeaderView.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyarticleModel.h"

@interface ArticleInfoHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *grdenImageView;
@property (weak, nonatomic) IBOutlet UILabel *edutioneLB;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UIButton *dianzanButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (nonatomic, strong) MyarticleModel * model;

@end
