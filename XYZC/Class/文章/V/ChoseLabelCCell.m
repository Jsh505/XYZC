//
//  ChoseLabelCCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ChoseLabelCCell.h"

@implementation ChoseLabelCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(LabelModel *)model
{
    _model = model;
    [self.labelImage jsh_sdsetImageWithURL:model.picLabelName placeholderImage:[UIImage imageNamed:@"文章标签未选"]];
    self.labelNameLB.text = model.labelName;
}

@end
