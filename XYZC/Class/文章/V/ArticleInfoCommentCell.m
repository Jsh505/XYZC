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
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CampusInfoCommentModel *)model
{
    _model = model;
    
    //需要点击的字符不同
    NSString * name = [NSString stringWithFormat:@"%@:",model.nickName];
    NSString *label_text2 = [NSString stringWithFormat:@"%@%@",name,model.commentContent];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    NSRange range = [label_text2 rangeOfString:name];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2D7B4B"] range:range];
    
    self.infoLB.attributedText = attributedString2;
    [self.infoLB yb_addAttributeTapActionWithStrings:@[name] tapClicked:^(NSString *string, NSRange range, NSInteger index)
     {
         if ([self.delegate respondsToSelector:@selector(commentNameLBCilickWithModel:)])
         {
             [self.delegate commentNameLBCilickWithModel:_model];
         }
     }];
    //设置是否有点击效果，默认是YES
    self.infoLB.enabledTapEffect = NO;
}
@end
