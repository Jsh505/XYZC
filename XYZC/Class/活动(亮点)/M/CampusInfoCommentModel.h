//
//  CampusInfoCommentModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/2/1.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface CampusInfoCommentModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int commentId;
@property (nonatomic, assign) int commentNum;
@property (nonatomic, copy) NSString * commentTime;
@property (nonatomic, copy) NSString * commentContent;
@property (nonatomic, copy) NSString * headPicture;
@property (nonatomic, copy) NSString * nickName;

@property (nonatomic, strong) NSMutableArray * secondCommentList;

@end
