//
//  ImageScrollView.m
//  RainbowNote
//
//  Created by 辰 宫 on 14-7-17.
//  Copyright (c) 2014年 gc. All rights reserved.
//

#import "ImagePopView.h"

#define kMaxZoom 3.0
#define kMinZoom 0.5

@implementation ImagePopView
{
    float kScreenHeight;
    float kScreenWidth;
}

@synthesize imgView = _imgView;
@synthesize image = _image;
@synthesize originImgWidth = _originImgWidth;
@synthesize originImgHeight = _originImgHeight;
@synthesize isTwiceTaping = _isTwiceTaping;
@synthesize scrollView = _scrollView;
@synthesize currentScale = _currentScale;
@synthesize isDoubleTapingForZoom = _isDoubleTapingForZoom;
@synthesize  touchX = _touchX;
@synthesize  touchY = _touchY;
@synthesize offsetY = _offsetY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        kScreenHeight = [UIScreen mainScreen].bounds.size.height;
        kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _originImgWidth = _image.size.width;
    _originImgHeight = _image.size.height;
    [self draw];
}

- (void) draw{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = kMaxZoom;
    _scrollView.minimumZoomScale = kMinZoom;
    
    float imageHight = kScreenWidth / _originImgWidth * _originImgHeight;
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,imageHight)];
    _imgView.image = _image;
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, imageHight);
    [_scrollView addSubview:_imgView];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         _imgView.frame = CGRectMake(0, kScreenHeight/2 - imageHight /2, kScreenWidth, imageHight);
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }
     ];
    
    
    UITapGestureRecognizer *tapImgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandle)];
    tapImgView.numberOfTapsRequired = 1;
    tapImgView.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapImgView];
    
    UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
    tapImgViewTwice.numberOfTapsRequired = 2;
    tapImgViewTwice.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapImgViewTwice];
    [tapImgView requireGestureRecognizerToFail:tapImgViewTwice];
}

#pragma mark - UIscrollViewDelegate zoom

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    _currentScale = scale;
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgView;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    CGFloat xcenter = scrollView.center.x;
    CGFloat ycenter = scrollView.center.y;

    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : ycenter;
    //双击放大时，图片不能越界，否则会出现空白。因此需要对边界值进行限制。
//    if(_isDoubleTapingForZoom){
//        xcenter = kMaxZoom * (kScreenWidth - _touchX);
//        ycenter = kMaxZoom * (kScreenHeight - _touchY);
//        if(xcenter > (kMaxZoom - 0.5) * kScreenWidth){//放大后左边超界
//            xcenter = (kMaxZoom - 0.5) * kScreenWidth;
//        }else if(xcenter < 0.5 * kScreenWidth){//放大后右边超界
//            xcenter = 0.5 * kScreenWidth;
//        }
//        if(ycenter > (kMaxZoom - 0.5) * kScreenHeight){//放大后左边超界
//            ycenter = (kMaxZoom - 0.5) * kScreenHeight +_offsetY * kMaxZoom;
//        }else if(ycenter < 0.5 * kScreenHeight){//放大后右边超界
//            ycenter = 0.5 * kScreenHeight +_offsetY * kMaxZoom;
//        }
//    }
    [_imgView setCenter:CGPointMake(xcenter, ycenter)];
}

#pragma mark - tap

-(void)tapImgViewHandle{
    if(_isTwiceTaping){
        return;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         _imgView.frame = CGRectMake(0,0, 0, 0);
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }
     ];
    
}

-(void)tapImgViewHandleTwice:(UIGestureRecognizer *)sender{
    _touchX = [sender locationInView:sender.view].x;
    _touchY = [sender locationInView:sender.view].y;
    if(_isTwiceTaping){
        return;
    }
    _isTwiceTaping = YES;
    
    if(_currentScale > 1.0){
        _currentScale = 1.0;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        _isDoubleTapingForZoom = YES;
        _currentScale = kMaxZoom;
        [_scrollView setZoomScale:kMaxZoom animated:YES];
    }
    _isDoubleTapingForZoom = NO;
    //延时做标记判断，使用户点击3次时的单击效果不生效。
    [self performSelector:@selector(twiceTaping) withObject:nil afterDelay:0.65];
}
-(void)twiceTaping{
    _isTwiceTaping = NO;
}

@end
