//
//  SetVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "SetVC.h"
#import "PassWordSetVC.h"
#import "RemindSetVC.h"

@interface SetVC ()

@end

@implementation SetVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f4f5"];
    self.customNavBar.title = @"设置";
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)passWordSetButtonCilick:(id)sender
{
    //密码设置
    PassWordSetVC * vc = [[PassWordSetVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)notifButtonCilick:(id)sender
{
    //提醒
    RemindSetVC * vc = [[RemindSetVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cheackButtonCilick:(id)sender
{
    //检查更新
}

- (IBAction)logoutButtonCilick:(id)sender
{
    //退出账号
    [[AppDelegate delegate] goLogin];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

@end
