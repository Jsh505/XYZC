//
//  signVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "signVC.h"
#import "HYCalendarView.h"

@interface signVC ()

@property (weak, nonatomic) IBOutlet UIButton *siginButton;

@end

@implementation signVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"签到";
    
    // demo1
    HYCalendarView *calendarView = [[HYCalendarView alloc] init];
    calendarView.frame = CGRectMake(10, JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH-20, SCREEN_WIDTH);
    [self.view addSubview:calendarView];
    
    //设置已经签到的天数日期
    NSMutableArray* _signArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dic in self.siginDatesList)
    {
        [_signArray addObject:[NSNumber numberWithInt:[[[dic objectForKey:@"signDate"] substringFromIndex:6] intValue]]];
    }
    calendarView.signArray = _signArray;
    
    calendarView.date = [NSDate date];
    
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    //日期点击事件
    __weak typeof(HYCalendarView) *weakDemo = calendarView;
    calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        if ([comp day]==day) {
            NSLog(@"%li-%li-%li", year,month,day);
            //根据自己逻辑条件 设置今日已经签到的style 没有签到不需要写
            [weakDemo setStyle_Today_Signed:weakDemo.dayButton];
            
            [self siginButtonCilick:self.siginButton];
        }
    };
    
    for (NSDictionary * dic in self.siginDatesList)
    {
        //判断当天是否签到
        if ([[dic objectForKey:@"signDate"] isEqualToString:[NSString nowDate]])
        {
            [calendarView setStyle_Today_Signed:calendarView.dayButton];
            self.siginButton.selected = YES;
            self.siginButton.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)siginButtonCilick:(id)sender
{
    //立即签到
    if (self.siginButton.selected)
    {
        [MBProgressHUD showInfoMessage:@"今日已签到"];
        return;
    }
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:[NSString nowDate] forKey:@"signDate"];
    
    [PPNetworkHelper POST:@"addSignin.app" parameters:parametersDic hudString:@"签到中..." success:^(id responseObject)
     {
         [MBProgressHUD showInfoMessage:@"签到成功"];
         self.siginButton.selected = YES;
         self.siginButton.userInteractionEnabled = NO;
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

@end
