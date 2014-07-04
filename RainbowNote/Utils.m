//
//  Utils.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "Utils.h"

@implementation Utils

//初始化颜色静态变量的值，需要在系统加载的时候调用一次
+ (void)initColorDicArray
{
    colorDicArray = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"#82DA81",@"left",@"#E2FFE5",@"bg", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"#F7A152",@"left",@"#F8E8CF",@"bg", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"#7EA0F1",@"left",@"#E1E2F7",@"bg", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"#EE858D",@"left",@"#F6E1E0",@"bg", nil],  nil];
}

//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//获取全中文完整日期
+(NSString *) getFullTextDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *fullStr = [formatter stringFromDate:date];
    return fullStr;
}

//获取简单日期数字
+(NSString *)getShortTextDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *shortStr = [formatter stringFromDate:date];
    return shortStr;
}

//返回一个颜色对
+ (NSDictionary *)getOneCoupleColor
{
    if (currIndex < colorDicArray.count - 1) {
        currIndex++;
    } else
    {
        currIndex = 0;
    }
//    currIndex = arc4random() % colorDicArray.count;
    return [colorDicArray objectAtIndex:currIndex];
}

@end
