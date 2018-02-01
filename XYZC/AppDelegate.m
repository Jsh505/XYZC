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

@interface AppDelegate ()

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

