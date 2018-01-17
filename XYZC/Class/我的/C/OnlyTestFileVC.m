//
//  OnlyTestFileVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/14.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "OnlyTestFileVC.h"

@interface OnlyTestFileVC ()

@property (nonatomic, strong) UIButton * rightBarButton;
@property (weak, nonatomic) IBOutlet UITextField *testFile;

@end

@implementation OnlyTestFileVC

- (instancetype)initWithSureButton:(SurenBlock)sureBlock
{
    self = [super init];
    if (self) {
        _sureButtonCilick = sureBlock;
    }
    return self;
}

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroudColor];
    self.customNavBar.title = @"姓名";
    
    [self.customNavBar sd_addSubviews:@[self.rightBarButton]];
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 0)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    if (![NSString is_NulllWithObject:[UserSignData share].user.userInfo.name])
    {
        self.testFile.text = [UserSignData share].user.userInfo.name;
    }
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)rightBarButtonClicked
{
    //保存
    if (self.testFile.text.length == 0 && self.testFile.text.length > 4)
    {
        [MBProgressHUD showInfoMessage:@"请输入正确的姓名"];
        return;
    }
    
    _sureButtonCilick(self.testFile.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@"保存" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}
@end
