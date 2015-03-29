//
// DataSourceWorker.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "DataSourceWorker.h"


@implementation DataSourceSyncWorkder

- (BOOL)isAsynchronous
{
    return NO;
}

- (void)run
{
}

- (void)cancel
{
}

@end

@implementation DataSourceAsyncWorkder

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)run
{
}

- (void)cancel
{
}

@end




@implementation TimerWorker

- (void)run
{
    NSTimeInterval interval = RANDOM(5, 10);

    YCLogDebug(@"%@: timer will arrive after %.3f", self.dataSource.ID, interval);
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(timerHandler:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)timerHandler:(id)sender
{
    YCLogDebug(@"on time");
    [self timerFired];
    [self.observer notifyWorkComplete:nil error:nil];
}

- (void)cancel
{
}

- (void)timerFired
{
}

@end
