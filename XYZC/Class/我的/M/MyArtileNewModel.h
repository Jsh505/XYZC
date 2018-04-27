//
//  MyArtileNewModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/4/24.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface MyArtileNewModel : BaseModel


@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createDate;
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * pictureName;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) int userId;

@end
