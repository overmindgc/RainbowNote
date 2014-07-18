//
//  ImageScrollView.h
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-17.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePopView : UIView<UIScrollViewDelegate>

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImageView *imgView;
@property (nonatomic) CGFloat originImgWidth;
@property (nonatomic) CGFloat originImgHeight;
@property (nonatomic) BOOL isTwiceTaping;
@property (nonatomic) BOOL isDoubleTapingForZoom;
@property (nonatomic) CGFloat currentScale;
@property (nonatomic) CGFloat offsetY;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) CGFloat touchX;
@property (nonatomic) CGFloat touchY;

@end
