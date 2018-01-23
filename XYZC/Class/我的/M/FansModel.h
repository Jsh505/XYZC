//
//  FansModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/22.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface FansModel : BaseModel

@property (nonatomic, assign) int userId;
@property (nonatomic, copy) NSString * headPicture;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;

@property (nonatomic, assign) int type;

@end
