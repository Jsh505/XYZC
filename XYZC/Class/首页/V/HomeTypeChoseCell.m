//
//  HomeTypeChoseCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "HomeTypeChoseCell.h"

@implementation HomeTypeChoseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)testButtonCilick:(id)sender
{
    [self buttonWithType:testButton];
}

- (IBAction)findJobButtonCilick:(id)sender
{
    [self buttonWithType:findJobButton];
}

- (IBAction)findPeiXunButtonCilick:(id)sender
{
    [self buttonWithType:findPeiXunButton];
}

- (IBAction)tishengButtonCilick:(id)sender
{
    [self buttonWithType:tishengButton];
}

- (void)buttonWithType:(HomeTypeChoseCellButtonType)type
{
    if ([self.delegate respondsToSelector:@selector(choseButtonCilickWithType:)])
    {
        [self.delegate choseButtonCilickWithType:type];
    }
}

@end
