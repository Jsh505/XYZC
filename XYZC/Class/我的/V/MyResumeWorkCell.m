//
//  MyResumeWorkCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyResumeWorkCell.h"

@implementation MyResumeWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    self.timeLB.text = [NSString stringWithFormat:@"%@-%@",[model objectForKey:@"startDate"],[model objectForKey:@"endDate"]];
    self.nameLB.text = [model objectForKey:@"companyName"];
    self.infoLB.text = [model objectForKey:@"content"];
    
}


@end
