//
//  EntArtListModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/2/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface EntArtListModel : BaseModel
/*
entAlias = a;
entName = "\U6dd8\U5b9d";
entPicture = "4.jpg";
entSynopsis = "\U7f51\U5e97";
entVideo = "2.mp4";
id = 1;
watchTime = 3;
 
*/
@property (nonatomic, assign) int id;
@property (nonatomic, assign) int watchTime;
@property (nonatomic, assign) int goodnumber;
@property (nonatomic, assign) int isgood;
@property (nonatomic, copy) NSString * entAlias;
@property (nonatomic, copy) NSString * entName;
@property (nonatomic, copy) NSString * entSynopsis;
@property (nonatomic, copy) NSString * entPicture;
@property (nonatomic, copy) NSString * entVideo;

@end
