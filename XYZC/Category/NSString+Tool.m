//
//  NSString+Tool.m
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "NSString+Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>

@implementation NSString (Tool)

//当前时间
+ (NSString *)nowDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

//明天
+ (NSString *)nextDate
{
    NSDate * date = [NSDate date];//当前时间
    // NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:nextDay];
    return dateString;
}


//时间格式转换
+ (NSString *)timeExchangeWithType:(NSString *)type timeString:(NSString *)timeString
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:type];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]]];
    return currentDateStr;
}

//md5加密
- (NSString *)md5WithString
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [NSString stringWithString:outputString];
}

//手机号码验证
+ (BOOL)isMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat: @"SELF MATCHES %@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:mobile];
    return isMatch;
}

//邮箱
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [emailTest evaluateWithObject:email];
    return isMatch;
}

//验证码
+ (BOOL)isEmployeeNumber:(NSString *)number
{
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

//正则匹配用户密码6-20位数字和字母组合
+ (BOOL)isPassword:(NSString *)password
{
    NSString *pattern =@"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

//正则匹配用户昵称2-12位
+ (BOOL)isNickName:(NSString *)nickName
{
    NSString *pattern =@"^[\\u4e00-\\u9fa5_a-zA-Z0-9-]{2,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:nickName];
    return isMatch;
    
}

//去掉Html标签
+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

//微信支付相关
//创建发起支付时的sige签名
+ (NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
#warning 注意此处一定要添加上商户密钥
    [contentString appendFormat:@"key=%@", @"c30950e16e1d2bbfee2c451983724144"];
    NSString *result = [self md5:contentString];
    
    NSLog(@"result = %@",result);
    return result;
}

// MD5加密算法
+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
