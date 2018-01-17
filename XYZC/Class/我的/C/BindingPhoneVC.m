//
//  BindingPhoneVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BindingPhoneVC.h"

@interface BindingPhoneVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@end

@implementation BindingPhoneVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"绑定手机号";
}


#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)codeButtonCilick:(id)sender
{
    //验证码获取
    self.codeButton.countDownFormat = @"%ds重试";
    [self.codeButton countDownWithTimeInterval:60];
}

- (IBAction)commitButtonCilick:(id)sender
{
    //确定
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

@end
