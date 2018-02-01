//
//  PositionListModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/30.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface PositionListModel : BaseModel
/*
 areaId = "\U7687\U59d1\U533a,\U6c88\U5317\U65b0\U533a";
 cityId = "";
 companyId = 4;
 gender = "\U65e0";
 id = 6;
 jobContent = "\U7ba1\U7406\U516c\U53f8\U8d26\U76ee";
 positionName = "\U51fa\U7eb3";
 positionType = "\U5168\U804c";
 qualifications = "\U5403\U82e6\U8010\U52b3";
 recruitsNum = 8;
 releaseTime = "2018-01-18 22:00:03";
 salary = "2001-4000\U5143/\U6708";
 type = "\U8d22\U52a1";
 welfare = "\U4e94\U9669\U4e00\U91d1,\U7ee9\U6548\U5956\U91d1,\U5b9a\U671f\U4f53\U68c0,\U5458\U5de5\U65c5\U6e38";
 workDate = "\U5355\U4f11";
 workTime = "\U5230";
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * positionName;
@property (nonatomic, copy) NSString * positionType;
@property (nonatomic, copy) NSString * releaseTime;
@property (nonatomic, copy) NSString * jobContent;
@property (nonatomic, assign) int recruitsNum;

@end
