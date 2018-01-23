//
//  CampusDisplayListModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/23.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface CampusDisplayListModel : BaseModel

@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int watchTime;
@property (nonatomic, copy) NSString * campusAlias;
@property (nonatomic, copy) NSString * campusName;
@property (nonatomic, copy) NSString * campusSynopsis;
@property (nonatomic, copy) NSString * video;

@end
