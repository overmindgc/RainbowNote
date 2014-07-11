//
//  Note.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIColor;

@interface Note : NSObject

@property (nonatomic) int orderId;
@property (nonatomic) NSString *type;//类型，text为文字，image为图片
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *fullDate;
@property (nonatomic) NSString *leftColor;
@property (nonatomic) NSString *bgColor;
@property (nonatomic) NSString *imgPath;

@end
