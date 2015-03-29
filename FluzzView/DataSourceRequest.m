//
// DataSourceRequest.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "DataSourceRequest.h"
@interface  DataSourceRequest ()<DataSourceWokerObserver, DataSourceWokerDataSource>
@property (nonatomic, strong) id       ID;     /// 标识
@property (nonatomic, strong) id       params; ///< 启动参数
@property (nonatomic, strong) id       result; ///< 结果
@property (nonatomic, strong) NSError *error;  ///< 错误原因

@property (atomic, assign) BOOL executing;
@property (atomic, assign) BOOL finished;

@end

@implementation DataSourceRequest
{
    BOOL _executing;
    BOOL _finished;
}

+ (instancetype)requestWithID:(id)ID params:(id)params
{
    DataSourceRequest *requset = [[DataSourceRequest alloc] init];

    requset.ID     = ID;
    requset.name   = ID;
    requset.params = params;

    return requset;
}

+ (dispatch_queue_t)lockQueue
{
    static dispatch_queue_t lockQueue;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        lockQueue = dispatch_queue_create("request-lock-queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return lockQueue;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)setExecuting:(BOOL)executing
{
    dispatch_sync([[self class] lockQueue], ^{
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    });
}

- (BOOL)isExecuting
{
    return _executing;
}

- (void)setFinished:(BOOL)finished
{
    dispatch_sync([[self class] lockQueue], ^{
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    });
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)start
{
    if ([self isCancelled])
    {
        self.finished = YES;
        return;
    }

    self.executing         = YES;

    self.worker.observer   = self;
    self.worker.dataSource = self;
    BOOL asynchronous = [self.worker isAsynchronous];

    if (asynchronous)
    {
        [self.worker run];
    }

    while (![self isCancelled] && ![self isFinished])
    {
        if (asynchronous)
        {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        }
        else
        {
            [self.worker run];
        }
    }

    if ([self isCancelled])
    {
        id userInfo = @{ NSLocalizedDescriptionKey:@"canceled"
                         , NSLocalizedFailureReasonErrorKey:@"canceled"
                         , NSLocalizedRecoverySuggestionErrorKey:@""
                         , NSLocalizedRecoveryOptionsErrorKey:@[]
                         , };
        self.error = [NSError errorWithDomain:@"data-source" code:-1 userInfo:userInfo];

        [self.worker cancel];
        [self completeOperation];
    }
} /* start */

- (void)main
{
    YCLogDebug(@"%@", self);
}

- (void)completeOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];

    _executing = NO;
    _finished  = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - DataSourceWokerObserver
- (void)notifyWorkComplete:(id)result error:(NSError*)error
{
    _result = result;
    _error  = error;
    [self completeOperation];
}

@end
