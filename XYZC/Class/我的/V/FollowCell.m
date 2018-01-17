//
//  FollowCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cilickButton.layer.borderWidth = 1;
    self.cilickButton.layer.borderColor = [UIColor mainColor].CGColor;
    self.cilickButton.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
