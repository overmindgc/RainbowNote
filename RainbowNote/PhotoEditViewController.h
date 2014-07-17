//
//  PhotoEditViewController.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-16.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewControllerDelegate.h"
#import "Note.h"

@interface PhotoEditViewController : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <EditViewControllerDelegate> delegate;

@property Note *note;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UITextField *contentText;
@property (nonatomic) UIImageView *contentImage;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftToolBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *centerToolBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolBtn;

@end
