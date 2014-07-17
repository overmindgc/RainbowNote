//
//  EditViewControllerDelegate.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-16.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Note;

@protocol EditViewControllerDelegate <NSObject>

- (void)editViewControllerDidCancel:(UIViewController *)controller;
- (void)editViewController:(UIViewController *)controller didAddNote:(Note *)note;
- (void)editViewControllerDeleteNoteWith:(int)orderId;
- (void)editViewControllerOpenLastNote;

@end
