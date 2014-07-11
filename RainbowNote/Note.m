//
//  Note.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "Note.h"

@implementation Note

- (NSString *)type
{
    if (_type != nil) {
        return _type;
    } else
    {
        return @"text";
    }
}

- (NSString *)content
{
    if (_content != nil) {
        return _content;
    } else
    {
        return @"";
    }
}

- (NSString *)imgPath
{
    if (_imgPath != nil) {
        return _imgPath;
    } else
    {
        return @"";
    }
}

@end
