//
//  ArticleInfoCell.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ArticleInfoCell.h"

@implementation ArticleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)commentButtonCil:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(commentButtonCilickWithModel:)])
    {
        [self.delegate commentButtonCilickWithModel:_campusInfoModel];
    }
}

- (IBAction)headerImageViewCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(headerImageViewCilickWithModel:)])
    {
        [self.delegate headerImageViewCilickWithModel:_campusInfoModel];
    }
}

- (void)setCampusInfoModel:(CampusInfoCommentModel *)campusInfoModel
{
    _campusInfoModel = campusInfoModel;
    
    [self.headerImageView jsh_sdsetImageWithHeaderimg:campusInfoModel.headPicture];
    self.nameLB.text = campusInfoModel.nickName;
    self.timeLB.text = campusInfoModel.commentTime;
    self.infoLB.text = campusInfoModel.commentContent;
}

@end
