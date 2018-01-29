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
 
 colleges = "\U5317\U5927";
 commnumber = 3;
 content = "\U7a33\U7a33\U7684\U5e78\U798f";
 createDate = "2018-01-15";
 gender = "\U7537";
 goodnumber = 5;
 grade = "\U4e8c";
 id = 1;
 isgood = 1;
 name = "\U5f20\U4e09";
 nickname = any;
 pictureName = "2.jpg";
 picturename = "2.jpg";
 title = "\U7a33\U7a33\U7684\U5e78\U798f";
 userId = 1;
 */

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * createDate;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * artPicture;
@property (nonatomic, assign) int goodnumber;
@property (nonatomic, assign) int commnumber;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * headPicture;
@property (nonatomic, copy) NSString * colleges;
@property (nonatomic, copy) NSString * grade;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, assign) int isgood;
@property (nonatomic, assign) int userId;

@property (nonatomic, copy) NSString * labelName;
@property (nonatomic, copy) NSString * labelPicName;
@end
