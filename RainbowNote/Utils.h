//
//  Utils.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

static NSArray *colorDicArray;

static int currId;

static int currIndex;

@interface Utils : NSObject

//初始化颜色静态变量的值，需要在系统加载的时候调用一次
+ (void)initColorDicArray;

//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

//获取全中文完整日期
+(NSString *) getFullTextDate:(NSDate *)date;

//获取简单日期数字
+(NSString *)getShortTextDate:(NSDate *)date;

//随机返回一个颜色对
+ (NSDictionary *)getOneCoupleColor;


@end
