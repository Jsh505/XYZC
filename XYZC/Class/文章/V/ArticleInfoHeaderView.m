//
//  ArticleInfoHeaderView.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ArticleInfoHeaderView.h"

@implementation ArticleInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(MyarticleModel *)model
{
    _model = model;
    
    [self.headerImageView jsh_sdsetImageWithHeaderimg:model.headPicture];
    [self.backgroundImageView jsh_sdsetImageWithURL:model.artPicture placeholderImage:Default_General_Image];
    self.nameLB.text = model.name;
    if ([model.gender isEqualToString:@"男"])
    {
        self.grdenImageView.image = [UIImage imageNamed:@"性别_男"];
    }
    else
    {
        self.grdenImageView.image = [UIImage imageNamed:@"性别_女"];
    }
    self.edutioneLB.text = [NSString stringWithFormat:@"%@ %@",model.colleges,model.grade];
    self.infoLB.text = model.content;
    [self.dianzanButton setTitle:[NSString stringWithFormat:@"%d",model.goodnumber] forState:UIControlStateNormal];
    if (model.isgood == 1)
    {
        self.dianzanButton.selected = YES;
    }
    else
    {
        self.dianzanButton.selected = NO;
    }
    self.timeLB.text = model.createDate;
}

@end
