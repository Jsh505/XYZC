//
//  MyResumeCertificateCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyResumeCertificateCell.h"

@implementation MyResumeCertificateCell

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
    [self.headerImage jsh_sdsetImageWithURL:[model objectForKey:@"pictureName"] placeholderImage:Default_General_Image];
    self.nameLB.text = [model objectForKey:@"certificateName"];
    self.infoLB.text = [model objectForKey:@"content"];
}

@end
