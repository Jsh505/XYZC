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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MyarticleModel *)model
{
    _model = model;
    self.timeLB.text = model.createDate;
    [self.backgroundImageView jsh_sdsetImageWithURL:model.pictureName placeholderImage:Default_General_Image];
    self.titleLB.text = model.title;
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
    if ([self.delegate respondsToSelector:@selector(pushPerson)])
    {
        [self.delegate pushPerson];
    }
}

- (IBAction)dianzanButtonCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dianzanButton:)])
    {
        [self.delegate dianzanButton:sender];
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
