//
//  ArticleInfoCommentCell.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ArticleInfoCommentCell.h"
#import "UILabel+YBAttributeTextTapAction.h"

@implementation ArticleInfoCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //需要点击的字符不同
    NSString *label_text2 = @"回复昵称:内容内容内容内容内容内容";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 5)];
    
    self.infoLB.attributedText = attributedString2;
    [self.infoLB yb_addAttributeTapActionWithStrings:@[@"回复昵称:"] tapClicked:^(NSString *string, NSRange range, NSInteger index)
    {

    }];
    //设置是否有点击效果，默认是YES
    self.infoLB.enabledTapEffect = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
