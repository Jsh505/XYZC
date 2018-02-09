//
//  CultivateListModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface CultivateListModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * releaseTime;
@property (nonatomic, copy) NSString * trainingCity;
@property (nonatomic, copy) NSString * trainingCourse;
@property (nonatomic, copy) NSString * trainingPic;
@property (nonatomic, copy) NSString * tuition;
@property (nonatomic, assign) int topDays;
@property (nonatomic, assign) int isTop;
@property (nonatomic, assign) int click;

@end
