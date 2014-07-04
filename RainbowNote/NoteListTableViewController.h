//
//  NoteListTableViewController.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-1.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@interface NoteListTableViewController : UITableViewController <EditViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

@property (nonatomic, strong) NSMutableArray *notes;

@end
