//
// FLuuziView.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLuuziPage.h"

@class FLuzzView;
@protocol FLuuziViewDataSource <NSObject>

- (NSUInteger)numberOfSectionInView:(FLuzzView*)view;
- (NSUInteger)fluuzView:(FLuzzView*)view numberOfPagesInSection:(NSUInteger)section;
- (FLuuziPage*)fluuzView:(FLuzzView*)fluuziView pageViewAtIndexPath:(NSIndexPath*)indexPath reuseView:(FLuuziPage*)reuseView;
@end

@protocol FLuuziViewDelegate <NSObject>

- (void)fluuzView:(FLuzzView*)view pageWillAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath;
- (void)fluuzView:(FLuzzView*)view pageDidAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath;

- (void)fluuzView:(FLuzzView*)view pageWillDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath;
- (void)fluuzView:(FLuzzView*)view pageDidDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath;
@end

typedef NS_ENUM (NSUInteger, FLuuziViewMode)
{
    FLuuziViewModeSlip, ///< 连续平行滑动
    FLuuziViewModeCard  ///< 覆盖模式
};

@interface FLuzzView : UIView
@property (nonatomic, weak) id<FLuuziViewDataSource> dataSource;
@property (nonatomic, weak) id<FLuuziViewDelegate>   delegate;
@property (nonatomic, strong) NSIndexPath           *current;
@property (nonatomic, assign) FLuuziViewMode         mode;

- (void)reloadData;
- (void)setCurrent:(NSIndexPath*)current animate:(BOOL)animate;
@end

#define FLuuziViewAnimationDuration .3
