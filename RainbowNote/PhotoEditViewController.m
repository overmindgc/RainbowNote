//
//  PhotoEditViewController.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-16.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "PhotoEditViewController.h"
#import "Utils.h"
#import "ImageBrowser.h"

@interface PhotoEditViewController ()
{
    UIActionSheet *sheet;
    BOOL isEdit;
}

@property (nonatomic,retain) UIBarButtonItem *tempRightBarItem;

// statusBarHidden is defined as a property.
@property (nonatomic, assign) BOOL statusBarHidden;

@end

@implementation PhotoEditViewController

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
    isEdit = NO;
    _tempRightBarItem = self.navigationItem.rightBarButtonItem;
    
    if (_note != nil) {
        
        self.navigationItem.rightBarButtonItem = nil;
        
        //创建scrollView
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.bgView.frame.size.height - self.toolBar.frame.size.height)];
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self.view insertSubview:self.scrollView atIndex:0];
        
        //创建图片
        UIImage *orginImg = [UIImage imageWithContentsOfFile:_note.imgPath];
        self.contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 77, 302, 302 / orginImg.size.width * orginImg.size.height)];
        self.contentImage.image = orginImg;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
        self.contentImage.userInteractionEnabled=YES;
        [self.contentImage addGestureRecognizer:tap];
        
        
        [self.scrollView addSubview:self.contentImage];
        //动态内容高度，最小为背景view高度
        float contentHeight = self.contentImage.frame.origin.y + self.contentImage.frame.size.height + 90;
        if (contentHeight < self.bgView.frame.size.height) {
            contentHeight = self.bgView.frame.size.height;
        }
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, contentHeight)];
        
        //创建contentText
        self.contentText = [[UITextField alloc] initWithFrame:CGRectMake(9, 10, 302, 30)];
        [self.contentText setTextColor:[UIColor darkGrayColor]];
        [self.contentText setFont:[UIFont fontWithName:@"微软雅黑" size:20]];
        [self.contentText setBorderStyle:UITextBorderStyleNone];
        [self.contentText setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.contentText setPlaceholder:@"请输入描述文字"];
        self.contentText.delegate = self;
        self.contentText.adjustsFontSizeToFitWidth = YES;
        self.contentText.returnKeyType =UIReturnKeyDone;
        [self.scrollView addSubview:self.contentText];
        self.contentText.text = _note.content;
        
        //创建dateLabel
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 54, 300, 20)];
        [self.dateLabel setTextColor:[UIColor grayColor]];
        [self.dateLabel setFont:[UIFont fontWithName:@"Menlo" size:13]];
        [self.scrollView addSubview:self.dateLabel];
        self.dateLabel.text = _note.fullDate;
        
        //创建分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(9, 45, self.view.frame.size.width - 9, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        [self.scrollView addSubview:line];
    } else
    {
        _note = [[Note alloc] init];
        _note.orderId = 0;
        self.dateLabel.text = [Utils getFullTextDate:[NSDate date]];
        [self.contentText becomeFirstResponder];
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
    if (isEdit == YES) {
        [self.delegate editViewController:self didAddNote:[self getNoteToSave]];
    } else {
        [self.delegate editViewControllerDidCancel:self];
    }
}

- (IBAction)doneClick:(id)sender
{
    [self.delegate editViewController:self didAddNote:[self getNoteToSave]];
}

- (IBAction)editClick:(id)sender {
    isEdit = YES;
    self.navigationItem.rightBarButtonItem = _tempRightBarItem;
//    self.contentText.editable = YES;
    [self.contentText becomeFirstResponder];
}

- (IBAction)deleteClick:(id)sender {
    sheet = [[UIActionSheet alloc] initWithTitle:@""
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Delete Photo", nil];
    // Show the sheet
    [sheet showInView:self.view];
    
}

- (IBAction)actionsClick:(id)sender {

}

//图片点击响应
- (void)magnifyImage
{
    [ImageBrowser showImage:self.contentImage];//调用方法
}

#pragma mark - textfieldDelegates


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isEdit = YES;
    self.navigationItem.rightBarButtonItem = _tempRightBarItem;
}// became first responder

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //如果isEdit不是编辑状态，证明已经按了键盘的完成按钮，这时重置isEdit为编辑状态，用于保存修改
    if (isEdit == NO) {
        isEdit = YES;
    } else {
        isEdit = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isEdit = NO;
    [self.contentText resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
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
    _note.type = @"image";
    _note.content = self.contentText.text;
    _note.fullDate = [Utils getFullTextDate:[NSDate date]];
    _note.date = [Utils getShortTextDate:[NSDate date]];
    return _note;
}
@end
