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

- (void)setModel:(PositionListModel *)model
{
    _model = model;
//    self.headImage
    self.titleLB.text = model.positionName;
    self.priceLB.text = [NSString stringWithFormat:@"%d元/月",model.recruitsNum];
    self.timeLB.text = model.releaseTime;
    self.infoLB.text = model.jobContent;
    self.typeLB.text = model.positionType;
}

- (void)setCultivateListModel:(CultivateListModel *)cultivateListModel
{
    _cultivateListModel = cultivateListModel;
    
    self.titleLB.text = cultivateListModel.trainingCourse;
    self.priceLB.text = cultivateListModel.tuition;
    self.timeLB.text = cultivateListModel.releaseTime;
    self.infoLB.text = cultivateListModel.trainingCity;
    [self.headImage jsh_sdsetImageWithURL:cultivateListModel.trainingPic placeholderImage:Default_General_Image];
    
}

@end
