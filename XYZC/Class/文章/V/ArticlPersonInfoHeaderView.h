//
//  ArticlPersonInfoHeaderView.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyarticleModel.h"

@interface ArticlPersonInfoHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *grdenImageView;
@property (weak, nonatomic) IBOutlet UIImageView *labelmageView;
@property (weak, nonatomic) IBOutlet UILabel *labelLB;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;

@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UILabel *schoolLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@property (weak, nonatomic) IBOutlet UIButton *fansButton;
@property (weak, nonatomic) IBOutlet UILabel *fansLB;
@property (weak, nonatomic) IBOutlet UIButton *guanzhu1Button;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLB;
@property (weak, nonatomic) IBOutlet UIButton *wenzhangButton;
@property (weak, nonatomic) IBOutlet UILabel *wenzhangLB;

@property (nonatomic, strong) MyarticleModel * model;

@end
