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
    
    self.notes = [[NoteDao sharedManager] findAll];
//    self.notes = [[NSMutableArray alloc] initWithCapacity:4];
    
//    Note *note1 = [[Note alloc] init];
//    note1.orderId = 1;
//    note1.content = @"北京易才博普奥管理顾问有限公司";
//    note1.date = @"07-02";
//    note1.fullDate = @"2014年7月2日 05:39";
//    NSDictionary *couple1 = [Utils getOneCoupleColor];
//    note1.leftColor = [Utils hexStringToColor:[couple1 objectForKey:@"left"]];
//    note1.bgColor = [Utils hexStringToColor:[couple1 objectForKey:@"bg"]];
//    [self.notes addObject:note1];
//    
//    Note *note2 = [[Note alloc] init];
//    note2.orderId = 2;
//    note2.content = @"Hello Swift!";
//    note2.date = @"07-02";
//    note2.fullDate = @"2014年7月2日 05:45";
//    NSDictionary *couple2 = [Utils getOneCoupleColor];
//    note2.leftColor = [Utils hexStringToColor:[couple2 objectForKey:@"left"]];
//    note2.bgColor = [Utils hexStringToColor:[couple2 objectForKey:@"bg"]];
//    [self.notes addObject:note2];
//    
//    Note *note3 = [[Note alloc] init];
//    note3.orderId = 3;
//    note3.content = @"This is my first short note content";
//    note3.date = @"06-30";
//    note3.fullDate = @"2014年6月30日 08:15";
//    NSDictionary *couple3 = [Utils getOneCoupleColor];
//    note3.leftColor = [Utils hexStringToColor:[couple3 objectForKey:@"left"]];
//    note3.bgColor = [Utils hexStringToColor:[couple3 objectForKey:@"bg"]];
//    [self.notes addObject:note3];
//    
//    Note *note4 = [[Note alloc] init];
//    note4.orderId = 4;
//    note4.content = @"我来测试一下多长的合适，好了，够长了吗，不够再来点";
//    note4.date = @"12-24";
//    note4.fullDate = @"2013年12月24日 09:08";
//    NSDictionary *couple4 = [Utils getOneCoupleColor];
//    note4.leftColor = [Utils hexStringToColor:[couple4 objectForKey:@"left"]];
//    note4.bgColor = [Utils hexStringToColor:[couple4 objectForKey:@"bg"]];
//    [self.notes addObject:note4];
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
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"listcell"];
    
    Note *note = (self.notes)[indexPath.row];
    cell.contentLabel.text = note.content;
    cell.dateLabel.text = note.date;
    cell.leftBg.backgroundColor = [Utils hexStringToColor:note.leftColor];
    cell.contentBg.backgroundColor = [Utils hexStringToColor:note.bgColor];
//    cell.contentLabel.textColor = note.leftColor;
    cell.dateLabel.textColor = [Utils hexStringToColor:note.leftColor];
    cell.rightImg.backgroundColor = [Utils hexStringToColor:note.leftColor];
    
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
    //副值给当前所选note
    [self openNoteWith:[self.notes objectAtIndex:indexPath.row]];
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

- (IBAction)addNewNote:(id)sender {
    //新建就把当前note为nil
    [self openNoteWith:nil];
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

@end