//
//  ArticlPersonInfoHeaderView.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ArticlPersonInfoHeaderView.h"

@implementation ArticlPersonInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.sendMessageButton.layer.borderWidth = 1;
    self.sendMessageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
