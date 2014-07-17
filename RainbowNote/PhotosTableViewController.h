//
//  PhotosTableViewController.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-15.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteEditViewController.h"
#import "TypeChangeDelegate.h"
#import "EditViewControllerDelegate.h"

@interface PhotosTableViewController : UITableViewController<EditViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) id <TypeChangeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedBar;

@property (nonatomic, strong) NSMutableArray *notes;

@end
