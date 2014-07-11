//
//  NoteListTableViewController.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-1.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "NoteListTableViewController.h"
#import "Note.h"
#import "ListCell.h"
#import "ImageCell.h"
#import "Utils.h"
#import "EditViewController.h"
#import "NoteDao.h"

@interface NoteListTableViewController ()

@property Note *currNote;

//记录列表顶栏颜色，返回的时候恢复
@property UIColor *tempTopBarColor;

@end

@implementation NoteListTableViewController


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        _tempTopBarColor = self.navigationController.navigationBar.barTintColor;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor grayColor];
    [self hiddenSearchBar];
    
    self.notes = [[NoteDao sharedManager] findAll];

//    UIView *modeView = [[UIView alloc] init];
//    modeView.backgroundColor = [UIColor grayColor];
//    modeView.alpha = 0.4;
//    self.
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.notes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    Note *note = (self.notes)[indexPath.row];
    
    if ([note.type isEqualToString:@"image"]) {
        ImageCell *imgCell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:@"imagecell"];
        [imgCell.imgView initWithImage:[UIImage imageWithContentsOfFile:note.imgPath]];
        imgCell.dateLabel.text = note.date;
        imgCell.leftBg.backgroundColor = [Utils hexStringToColor:note.leftColor];
        imgCell.contentBg.backgroundColor = [Utils hexStringToColor:note.bgColor];
        imgCell.dateLabel.textColor = [Utils hexStringToColor:note.leftColor];
        imgCell.rightImg.backgroundColor = [Utils hexStringToColor:note.leftColor];
        
        cell = imgCell;
    } else
    {
        ListCell *textCell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"textcell"];
        textCell.contentLabel.text = note.content;
        textCell.dateLabel.text = note.date;
        textCell.leftBg.backgroundColor = [Utils hexStringToColor:note.leftColor];
        textCell.contentBg.backgroundColor = [Utils hexStringToColor:note.bgColor];
        textCell.dateLabel.textColor = [Utils hexStringToColor:note.leftColor];
        textCell.rightImg.backgroundColor = [Utils hexStringToColor:note.leftColor];
        
        cell = textCell;
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteNoteWith:(int)indexPath.row];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *currNote = [self.notes objectAtIndex:indexPath.row];
    //赋值给当前所选note
    [self openNoteWith:currNote];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark actions

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    self.searchBar.showsCancelButton = NO;
    [self.view endEditing:YES];
}

- (IBAction)addNewNote:(id)sender {
    //新建就把当前note为nil
    [self openNoteWith:nil];
}

- (IBAction)tackPhoto:(id)sender {
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}


#pragma mark - ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     08
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     09
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     10
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     11
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     12
     * UIImagePickerControllerMediaURL;       // an NSURL
     13
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     14
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     15
     */

    int newImgId = [[NSDate date] timeIntervalSince1970];
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:[NSString stringWithFormat:@"%d.png",newImgId]];

    //取得图片路径
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",newImgId]];

    //创建图片类note对象
    Note *newNote = [[Note alloc] init];
    newNote.orderId = newImgId;
    newNote.type = @"image";
    newNote.imgPath = fullPath;
    newNote.fullDate = [Utils getFullTextDate:[NSDate date]];
    newNote.date = [Utils getShortTextDate:[NSDate date]];
    NSDictionary *couple = [Utils getOneCoupleColor];
    newNote.leftColor = [couple objectForKey:@"left"];
    newNote.bgColor = [couple objectForKey:@"bg"];
    
    [self insertNoteToTop:newNote];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"edit"]) {
        
        EditViewController *editViewController = segue.destinationViewController;
        editViewController.delegate = self;
        editViewController.note = _currNote;
    }
}

#pragma mark - Search Bar delegate funciton

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;

    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //清空重置
    self.searchBar.text = @"";
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    self.notes = [[NoteDao sharedManager] findAll];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //按软键盘右下角的搜索按钮时触发
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

#pragma mark - override edit delegate function

- (void)editViewControllerDidCancel:(EditViewController *)controller
{
    [self doBackToList];
}

- (void)editViewController:(EditViewController *)controller didAddNote:(Note *)addNote
{
    //如果没有id 新建
    if (addNote.orderId == 0) {
        //空的不保存
        NSString *trimmedContent = [addNote.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![trimmedContent isEqual: @""]) {
            addNote.orderId = [[NSDate date] timeIntervalSince1970];
            [self insertNoteToTop:addNote];
        }
    } else { //有id，就删除再添加到第一行
        Note *currNote = [self getNoteWith:addNote.orderId];
        if (currNote != nil) {
            int i = (int)[_notes indexOfObject:currNote];
            [self deleteNoteWith:i];
            [self insertNoteToTop:addNote];
        }
    }
    [self doBackToList];
}

- (void)editViewControllerDeleteNoteWith:(int)orderId
{
    Note *currNote = [self getNoteWith:orderId];
    if (currNote) {
        [self deleteNoteWith:(int)[_notes indexOfObject:currNote]];
    }
}

- (void)editViewControllerOpenLastNote
{
    if (_notes.count > 0) {
        [self openNoteWith:[_notes objectAtIndex:0]];
    } else
    {
        [self doBackToList];
    }
}

#pragma mark - util functions

//打开一条note
- (void)openNoteWith:(Note *)note
{
    _currNote = note;
    [self performSegueWithIdentifier:@"edit" sender:self];
}


//返回列表处理
- (void)doBackToList
{
    self.navigationController.navigationBar.barTintColor = _tempTopBarColor;
    [self.navigationController popToViewController:self animated:YES];
    [self hiddenSearchBar];
}

//第一行插入新note
- (void)insertNoteToTop:(Note *)newNote
{
    [[NoteDao sharedManager] create:newNote];
    [self.notes insertObject:newNote atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//根据id获取note对象
- (Note *)getNoteWith:(int)orderId
{
    Note *searchNote;
    for (Note *n in _notes)
    {
        if (n.orderId == orderId)
        {
            searchNote = n;
            break;
        }
    }
    return searchNote;
}

//删除一条记录
- (void)deleteNoteWith:(int)index
{
    [[NoteDao sharedManager] remove:[_notes objectAtIndex:index]];
    [self.notes removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

//设置偏移隐藏searchBar
- (void)hiddenSearchBar
{
    [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height)];
}

@end
