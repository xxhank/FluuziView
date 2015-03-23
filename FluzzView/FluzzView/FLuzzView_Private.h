//
// FLuuziView_Private.h
// FluzzView
//
// Created by wangchao on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuzzView.h"

@interface UIView (FLuuziPage)
@property (nonatomic, strong) NSLayoutConstraint *trailingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leadingContraint;
@end

typedef NS_ENUM (NSUInteger, FLuuziViewPanDirection)
{
    FLuuziViewPanDirectionUnknown, ///< unknown, or canceled
    FLuuziViewPanDirectionRight,   ///< pan to right
    FLuuziViewPanDirectionLeft,    ///< pan to left
};

@interface FLuzzView ()
@property (nonatomic, assign) FLuuziViewPanDirection    panDirection;
@property (nonatomic, strong) NSMutableDictionary      *pageViews;         ///< 当前保存的页面
@property (nonatomic, strong) NSMutableArray           *reusableViews;     ///< 可重用的页面
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, assign) CGPoint                   swipeGestureBegin; ///< 手势开始位置
@property (nonatomic, strong) UIPanGestureRecognizer   *panGesture;        ///< 拖动手势

- (NSIndexPath*)nextPageIndex:(NSIndexPath*)currentIndex;
- (NSIndexPath*)prevPageIndex:(NSIndexPath*)currentIndex;

- (FLuuziPage*)pageAtIndexPath:(NSIndexPath*)indexPath;

- (void)animationToNextPage;
- (void)animationToPrevPage;

- (void)resetCurrentPage;
- (void)resetPrevPage:(NSIndexPath*)prevIndex;
- (void)resetNextPage:(NSIndexPath*)nextIndex;
@end


#import "FLuuziView+CardMode.h"
#import "FLuuziView+SlipMode.h"
#import "FLuuziView+SwipeGesture.h"
#import "FLuuziView+PanGeture.h"
