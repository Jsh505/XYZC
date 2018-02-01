//
//  CampusInfoHeaderView.m
//  XYZC
//
//  Created by 贾仕海 on 2018/2/1.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "CampusInfoHeaderView.h"

@implementation CampusInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(CampusDisplayListModel *)model
{
    _model = model;
    
    [self.headerImageView jsh_sdsetImageWithURL:model.campuPicture placeholderImage:Default_General_Image];
    self.infoLB.text = model.campusSynopsis;
    self.timeLB.text = [NSString stringWithFormat:@"%d人观看",model.watchTime];
}

@end
