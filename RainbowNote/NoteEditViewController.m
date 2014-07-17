//
//  EditViewController.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "NoteEditViewController.h"
#import "Utils.h"

@interface NoteEditViewController ()
{
    UIActionSheet *sheet;
    //保存text原始高度
    float originTextHeight;
}

@property (nonatomic,retain) UIBarButtonItem *tempRightBarItem;

@end

@implementation NoteEditViewController
{
    BOOL isFullScreen;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //监听键盘弹出和中英文切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFullScreen = NO;
    self.contentText.delegate = self;
    originTextHeight = self.contentText.frame.size.height;
    
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
        self.toolBar.backgroundColor = [Utils hexStringToColor:_note.leftColor];
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

- (IBAction)backClick:(id)sender {
    if (self.contentText.editable == YES) {
        [self.delegate editViewController:self didAddNote:[self getNoteToSave]];
    } else {
        [self.delegate editViewControllerDidCancel:self];
    }
}

- (IBAction)doneClick:(id)sender
{
    [self.delegate editViewController:self didAddNote:[self getNoteToSave]];
//    self.navigationItem.rightBarButtonItem = nil;
//    self.contentText.editable = NO;
//    [self.contentText resignFirstResponder];
}

- (IBAction)editClick:(id)sender {
    self.navigationItem.rightBarButtonItem = _tempRightBarItem;
    self.contentText.editable = YES;
    [self.contentText becomeFirstResponder];
}

- (IBAction)deleteClick:(id)sender {
    sheet = [[UIActionSheet alloc] initWithTitle:@""
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Delete Note", nil];
    // Show the sheet
    [sheet showInView:self.view];

}

- (IBAction)actionsClick:(id)sender {
    
}

//键盘改变大小响应
-(void)keyboardWillChangeFrame:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];//更改后的键盘
    
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
	
    //改变textfield的高度
    self.contentText.frame = CGRectMake(self.contentText.frame.origin.x, self.contentText.frame.origin.y, self.contentText.frame.size.width, self.view.frame.size.height - height - 25);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //还原textfield的高度
//    self.contentText.frame = CGRectMake(self.contentText.frame.origin.x, self.contentText.frame.origin.y, self.contentText.frame.size.width, originTextHeight);
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
    _note.type = @"text";
    _note.content = self.contentText.text;
    _note.fullDate = [Utils getFullTextDate:[NSDate date]];
    _note.date = [Utils getShortTextDate:[NSDate date]];
    return _note;
}
@end
