//
// ContentLoader.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "ContentLoader.h"
#import <UIKit/UIKit.h>
#import "AsynchronousData.h"

@implementation SectionLoader
- (void)timerFired
{
    SectionData    *sectionData    = [self.dataSource params];
    NSMutableArray *datasInSection = sectionData.pageDatas;

    int numberOfPages              = RANDOM(1, 15);

    for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++)
    {
        PageData *pageData = [PageData new];
        pageData.ID      = @(pageIndex);
        pageData.content = @{@"color":COLOR_RANDOM()};
        [datasInSection addObject:pageData];
    }

    [self.observer notifyWorkComplete:sectionData error:nil];
} /* timerFired */

@end

@implementation PageLoader
- (void)run
{
    int max = RANDOM(10000, 2000000);
    int i   = 0;

    while (i++ < max)
    {
    }

    [self.observer notifyWorkComplete:nil error:nil];
} /* run */

- (void)cancel
{
}

@end
