//
//  TypeChangeDelegate.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-16.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TypeChangeDelegate <NSObject>

//切换到文字列表
- (void)pushToNoteListView;
//切换到图片列表
- (void)pushToPhotosView;

@end
