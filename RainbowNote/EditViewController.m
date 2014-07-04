//
//  EditViewController.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "EditViewController.h"
#import "Utils.h"

@interface EditViewController ()
{
    UIActionSheet *sheet;
}

@property (nonatomic,retain) UIBarButtonItem *tempRightBarItem;

@end

@implementation EditViewController

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
    
    _tempRightBarItem = self.navigationItem.rightBarButtonItem;
    
    if (_note != nil) {
        self.navigationController.navigationBar.barTintColor = [Utils hexStringToColor:_note.leftColor];
        self.bgView.backgroundColor = [Utils hexStringToColor:_note.bgColor];
        self.contentText.text = _note.content;
        self.dateLabel.text = _note.fullDate;
        self.navigationItem.rightBarButtonItem = nil;
        self.contentText.editable = NO;
        self.toolBar.backgroundColor = [Utils hexStringToColor:_note.leftColor];
    } else
    {
        _note = [[Note alloc] init];
        _note.orderId = 0;
        NSDictionary *couple = [Utils getOneCoupleColor];
        _note.leftColor = [couple objectForKey:@"left"];
        _note.bgColor = [couple objectForKey:@"bg"];
        self.navigationController.navigationBar.barTintColor = [Utils hexStringToColor:_note.leftColor];
        self.bgView.backgroundColor = [Utils hexStringToColor:_note.bgColor];
        self.dateLabel.text = [Utils getFullTextDate:[NSDate date]];
        [self.contentText becomeFirstResponder];
    }
//    self.contentText.textColor = self.navigationController.navigationBar.barTintColor;
    for (UIBarButtonItem *item in self.toolBar.items) {
        item.tintColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark actions

- (IBAction)back:(id)sender {
    if (self.contentText.editable == YES) {
        [self.delegate editViewController:self didAddNote:[self getNoteToSave]];
    } else {
        [self.delegate editViewControllerDidCancel:self];
    }
}

- (IBAction)done:(id)sender
{
    [self.delegate editViewController:self didAddNote:[self getNoteToSave]];
}

- (IBAction)edit:(id)sender {
    self.navigationItem.rightBarButtonItem = _tempRightBarItem;
    self.contentText.editable = YES;
    [self.contentText becomeFirstResponder];
}

- (IBAction)delete:(id)sender {
    sheet = [[UIActionSheet alloc] initWithTitle:@""
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Delete Note", nil];
    // Show the sheet
    [sheet showInView:self.view];

}

- (IBAction)actions:(id)sender {
    
}

#pragma mark - actionSheepDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.delegate editViewControllerDeleteNoteWith:_note.orderId];
        [self.delegate editViewControllerOpenLastNote];
    }
}


#pragma mark - util functions

//获取需要保存的note对象
- (Note *)getNoteToSave
{
    if(_note.orderId != 0) {
        _note.orderId = _note.orderId;
    } else {
        _note.orderId = 0;//0代表新建
    }
    _note.content = self.contentText.text;
    _note.fullDate = [Utils getFullTextDate:[NSDate date]];
    _note.date = [Utils getShortTextDate:[NSDate date]];
    return _note;
}
@end
