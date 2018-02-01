//
//  ArticleInfoCell.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ArticleInfoCell.h"

@implementation ArticleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)commentButtonCil:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(commentButtonCilick)])
    {
        [self.delegate commentButtonCilick];
    }
}

@end
