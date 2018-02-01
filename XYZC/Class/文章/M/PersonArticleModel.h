//
//  PersonArticleModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/29.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface PersonArticleModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int isgood;
@property (nonatomic, assign) int goodnumber;
@property (nonatomic, assign) int commnumber;
@property (nonatomic, copy) NSString * artPicture;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createDate;

@end
