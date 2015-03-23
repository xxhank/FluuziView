//
// FLuuziView+CardMode.h
// FluzzView
//
// Created by wangchao on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuzzView.h"

@interface FLuzzView (CardMode)
- (void)card_finishedDragWithOffset:(CGFloat)offset;
- (void)card_dragingWithOffset:(CGFloat)offsetX;

- (void)card_setupPageView:(FLuuziPage*)pageView offset:(NSInteger)offsetFromCenter;
@end
