//
//  AppDelegate.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/17.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)delegate;

- (void)goLogin;

- (void)goHome;

@end

