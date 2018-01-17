//
//  MyarticleModel.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/10.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface MyarticleModel : BaseModel
/*
 articleList 列表字段如下：
 articleid 文章id
 title 标题
 content 内容，
 cdate添加时间
 name 作者姓名
 nickname作者昵称
 userId作者id
 picturename 图片名称
 headpicturename 作者头像图片名称
 school 学校
 grade 年级
 gender 性别
 goodnumber 点赞数
 commnumber 评论数
 isgood  当前用户是否点赞（1  点过 0 未点）
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createDate;
@property (nonatomic, copy) NSString * pictureName;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * userId;

@end
