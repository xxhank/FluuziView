//
// FLuuziView+SlipMode.h
// FluzzView
//
// Created by wangchao on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuzzView.h"

@interface FLuzzView (SlipMode)
- (void)slip_setupPageView:(FLuuziPage*)pageView offset:(NSInteger)offsetFromCenter;
- (void)slip_dragingWithOffset:(CGFloat)offsetX;
- (void)slip_finishedDragWithOffset:(CGFloat)offset velocity:(CGPoint)velocity;
@end
