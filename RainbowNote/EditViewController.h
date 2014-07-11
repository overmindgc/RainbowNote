//
//  EditViewController.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
@class EditViewController;
@class Note;

@protocol EditViewControllerDelegate <NSObject>

- (void)editViewControllerDidCancel:(EditViewController *)controller;
- (void)editViewController:(EditViewController *)controller didAddNote:(Note *)note;
- (void)editViewControllerDeleteNoteWith:(int)orderId;
- (void)editViewControllerOpenLastNote;

@end

@interface EditViewController : UIViewController<UIActionSheetDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id <EditViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftToolBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *centerToolBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolBtn;

@property Note *note;

@end
