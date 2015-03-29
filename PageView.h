//
// PageView.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLuzzView.h"
#import "HZIPPageViewSelection.h"

@class PageView;

@protocol PageViewDelegate <NSObject>
- (void)pageView:(PageView*)pageView markFinished:(id < HZIPPageViewSelection > )mark;
@end

@protocol PageViewDataSource <NSObject>
- (BOOL)pageView:(PageView*)pageView tapped:(BOOL)tapInSection;
- (NSArray*)marksForPageView:(PageView*)pageView;
- (NSArray*)pageView:(PageView*)pageView rectsFromBegin:(CGPoint)begin end:(CGPoint)end;
@end

@interface PageView : FLuuziPage
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (nonatomic, weak) id<PageViewDelegate>   delegate;
@property (nonatomic, weak) id<PageViewDataSource> dataSource;

@property (weak, nonatomic) IBOutlet UILabel *sectionLoadingIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *pageLoadingIndicatorView;
+ (instancetype)pageView;

@end
