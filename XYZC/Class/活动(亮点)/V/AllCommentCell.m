//
//  AllCommentCell.m
//  XYZC
//
//  Created by 贾仕海 on 2018/2/1.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "AllCommentCell.h"

@implementation AllCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CampusInfoCommentModel *)model
{
    _model = model;
    
    [self.headerImageView jsh_sdsetImageWithHeaderimg:model.headPicture];
    self.nickNameLB.text = model.nickName;
    self.timeLB.text = model.commentTime;
    self.infoLB.text = model.commentContent;
}

@end
