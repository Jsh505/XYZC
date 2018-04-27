//
//  ArticlPersonInfoHeaderView.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ArticlPersonInfoHeaderView.h"

@implementation ArticlPersonInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.sendMessageButton.layer.borderWidth = 1;
    self.sendMessageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
//    self.labelLB.transform=CGAffineTransformMakeRotation(M_PI/4);
}

- (void)setModel:(MyarticleModel *)model
{
    _model = model;
    self.userNameLB.text = model.name;
    
    [self.headerImageView jsh_sdsetImageWithURL:model.artPicture placeholderImage:Default_General_Image];
    [self.userHeaderImageView jsh_sdsetImageWithHeaderimg:model.headPicture];
    
    self.schoolLB.text = [NSString stringWithFormat:@"%@ %@",model.colleges,model.grade];
    
    if ([NSString is_NulllWithObject:model.labelPicName])
    {
        self.labelmageView.image = [UIImage imageNamed:@"0标签"];
    }
    else
    {
        self.labelmageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@标签",model.labelPicName]];
    }
    self.labelLB.text = model.labelName;
    
}
@end
