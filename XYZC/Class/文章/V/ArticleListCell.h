//
//  ArticleListCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyarticleModel.h"

@protocol ArticleListCellDelegate <NSObject>

- (void)moreButton:(UIButton *)button;
- (void)pushPerson;
- (void)dianzanButton:(UIButton *)button;
- (void)pinglunButton:(UIButton *)button;

@end

@interface ArticleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *schoolLB;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *dianzanButton;
@property (weak, nonatomic) IBOutlet UIButton *pinglunButton;

@property (nonatomic, strong) MyarticleModel * model;
@property (nonatomic, strong) id <ArticleListCellDelegate> delegate;

@end
