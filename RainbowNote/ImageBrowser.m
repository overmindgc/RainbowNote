
//
//  SJAvatarBrowser.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-17.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "ImageBrowser.h"
#import "ImagePopView.h"

static CGRect oldframe;

@implementation ImageBrowser

+ (void)showImage:(UIImageView *)avatarImageView{
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

+ (void)showReSizeableImage:(UIImageView *)avatarImageView{
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    ImagePopView *popView = [[ImagePopView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    popView.image = image;

    [window addSubview:popView];
}

@end
