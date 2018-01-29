//
//  FindTrainModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/25.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface FindTrainModel : BaseModel
//result=1 ok cultivate包含字段：机构地址 address,上课开始时间  attendClassEndTime,上课结束时间  attendClassStartTime,公司ID  companyId,公司信息  companyInfo, 公司名称  companyName,课程类型  courseType,节课日期  endDate,机构福利  entWelfare,培训ID  id,ONLINE_CONSULTING   onlineConsulting,联系电话  phone,发布时间  releaseTime,午休终止时间  siestaEndTime,午休起始时间  siestaStartTime, 开课日期  startDate,每班人数  studentsNum,师资力量  teacherStrength,培训内容  trainingContent,培训课程  trainingCourse,培训类型  trainingType,学费  tuition

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * attendClassEndTime;
@property (nonatomic, copy) NSString * attendClassStartTime;
@property (nonatomic, assign) int companyId;
@property (nonatomic, copy) NSString * courseType;
@property (nonatomic, copy) NSString * endDate;
@property (nonatomic, copy) NSString * entWelfare;
@property (nonatomic, copy) NSString * companyInfo;
@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * onlineConsulting;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * releaseTime;
@property (nonatomic, copy) NSString * siestaEndTime;
@property (nonatomic, copy) NSString * siestaStartTime;
@property (nonatomic, copy) NSString * startDate;
@property (nonatomic, assign) int studentsNum;
@property (nonatomic, copy) NSString * teacherStrength;
@property (nonatomic, copy) NSString * trainingContent;
@property (nonatomic, copy) NSString * trainingCourse;
@property (nonatomic, assign) int trainingType;
@property (nonatomic, assign) int tuition;


@end
