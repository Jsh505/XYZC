//
//  PositionListModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/30.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface PositionListModel : BaseModel

@property (nonatomic, copy) NSString * areaId;
@property (nonatomic, assign) int cityId;
@property (nonatomic, assign) int companyId;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * jobContent;
@property (nonatomic, copy) NSString * positionName;
@property (nonatomic, copy) NSString * positionType;
@property (nonatomic, copy) NSString * qualifications;
@property (nonatomic, assign) int recruitsNum;
@property (nonatomic, copy) NSString * releaseTime;
@property (nonatomic, copy) NSString * salary;
@property (nonatomic, copy) NSString * siestaTime;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * welfare;
@property (nonatomic, copy) NSString * workDate;
@property (nonatomic, copy) NSString * workTime;

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * companyInfo;
@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, assign) int isDelivery;
@property (nonatomic, copy) NSString * phone;

@end
