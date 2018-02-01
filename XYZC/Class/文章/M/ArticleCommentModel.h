//
//  ArticleCommentModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleCommentModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int articleId;
@property (nonatomic, assign) int userId;
@property (nonatomic, copy) NSString * commentTime;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * headPortrait;
@property (nonatomic, copy) NSString * nickName;

@property (nonatomic, strong) NSMutableArray * commentListArray;

@end
