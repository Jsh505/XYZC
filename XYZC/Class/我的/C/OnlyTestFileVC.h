//
//  OnlyTestFileVC.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/14.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SurenBlock)(NSString *name);

@interface OnlyTestFileVC : BaseViewController

@property (nonatomic, copy) SurenBlock sureButtonCilick;

- (instancetype)initWithSureButton:(SurenBlock)sureBlock;
@end
