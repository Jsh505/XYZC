//
//  CompanyModel.h
//  XYZC
//
//  Created by 贾仕海 on 2018/2/10.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseModel.h"

@interface CompanyModel : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * companyInfo;
@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, copy) NSString * phone;

@end
