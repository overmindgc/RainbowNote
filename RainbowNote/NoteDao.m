//
//  NoteDao.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-4.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "NoteDao.h"

@implementation NoteDao

+ (NoteDao *)sharedManager
{
    static dispatch_once_t once;
    static NoteDao *sharedManager = nil;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
    });
    return sharedManager;
}

- (NSString *)applicationDocumentsDirectoryFile
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
    return path;
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writebleDBPath = [self applicationDocumentsDirectoryFile];
    BOOL dbexits = [fileManager fileExistsAtPath:writebleDBPath];
    if (!dbexits) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NotesList.plist"];
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writebleDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"错误写入文件：‘％@’。", [error localizedDescription]);
        }
    }
}

//插入note
- (int)create:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:model.orderId], model.content, model.leftColor, model.bgColor, model.date, model.fullDate] forKeys:@[@"orderId",@"content",@"leftColor",@"bgColor",@"date",@"fullDate"]];
    
    [array insertObject:dict atIndex:0];
    
    [array writeToFile:path atomically:YES];
    
    return 0;
}

//删除
- (int)remove:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dict in array) {
        int orderId = [[dict objectForKey:@"orderId"] intValue];
        if (orderId == model.orderId) {
            [array removeObject:dict];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    
    return 0;
}

//修改
- (int)modify:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dict in array) {
        int orderId = [[dict objectForKey:@"orderId"] intValue];
        if (orderId == model.orderId) {
            [dict setValue:model.content forKey:@"content"];
            [dict setValue:model.leftColor forKey:@"leftColor"];
            [dict setValue:model.bgColor forKey:@"bgColor"];
            [dict setValue:model.date forKey:@"date"];
            [dict setValue:model.fullDate forKey:@"fullDate"];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    
    return 0;
}

//查询所有
- (NSMutableArray *)findAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array) {
        Note *note = [[Note alloc] init];
        note.orderId = [[dict objectForKey:@"orderId"] intValue];
        note.content = [dict objectForKey:@"content"];
        note.leftColor = [dict objectForKey:@"leftColor"];
        note.bgColor = [dict objectForKey:@"bgColor"];
        note.date = [dict objectForKey:@"date"];
        note.fullDate = [dict objectForKey:@"fullDate"];
        
        [listData addObject:note];
    }
    
    return listData;
}

//根据id查询
- (Note *)findById:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"orderId"] intValue] == model.orderId) {
            Note *note = [[Note alloc] init];
            note.orderId = [[dict objectForKey:@"orderId"] intValue];
            note.content = [dict objectForKey:@"content"];
            note.leftColor = [dict objectForKey:@"leftColor"];
            note.bgColor = [dict objectForKey:@"bgColor"];
            note.date = [dict objectForKey:@"date"];
            note.fullDate = [dict objectForKey:@"fullDate"];
            return note;
        }
    }
    
    return nil;
}

@end
