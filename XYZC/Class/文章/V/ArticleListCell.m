//
//  ArticleListCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "ArticleListCell.h"

@implementation ArticleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImageView.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MyarticleModel *)model
{
    _model = model;
    self.titleLB.text = model.title;
    self.timeLB.text = model.createDate;
    if (model.isgood == 1)
    {
        self.dianzanButton.selected = YES;
    }
    else
    {
        self.dianzanButton.selected = NO;
    }
    [self.dianzanButton setTitle:[NSString stringWithFormat:@"%d",model.goodnumber] forState:UIControlStateNormal];
    [self.pinglunButton setTitle:[NSString stringWithFormat:@"%d",model.commnumber] forState:UIControlStateNormal];
    [self.backgroundImageView jsh_sdsetImageWithURL:model.artPicture placeholderImage:Default_General_Image];
    [self.headerImageView jsh_sdsetImageWithHeaderimg:model.headPicture];
    self.nameLB.text = model.name;
    self.schoolLB.text = [NSString stringWithFormat:@"%@ %@",model.colleges,model.grade];
    
    if ([NSString is_NulllWithObject:model.labelPicName])
    {
        self.labelImageView.image = [UIImage imageNamed:@"0标签"];
    }
    else
    {
        self.labelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@标签",model.labelPicName]];
    }
    self.labelLB.text = model.labelName;
    self.labelLB.transform=CGAffineTransformMakeRotation(M_PI/4);
}

- (void)setPersonArticleModel:(PersonArticleModel *)personArticleModel
{
    _personArticleModel = personArticleModel;
    
    self.personView.hidden = YES;
    self.headerImageView.hidden = YES;
    self.labelImageView.hidden = YES;
    self.labelLB.hidden = YES;
    self.perSonButton.hidden = YES;
    
    self.titleLB.text = personArticleModel.content;
    self.timeLB.text = personArticleModel.createDate;
    if (personArticleModel.isgood == 1)
    {
        self.dianzanButton.selected = YES;
    }
    else
    {
        self.dianzanButton.selected = NO;
    }
    [self.dianzanButton setTitle:[NSString stringWithFormat:@"%d",personArticleModel.goodnumber] forState:UIControlStateNormal];
    [self.pinglunButton setTitle:[NSString stringWithFormat:@"%d",personArticleModel.commnumber] forState:UIControlStateNormal];
    [self.backgroundImageView jsh_sdsetImageWithURL:personArticleModel.artPicture placeholderImage:Default_General_Image];
}

- (void)setArtileNewModel:(MyArtileNewModel *)ArtileNewModel
{
    _ArtileNewModel = ArtileNewModel;
    
    self.personView.hidden = YES;
    self.headerImageView.hidden = YES;
    self.labelImageView.hidden = YES;
    self.labelLB.hidden = YES;
    self.perSonButton.hidden = YES;
    self.dianzanButton.hidden = YES;
    self.pinglunButton.hidden = YES;
    
    self.titleLB.text = ArtileNewModel.content;
    self.timeLB.text = ArtileNewModel.createDate;
    [self.backgroundImageView jsh_sdsetImageWithURL:ArtileNewModel.pictureName placeholderImage:Default_General_Image];
}

- (IBAction)moreButtonCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(moreButton:)])
    {
        [self.delegate moreButton:sender];
    }
}

- (IBAction)personButtonCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pushPersonWithModel:)])
    {
        [self.delegate pushPersonWithModel:_model];
    }
}

- (IBAction)dianzanButtonCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dianzanButton:Model:)])
    {
        [self.delegate dianzanButton:sender Model:_model];
    }
}

- (IBAction)pinglunButtonCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pinglunButton:)])
    {
        [self.delegate pinglunButton:sender];
    }
}
@end
