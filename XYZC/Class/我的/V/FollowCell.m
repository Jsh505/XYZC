//
//  FollowCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cilickButton.layer.borderWidth = 1;
    self.cilickButton.layer.borderColor = [UIColor mainColor].CGColor;
    self.cilickButton.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FansModel *)model
{
    _model = model;
    [self.headerImage jsh_sdsetImageWithHeaderimg:model.headPicture];
    self.nameLB.text = model.name;
    
    switch (model.type)
    {
        case 1:
        {
            [self.cilickButton setTitle:@"取消关注" forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            [self.cilickButton setTitle:@"成为好友" forState:UIControlStateNormal];
            break;
        }
        case 3:
        {
            [self.cilickButton setTitle:@"发消息" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (IBAction)morebuttonCilick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(moreButton:Model:)])
    {
        [self.delegate moreButton:sender Model:_model];
    }
}

@end
