//
//  MyResumeHeaderCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyResumeHeaderCell.h"

@implementation MyResumeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editButtonCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(editButton)])
    {
        [self.delegate editButton];
    }
}

- (void)setModel:(UserModel *)model
{
    _model = model;
    [self.headerImage jsh_sdsetImageWithHeaderimg:model.userInfo.pictureName];
    self.genderImage.image = [model.userInfo.gender isEqualToString:@"女"] ? [UIImage imageNamed:@"文章个人性别女"] : [UIImage imageNamed:@"文章个人性别男"];
    self.nameLB.text = [NSString is_NulllWithObject:model.userInfo.name] ? model.username : model.userInfo.name;
    self.infoLB.text = [NSString stringWithFormat:@"%@ 丨 无参数 丨 %@",[NSString is_NulllWithObject:model.userInfo.colleges] ? @"未设置" : model.userInfo.colleges,
                        [NSString is_NulllWithObject:model.userInfo.grade] ? @"未设置" : model.userInfo.grade];
    self.phoneLB.text = [NSString stringWithFormat:@"手机：%@",[NSString is_NulllWithObject:model.userInfo.phone] ? @"" : [UserSignData share].user.userInfo.phone];
    self.emailLB.text = [NSString stringWithFormat:@"邮箱：%@",[NSString is_NulllWithObject:model.userInfo.email] ? @"" : [UserSignData share].user.userInfo.email];
}

@end
