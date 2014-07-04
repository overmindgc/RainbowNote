//
//  ListCell.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-2.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *leftBg;
@property (weak, nonatomic) IBOutlet UIView *contentBg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@end
