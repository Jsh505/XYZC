//
//  MyResumeEducationCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyResumeEducationCell.h"

@implementation MyResumeEducationCell

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
    self.timeLB.text = [NSString stringWithFormat:@"%@-%@",[model objectForKey:@"enrolmentTime"],[model objectForKey:@"graduationTime"]];
    self.collegesLB.text = [NSString stringWithFormat:@"%@ 丨 %@",[model objectForKey:@"school"],[model objectForKey:@"education"]];
    self.typeLB.text = [NSString stringWithFormat:@"主修专业：%@",[model objectForKey:@"major"]];
    self.infoLB.text = [NSString stringWithFormat:@"在校经历：%@",[model objectForKey:@"associationActivity"]];
    
}

@end
