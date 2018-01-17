//
//  BaseViewController.m
//  CodeDemo
//
//  Created by wangrui on 2017/5/16.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "WRNavigationBar.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
}

- (void)setupNavBar
{
    [self.view addSubview:self.customNavBar];

    // 设置自定义导航栏背景图片
//    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"millcolorGrad"];
    [self.customNavBar setBarBackgroundColor:[UIColor mainColor]];

    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = [UIColor blackColor];

    if (self.navigationController.childViewControllers.count != 1) {
        
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"返回"]];
    }
}

- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

@end
