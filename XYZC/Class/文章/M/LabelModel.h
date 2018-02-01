//
//  LabelModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/29.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface LabelModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int count;
@property (nonatomic, copy) NSString * labelName;
@property (nonatomic, copy) NSString * picLabelName;

@property (nonatomic, assign) bool isSeleted;
@end
