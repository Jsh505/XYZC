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

- (void)setIsSeleted:(NSString *)isSeleted
{
    if ([isSeleted isEqualToString:@"1"])
    {
        self.labelLB.transform=CGAffineTransformMakeRotation(M_PI/4);
        self.lineView.layer.borderWidth = 2;
        self.lineView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    else
    {
        self.labelLB.transform=CGAffineTransformMakeRotation(M_PI/4);
        self.lineView.layer.borderWidth = 2;
        self.lineView.layer.borderColor = [UIColor mainColor].CGColor;
    }
}

@end
