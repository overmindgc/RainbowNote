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
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *fullDate;
@property (nonatomic) NSString *leftColor;
@property (nonatomic) NSString *bgColor;

@end
