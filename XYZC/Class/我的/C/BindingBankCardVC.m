//
//  BindingBankCardVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/4.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "BindingBankCardVC.h"
#import "BindingSuccessVC.h"

@interface BindingBankCardVC ()

@end

@implementation BindingBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"绑定银行卡";
    self.view.backgroundColor = [UIColor backgroudColor];
    
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)bindingButtonCilick:(id)sender
{
    //绑定
    BindingSuccessVC * vc = [[BindingSuccessVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

@end
