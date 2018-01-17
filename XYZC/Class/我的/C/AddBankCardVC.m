//
//  AddBankCardVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/4.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "AddBankCardVC.h"
#import "BindingBankCardVC.h"

@interface AddBankCardVC ()

@end

@implementation AddBankCardVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"添加银行卡";
    self.view.backgroundColor = [UIColor backgroudColor];
    
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)nextButtonCilick:(id)sender
{
    //下一步
    BindingBankCardVC * vc = [[BindingBankCardVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter


@end
