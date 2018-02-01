//
//  GiftCCell.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/29.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "GiftCCell.h"

@implementation GiftCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.labelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FFD400"]] forState:UIControlStateNormal];
    [self.labelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"484848"]] forState:UIControlStateSelected];
    [self.labelButton setTitleColor:[UIColor colorWithHexString:@"484848"] forState:UIControlStateNormal];
    [self.labelButton setTitleColor:[UIColor colorWithHexString:@"FFD400"] forState:UIControlStateSelected];
}


- (void)setModel:(GiftLabelModel *)model
{
    _model = model;
    
    self.labelButton.selected = model.isSeleted;
}
@end
