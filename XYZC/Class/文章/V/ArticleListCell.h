//
//  ArticleListCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyarticleModel.h"
#import "PersonArticleModel.h"
#import "MyArtileNewModel.h"

@protocol ArticleListCellDelegate <NSObject>

- (void)moreButton:(UIButton *)button;
- (void)pushPersonWithModel:(MyarticleModel *)model;
- (void)dianzanButton:(UIButton *)button Model:(MyarticleModel *)model;
- (void)pinglunButton:(UIButton *)button;

@end

@interface ArticleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *schoolLB;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *dianzanButton;
@property (weak, nonatomic) IBOutlet UIButton *pinglunButton;
@property (weak, nonatomic) IBOutlet UIView *personView;
@property (weak, nonatomic) IBOutlet UIButton *perSonButton;

@property (nonatomic, strong) MyarticleModel * model;
@property (nonatomic, strong) PersonArticleModel * personArticleModel;
@property (nonatomic, strong) MyArtileNewModel * ArtileNewModel;
@property (nonatomic, strong) id <ArticleListCellDelegate> delegate;

@end
