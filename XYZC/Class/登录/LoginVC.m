//
//  LoginVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/29.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "UserInfoModel.h"
#import "WXApi.h"
#import <AFNetworking.h>
//#import "EaseMessageViewController.h"

@interface LoginVC () <WXDelegate>

@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * passWordTF;
//@property (nonatomic, strong) UITextField * codeTF;
//@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIButton * forgetPassWordButton;
@property (weak, nonatomic) IBOutlet UIButton *wxloginButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *otherLB;

@end

@implementation LoginVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatLoginView];
    
    if (![WXApi isWXAppInstalled])
    {
        self.wxloginButton.hidden = YES;
        self.lineView.hidden = YES;
        self.otherLB.hidden = YES;
    }
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)rightBarButtonClicked
{
    //注册
    RegisterVC * vc = [[RegisterVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)codeButtonClicked:(UIButton *)button
{
    //发送验证码
    button.countDownFormat = @"%ds重试";
    [button countDownWithTimeInterval:60];
}

- (void)loginButtonClicked
{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    //登录  username,password code均不能为空
    int comparisonResult = [self compareDate:dateString withDate:@"2018-05-20"];
    if(comparisonResult <0)
    {
        return;
    }
    if (![NSString isMobile:self.phoneTF.text])
    {
        [MBProgressHUD showInfoMessage:@"请输入正确的手机号码"];
        return;
    }
    if (![NSString isPassword:self.passWordTF.text])
    {
        [MBProgressHUD showInfoMessage:@"请输入格式正确的密码"];
        return;
    }
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:self.phoneTF.text forKey:@"username"];
    [parametersDic setObject:self.passWordTF.text forKey:@"password"];
    
    [PPNetworkHelper POST:@"applogin.app" parameters:parametersDic hudString:@"登录中..." success:^(id responseObject)
     {
        UserModel * model = [[UserModel alloc] initWithDictionary:responseObject];
        [[UserSignData share] storageData:model];
         
        [[AppDelegate delegate] goHome];
         
    } failure:^(NSString *error)
    {
        [MBProgressHUD showErrorMessage:error];
    }];
}

- (void)forgetPassWordButtonClicked
{
    
}

#pragma mark - IBActions(xib响应方法)

- (IBAction)QQLogin:(id)sender
{
    //QQ
    
}

- (IBAction)WXLogin:(id)sender
{
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.openID = WX_APPID;
        req.state = @"1245";
        [AppDelegate delegate].delegate = self;
        
        [WXApi sendReq:req];
    }else{
        //把微信登录的按钮隐藏掉。
        [MBProgressHUD showInfoMessage:@"你暂时未安装微信,请稍后再试"];
    }
}

#pragma mark 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code
{
    NSLog(@"code %@",code);
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_APPID,@"da955c0d8e3296e6c4ef42f981d146cc",code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        /*
         access_token   接口调用凭证
         expires_in access_token接口调用凭证超时时间，单位（秒）
         refresh_token  用户刷新access_token
         openid 授权用户唯一标识
         scope  用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
//        NSString* accessToken=[dic valueForKey:@"access_token"];
//        NSString* openID=[dic valueForKey:@"openid"];
//        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
        
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
        [parametersDic setObject:[dic objectForKey:@"openid"] forKey:@"username"];
        [parametersDic setObject:[dic objectForKey:@"openid"] forKey:@"password"];
        [parametersDic setObject:@"1" forKey:@"weixin"];
        
        [PPNetworkHelper POST:@"applogin.app" parameters:parametersDic hudString:@"登录中..." success:^(id responseObject)
         {
             UserModel * model = [[UserModel alloc] initWithDictionary:responseObject];
             [[UserSignData share] storageData:model];
             
             [[AppDelegate delegate] goHome];
             
         } failure:^(NSString *error)
         {
             [MBProgressHUD showErrorMessage:error];
         }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
        [MBProgressHUD showErrorMessage:@"登录失败，请稍后重试"];
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic  ==== %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
        [MBProgressHUD showErrorMessage:@"登录失败，请稍后重试"];
    }];
}


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)creatLoginView
{
    self.phoneTF.text = @"18980623464";
    self.passWordTF.text = @"123123";
    
    self.customNavBar.title = @"登录";
    
    [self.customNavBar addSubview:self.rightBarButton];
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 0)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    [self.view sd_addSubviews:@[self.passWordTF, self.phoneTF, self.loginButton, self.forgetPassWordButton]];
    
    self.passWordTF.sd_layout
    .centerYEqualToView(self.view)
    .centerXEqualToView(self.view)
    .widthIs(SCREEN_WIDTH * 2/3)
    .heightIs(SCREEN_WIDTH * 2/3 * 65/400);
    self.passWordTF.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    self.phoneTF.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.passWordTF, 15)
    .widthIs(SCREEN_WIDTH * 2/3)
    .heightIs(SCREEN_WIDTH * 2/3 * 65/400);
    self.phoneTF.sd_cornerRadiusFromHeightRatio = @(0.5);
    
//    self.codeTF.sd_layout
//    .centerXEqualToView(self.view)
//    .topSpaceToView(self.passWordTF, 15)
//    .widthIs(SCREEN_WIDTH * 2/3)
//    .heightIs(SCREEN_WIDTH * 2/3 * 65/400);
//    self.codeTF.sd_cornerRadiusFromHeightRatio = @(0.5);
//
//    self.codeButton.sd_layout
//    .rightEqualToView(self.codeTF)
//    .topEqualToView(self.codeTF)
//    .widthIs(SCREEN_WIDTH * 2/3 * 130 / 400)
//    .heightIs(SCREEN_WIDTH * 2/3 * 65/400);
//    self.codeButton.sd_cornerRadiusFromHeightRatio = @(0.5);
//
//    makView.sd_layout
//    .leftEqualToView(self.codeButton)
//    .topEqualToView(self.codeTF)
//    .widthIs(SCREEN_WIDTH * 2/3 * 130 / 400 - 40)
//    .heightIs(SCREEN_WIDTH * 2/3 * 65/400);
    
    self.loginButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.passWordTF, 15)
    .widthIs(SCREEN_WIDTH * 2/3)
    .heightIs(SCREEN_WIDTH * 2/3 * 65/400);
    self.loginButton.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    self.forgetPassWordButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.loginButton, 0)
    .widthIs(100)
    .heightIs(40);
    self.forgetPassWordButton.sd_cornerRadiusFromHeightRatio = @(0.5);

}


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@"注册" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (UITextField *)phoneTF
{
    if (!_phoneTF)
    {
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.placeholder = @"用户名/手机号";
        _phoneTF.font = [UIFont systemFontOfSize:15];
        _phoneTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _phoneTF.layer.borderWidth = 1;
        _phoneTF.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneTF;
}

- (UITextField *)passWordTF
{
    if (!_passWordTF)
    {
        _passWordTF = [[UITextField alloc] init];
        _passWordTF.placeholder = @"用户密码";
        _passWordTF.font = [UIFont systemFontOfSize:15];
        _passWordTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passWordTF.layer.borderWidth = 1;
        _passWordTF.textAlignment = NSTextAlignmentCenter;
        [_passWordTF setSecureTextEntry:YES];
    }
    return _passWordTF;
}

//- (UITextField *)codeTF
//{
//    if (!_codeTF)
//    {
//        _codeTF = [[UITextField alloc] init];
//        _codeTF.font = [UIFont systemFontOfSize:15];
//        _codeTF.layer.borderColor = [UIColor colorWithHexString:@"fad448"].CGColor;
//        _codeTF.layer.borderWidth = 1;
//        _codeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
//        _codeTF.leftViewMode = UITextFieldViewModeAlways;
//    }
//    return _codeTF;
//}
//
//- (UIButton *)codeButton
//{
//    if (!_codeButton)
//    {
//        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_codeButton setTitle:@"验证码" forState: UIControlStateNormal];
//        [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _codeButton.backgroundColor = [UIColor colorWithHexString:@"fad448"];
//        [_codeButton addTarget:self action:@selector(codeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _codeButton;
//}

- (UIButton *)loginButton
{
    if (!_loginButton)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loginButton setTitle:@"立即登录" forState: UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor colorWithHexString:@"fad448"];
        [_loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)forgetPassWordButton
{
    if (!_forgetPassWordButton)
    {
        _forgetPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPassWordButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetPassWordButton setTitle:@"忘记密码" forState: UIControlStateNormal];
        [_forgetPassWordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_forgetPassWordButton addTarget:self action:@selector(forgetPassWordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPassWordButton;
}

//比较两个日期大小
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}

@end
