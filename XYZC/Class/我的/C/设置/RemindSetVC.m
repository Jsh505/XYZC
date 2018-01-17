//
//  RemindSetVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "RemindSetVC.h"

@interface RemindSetVC ()

@property (weak, nonatomic) IBOutlet UISwitch *isNotifSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isVoiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isShockSwitch;

@end

@implementation RemindSetVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"提醒";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f4f5"];
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)isNotifSwitch:(id)sender
{
    //通知
}

- (IBAction)isVoiceSwitch:(id)sender
{
    //声音
}

- (IBAction)isShockSwitch:(id)sender
{
    //震动
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

@end
