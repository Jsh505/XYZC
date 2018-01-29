//
//  CampusDisplayCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "CampusDisplayCell.h"

@implementation CampusDisplayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CampusDisplayListModel *)model
{
    _model = model;
    [self.headImageView jsh_sdsetImageWithURL:model.campuPicture placeholderImage:Default_General_Image];
    self.watchNumberLB.text = [NSString stringWithFormat:@"%d人观看",model.watchTime];
    self.titleLB.text = model.campusAlias;
    self.schoolLB.text = model.campusName;
    self.infoLB.text = model.campusSynopsis;
}

@end
