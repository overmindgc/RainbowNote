//
//  NoteListTableViewController.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-1.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteEditViewController.h"
#import "TypeChangeDelegate.h"

@interface NoteListTableViewController : UITableViewController <EditViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) id <TypeChangeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedBar;

@property (nonatomic, strong) NSMutableArray *notes;

@end
