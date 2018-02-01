//
//  GiftCoustomeCCell.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/30.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "GiftCoustomeCCell.h"

@implementation GiftCoustomeCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.labelLB.transform=CGAffineTransformMakeRotation(M_PI/4);
    self.lineView.layer.borderWidth = 2;
    self.lineView.layer.borderColor = [UIColor mainColor].CGColor;
}

@end
