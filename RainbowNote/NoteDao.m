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
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:model.orderId], model.type, model.content, model.leftColor, model.bgColor, model.date, model.fullDate, model.smallImgPath, model.imgPath] forKeys:@[@"orderId",@"type",@"content",@"leftColor",@"bgColor",@"date",@"fullDate",@"smallImgPath", @"imgPath"]];
    
    [array insertObject:dict atIndex:0];
    
    [array writeToFile:path atomically:YES];
    
    return 0;
}

//删除
- (int)remove:(Note *)model andPhoto:(BOOL)isDelete
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    //删除plist记录
    for (NSDictionary *dict in array) {
        int orderId = [[dict objectForKey:@"orderId"] intValue];
        if (orderId == model.orderId) {
            [array removeObject:dict];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    
    if ([model.type isEqualToString:@"image"] && isDelete == YES) {
        //删除图片
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![model.imgPath isEqualToString:@""]) {
            [fileManager removeItemAtPath:model.imgPath error:nil];
        }
        if (![model.smallImgPath isEqualToString:@""]) {
            [fileManager removeItemAtPath:model.smallImgPath error:nil];
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
            [dict setValue:model.type forKey:@"type"];
            [dict setValue:model.smallImgPath forKey:@"smallImgPath"];
            [dict setValue:model.imgPath forKey:@"imgPath"];
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
        note.type = [dict objectForKey:@"type"];
        note.smallImgPath = [dict objectForKey:@"smallImgPath"];
        note.imgPath = [dict objectForKey:@"imgPath"];
        note.content = [dict objectForKey:@"content"];
        note.leftColor = [dict objectForKey:@"leftColor"];
        note.bgColor = [dict objectForKey:@"bgColor"];
        note.date = [dict objectForKey:@"date"];
        note.fullDate = [dict objectForKey:@"fullDate"];
        
        [listData addObject:note];
    }
    
    return listData;
}

//查询所有文本类
- (NSMutableArray *)findAllTextList
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"type"] isEqualToString:@"text"]) {
            Note *note = [[Note alloc] init];
            note.orderId = [[dict objectForKey:@"orderId"] intValue];
            note.type = [dict objectForKey:@"type"];
            note.content = [dict objectForKey:@"content"];
            note.leftColor = [dict objectForKey:@"leftColor"];
            note.bgColor = [dict objectForKey:@"bgColor"];
            note.date = [dict objectForKey:@"date"];
            note.fullDate = [dict objectForKey:@"fullDate"];
            
            [listData addObject:note];
        }
    }
    
    return listData;
}

//查询所有照片类
- (NSMutableArray *)findAllPhotoList
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"type"] isEqualToString:@"image"]) {
            Note *note = [[Note alloc] init];
            note.orderId = [[dict objectForKey:@"orderId"] intValue];
            note.type = [dict objectForKey:@"type"];
            note.smallImgPath = [dict objectForKey:@"smallImgPath"];
            note.imgPath = [dict objectForKey:@"imgPath"];
            note.content = [dict objectForKey:@"content"];
            note.leftColor = [dict objectForKey:@"leftColor"];
            note.bgColor = [dict objectForKey:@"bgColor"];
            note.date = [dict objectForKey:@"date"];
            note.fullDate = [dict objectForKey:@"fullDate"];
            
            [listData addObject:note];
        }
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
            note.type = [dict objectForKey:@"type"];
            note.smallImgPath = [dict objectForKey:@"smallImgPath"];
            note.imgPath = [dict objectForKey:@"imgPath"];
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
