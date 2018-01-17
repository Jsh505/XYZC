//
//  MyWalletViewController.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyWalletVC.h"
#import "BankCardVC.h"
#import "CapitalRecordVC.h"
#import "WithdrawalsVC.h"

@interface MyWalletVC ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsButton;

@end

@implementation MyWalletVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"我的钱包";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    self.moneyLB.text = [NSString stringWithFormat:@"%.2f",[UserSignData share].user.balance];
    
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"getBalance.app" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
    {
        [UserSignData share].user.balance = [[responseObject objectForKey:@"balance"] floatValue];
        [[UserSignData share] storageData:[UserSignData share].user];
        self.moneyLB.text = [NSString stringWithFormat:@"%.2f",[UserSignData share].user.balance];
    } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
    }];
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)rechargeButtonCilick:(id)sender
{
    //充值
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openCameraAction = [UIAlertAction actionWithTitle:@"银行卡" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *openAlbumAction = [UIAlertAction actionWithTitle:@"微信" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:openCameraAction];
    [alertController addAction:openAlbumAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)withdrawalsButtonCilick:(id)sender
{
    //提现
    WithdrawalsVC * vc = [[WithdrawalsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)CapitalRecordCilick:(id)sender
{
    //资金记录
    CapitalRecordVC * vc = [[CapitalRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)BankCardCilick:(id)sender
{
    //银行卡
    BankCardVC * vc = [[BankCardVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

@end
