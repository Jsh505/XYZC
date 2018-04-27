//
//  AppDelegate.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/27.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "AppDelegate.h"
#import "CYLTabBarControllerConfig.h"
#import "LoginVC.h"
#import "BaseNavigationController.h"
#import <IQKeyboardManager.h>
#import <HyphenateLite/HyphenateLite.h>
#import <KSGuaidViewManager.h>
//微信支付
#import "WXApi.h"

@interface AppDelegate () <WXApiDelegate, CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager* locationManager;

@end

@implementation AppDelegate

+ (instancetype)delegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //引导页
    KSGuaidManager.images = @[[UIImage imageNamed:@"01找工作"],
                              [UIImage imageNamed:@"02爱学习"],
                              [UIImage imageNamed:@"03交朋友"],
                              [UIImage imageNamed:@"04乐生活"]];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    KSGuaidManager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 80);
    
    KSGuaidManager.dismissButtonImage = [UIImage imageNamed:@"立即体验"];
    
    [KSGuaidManager begin];
    
    [self goLogin];
    
    [self.window makeKeyAndVisible];
    
    //键盘处理
    [self configureBoardManager];
    [[UITextField appearance] setTintColor:[UIColor mainColor]];  //改变光标颜色
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1152180119115297#xiaoyuanzhixing"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    EMError *error = [[EMClient sharedClient] loginWithUsername:@"18980623464" password:@"123123"];
    if (!error)
    {
        [[EMClient sharedClient].options setIsAutoLogin:YES];
    }
    
    [self loadCaceData];
    
    //微信支付
    [WXApi registerApp:WX_APPID withDescription:@"校园之窗"];
    
    return YES;
}

- (void)loadCaceData
{
    //获取本地数据  筛选
//    [PPNetworkHelper POST:@"positionList.app" parameters:nil hudString:nil responseCache:^(id responseCache)
//     {
//
//    } success:^(id responseObject)
//    {
//
//    } failure:^(NSString *error)
//    {
//
//    }];
    
    //地区列表 areaList.app
    [PPNetworkHelper POST:@"areaList.app" parameters:nil hudString:nil responseCache:^(id responseCache)
     {
        
    } success:^(id responseObject)
     {
         
     } failure:^(NSString *error)
     {
     }];
}

- (void)goLogin
{
    //登录
    LoginVC * loginVc = [[LoginVC alloc] init];
    BaseNavigationController * loginNav = [[BaseNavigationController alloc] initWithRootViewController:loginVc];
    [self.window setRootViewController:loginNav];
}

- (void)goHome
{
    //主页
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
}

-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=60;
    manager.enableAutoToolbar = NO;
}

//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    return  [WXApi handleOpenURL:url delegate:self];
}


//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void)onResp:(BaseResp*)resp
{
    //启动微信支付的response
    //    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]])
    {
#warning 4.支付返回结果，实际支付结果需要去自己的服务器端查询  由于demo的局限性这里直接使用返回的结果
        // 返回码参考：https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=9_12
        NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@(resp.errCode)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if ([self.delegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [self.delegate loginSuccessByCode:resp2.code];
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil nil];
//            [alert show];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
        [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
        [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

