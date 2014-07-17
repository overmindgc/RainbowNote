//
//  RootViewController.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-15.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "RootViewController.h"
#import "PhotosTableViewController.h"
#import "NoteListTableViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //拿到初始的notelist视图，赋予delegate为自身
    UINavigationController *noteNC = self.viewControllers[0];
    NoteListTableViewController *noteVC = noteNC.viewControllers[0];
    noteVC.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"photos"]) {
        PhotosTableViewController *photosVC = navigationController.viewControllers[0];
        photosVC.delegate = self;
    }
}


#pragma mark typechangedelegates

- (void)pushToNoteListView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)pushToPhotosView
{
    [self performSegueWithIdentifier:@"photos" sender:self];
}

@end
