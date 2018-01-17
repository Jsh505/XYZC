//
//  HomeListCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "HomeListCell.h"

@implementation HomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.statusLB.layer.borderWidth = 1;
    self.statusLB.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ArtileModel *)model
{
    _model = model;
//    self.headImage
    self.titleLB.text = model.POSITION_NAME;
    self.priceLB.text = model.SALARY;
    self.timeLB.text = model.RELEASE_TIME;
    self.infoLB.text = model.AREA_ID;
    self.typeLB.text = model.TYPE;
}

@end
