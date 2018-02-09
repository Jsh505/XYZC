//
//  FindTrainingMainCell.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/8.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "FindTrainingMainCell.h"

@implementation FindTrainingMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FindTrainModel *)model
{
    _model = model;
    
    self.address.text = model.address;
    self.kechengTypeLB.text = model.courseType;
    self.fuliLB.text = model.entWelfare;
    self.startTimeLB.text = model.releaseTime;
    self.personNumLB.text = [NSString stringWithFormat:@"%d",model.studentsNum];
    self.typeLB.text = [NSString stringWithFormat:@"%d",model.trainingType];
    self.priceLB.text = [NSString stringWithFormat:@"%d",model.tuition];
}

- (void)setPositionListModel:(PositionListModel *)positionListModel
{
    _positionListModel = positionListModel;
    
    self.titleLB_job.text = positionListModel.positionName;
    self.infoLB_job.text = positionListModel.address;
    self.priceLB_job.text = positionListModel.salary;
    self.startTimeLB_job.text = [NSString stringWithFormat:@"%@",positionListModel.releaseTime];
    self.fuliLB_job.text = positionListModel.welfare;
    self.typeLB_job.text = positionListModel.type;
    self.personNumLB_job.text = [NSString stringWithFormat:@"%d人",positionListModel.recruitsNum];
    self.xingbieLB_job.text = positionListModel.gender;
    self.address_job.text = positionListModel.address;
}

@end
