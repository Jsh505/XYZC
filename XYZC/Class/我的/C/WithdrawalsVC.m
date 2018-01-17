//
//  WithdrawalsVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/4.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "WithdrawalsVC.h"
#import "BRStringPickerView.h"

@interface WithdrawalsVC ()

@end

@implementation WithdrawalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"提现";
    self.view.backgroundColor = [UIColor backgroudColor];
    
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)bankButtonCilick:(id)sender
{
    
}

- (IBAction)openBankButtonCilick:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [BRStringPickerView showStringPickerWithTitle:@"请选择银行卡" dataSource:@[@"农业银行",@"商业银行",@"建设银行"] defaultSelValue:@"农业银行" isAutoSelect:YES resultBlock:^(id selectValue)
     {
         
     }];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

@end
