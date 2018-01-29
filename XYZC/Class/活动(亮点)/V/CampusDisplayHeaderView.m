//
//  CampusDisplayHeaderView.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "CampusDisplayHeaderView.h"

@implementation CampusDisplayHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(CampusDisplayListModel *)model
{
    //campusAlias 学校别名;campusName 名称;campusSynopsis 学校简介;watchTime 查看学校次数
    _model = model;
    [self.headerImageView jsh_sdsetImageWithURL:model.campuPicture placeholderImage:Default_General_Image];
    self.watchNumberLB.text = [NSString stringWithFormat:@"%d人观看",model.watchTime];
    self.titleLB.text = [NSString stringWithFormat:@"%@——%@",model.campusAlias,model.campusName];
    self.infoLB.text = model.campusSynopsis;
}

@end
