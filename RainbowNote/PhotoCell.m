//
//  PhotoCell.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-15.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    //图片圆角和边框
    self.imgView.layer.cornerRadius = 2;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imgView.layer setBorderWidth:0.1];
    
    //文字加阴影效果
    self.contentLabel.layer.shadowOpacity = 0.5;
    self.contentLabel.layer.shadowOffset = CGSizeZero;
    self.contentLabel.layer.shadowRadius = 0.5;
    
    self.dateLabel.layer.shadowOpacity = 0.5;
    self.dateLabel.layer.shadowOffset = CGSizeZero;
    self.dateLabel.layer.shadowRadius = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
