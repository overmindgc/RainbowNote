//
//  PhotosTableViewController.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-15.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "Note.h"
#import "PhotoCell.h"
#import "Utils.h"
#import "PhotoEditViewController.h"
#import "NoteDao.h"

#define smallImageWidth  604.0 //压缩图片的宽

@interface PhotosTableViewController ()

@property Note *currNote;

//记录列表顶栏颜色，返回的时候恢复
@property UIColor *tempTopBarColor;

@end

@implementation PhotosTableViewController


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
    
    self.notes = [[NoteDao sharedManager] findAllPhotoList];
    
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
    
    PhotoCell *photoCell = (PhotoCell *)[tableView dequeueReusableCellWithIdentifier:@"imagecell"];
    photoCell.imgView.image = [UIImage imageWithContentsOfFile:note.smallImgPath];
    photoCell.dateLabel.text = note.fullDate;
    if ([note.content isEqualToString:@""]) {
        photoCell.contentLabel.text = @"无描述";
    } else {
        photoCell.contentLabel.text = note.content;
    }
//    photoCell.contentView.backgroundColor = [Utils hexStringToColor:note.bgColor];
    cell = photoCell;
    
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
        [self deleteNoteWith:(int)indexPath.row andPhoto:YES];
        
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

- (IBAction)tackPhoto:(id)sender {
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
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
                case 2:
                    // 取消
                    return;
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (IBAction)segmentedChange:(id)sender {
    UISegmentedControl *usc = sender;
    if (usc.selectedSegmentIndex == 0) {
        [self.delegate pushToNoteListView];
        [self.segmentedBar setSelectedSegmentIndex:1];
    }
}

#pragma mark - ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //获取裁剪后的小图
    CGSize smallImgSize = image.size;
    smallImgSize.width = smallImageWidth;
    smallImgSize.height = smallImageWidth / image.size.width * smallImgSize.height;
    
    UIImage *smallImage = [self imageWithImage:image scaledToSize:smallImgSize];
    
    int newImgId = [[NSDate date] timeIntervalSince1970];
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:[NSString stringWithFormat:@"%d.png",newImgId]];
    [self saveImage:smallImage withName:[NSString stringWithFormat:@"%d_small.png",newImgId]];
    
    //取得图片路径
    NSString *normalPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",newImgId]];
    NSString *smallPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_small.png",newImgId]];
    
    //创建图片类note对象
    Note *newNote = [[Note alloc] init];
    newNote.orderId = newImgId;
    newNote.type = @"image";
    newNote.smallImgPath = smallPath;
    newNote.imgPath = normalPath;
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
        
        PhotoEditViewController *editViewController = segue.destinationViewController;
        editViewController.delegate = self;
        editViewController.note = _currNote;
    }
}

#pragma mark - override edit delegate function

- (void)editViewControllerDidCancel:(UIViewController *)controller
{
    [self doBackToList];
}

- (void)editViewController:(UIViewController *)controller didAddNote:(Note *)addNote
{
    //如果没有id 新建
    if (addNote.orderId == 0) {
        addNote.orderId = [[NSDate date] timeIntervalSince1970];
        [self insertNoteToTop:addNote];
    } else { //有id，就删除再添加到第一行
        Note *currNote = [self getNoteWith:addNote.orderId];
        if (currNote != nil) {
            int i = (int)[_notes indexOfObject:currNote];
            [self deleteNoteWith:i andPhoto:NO];
            [self insertNoteToTop:addNote];
        }
    }
    [self doBackToList];
}

- (void)editViewControllerDeleteNoteWith:(int)orderId
{
    Note *currNote = [self getNoteWith:orderId];
    if (currNote) {
        [self deleteNoteWith:(int)[_notes indexOfObject:currNote] andPhoto:YES];
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
}

//第一行插入新note
- (void)insertNoteToTop:(Note *)newNote
{
    [[NoteDao sharedManager] create:newNote];
    [self.notes insertObject:newNote atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
- (void)deleteNoteWith:(int)index andPhoto:(BOOL)isDelete
{
    [[NoteDao sharedManager] remove:[_notes objectAtIndex:index] andPhoto:isDelete];
    [self.notes removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

//对图片尺寸进行压缩和裁剪--
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    //再裁剪
    //要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
    CGRect rect =  CGRectMake(0, 0, newSize.width, newSize.height);
    CGImageRef cgimg = CGImageCreateWithImageInRect([newImage CGImage], rect);
    newImage = [UIImage imageWithCGImage:cgimg];
    // Return the new image.
    return newImage;
}

@end
