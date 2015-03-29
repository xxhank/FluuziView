//
// AsynchronousData.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "AsynchronousData.h"
#import <UIKit/UIKit.h>

@implementation AsynchronousData
- (BOOL)isNotReady
{
    return _state == AsynchronousDataNotReady;
}

- (BOOL)isLoading
{
    return _state == AsynchronousDataLoading;
}

- (BOOL)isSuccess
{
    return _state == AsynchronousDataLoadSuccess;
}

- (BOOL)isFailed
{
    return _state == AsynchronousDataLoadFailed;
}

- (void)setSuccess:(BOOL)success
{
    _state = success ? AsynchronousDataLoadSuccess : AsynchronousDataLoadFailed;
}

- (void)reset
{
    _state = AsynchronousDataNotReady;
}

@end

@implementation SectionData
- (PageData*)pageAtIndexPath:(NSIndexPath*)indexPath
{
    return [self pageAtIndex:indexPath.row];
}

- (PageData*)pageAtIndex:(NSUInteger)index
{
    if (index < self.pageDatas.count)
    {
        return [self.pageDatas objectAtIndex:index];
    }
    return nil;
}

@end

@implementation PageData
@end
