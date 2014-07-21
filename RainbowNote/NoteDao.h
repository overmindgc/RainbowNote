//
//  NoteDao.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-4.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface NoteDao : NSObject

+ (NoteDao *)sharedManager;

- (NSString *)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;

//插入note
- (int)create:(Note *)model;
//删除
- (int)remove:(Note *)model andPhoto:(BOOL)isDelete;
//修改
- (int)modify:(Note *)model;
//查询所有
- (NSMutableArray *)findAll;

//查询所有文本类
- (NSMutableArray *)findAllTextListBy:(NSString *)content;

//查询所有照片类
- (NSMutableArray *)findAllPhotoList;

//根据id查询
- (Note *)findById:(Note *)model;

@end
