//
// DataSource.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "DataSource.h"
#import "DataSourceRequest.h"

@interface DataSource ()
@property (nonatomic, strong) NSOperationQueue    *requestQueue;
@property (nonatomic, strong) NSMutableDictionary *requests;
@end

@implementation DataSource
+ (instancetype)sharedDataSource
{
    static dispatch_once_t onceToken;
    static DataSource     *shared;

    dispatch_once(&onceToken, ^{
        shared = [DataSource new];
    });

    return shared;
}

+ (void)requestDataWithID:(NSString*)ID
                   params:(id)params
                   worker:(id<DataSourceWorker>)worker
                 complete:(DataSourceComplete)complete
{
    [[DataSource sharedDataSource]
     requestDataWithID:ID
                params:params
                worker:worker
              complete:complete];
}

+ (void)cancelRequestWithID:(NSString*)ID
{
    [[DataSource sharedDataSource] cancelRequestWithID:ID];
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        _requestQueue                             = [[NSOperationQueue alloc] init];
        _requestQueue.name                        = @"request-data";
        _requestQueue.qualityOfService            = NSQualityOfServiceUserInitiated;
        _requestQueue.maxConcurrentOperationCount = 3;

        _requests                                 = [NSMutableDictionary dictionary];
    }
    return self;
} /* init */

- (void)requestDataWithID:(NSString*)ID
                   params:(id)params
                   worker:(id<DataSourceWorker>)worker
                 complete:(DataSourceComplete)complete
{
    DataSourceRequest *request = [_requests valueForKey:ID];

    if (!request)
    {
        request        = [DataSourceRequest requestWithID:ID params:params];
        request.worker = worker;
        [_requests setValue:request forKey:ID];
    }
    else
    {
        if (!request.isExecuting)
        {
            [request cancel];
        }
    }

    WEAK_OBJ(request);
    WEAK_OBJ(self);
    [request setCompletionBlock: ^{
        STRONG_OBJ(self);
        [self->_requests removeObjectForKey:ID];

        STRONG_OBJ(request);

        if (complete)
        {
            complete(request.result, request.error);
        }
    }];

    if ( ![request isExecuting]
         && ([_requestQueue.operations indexOfObject:request] == NSNotFound) )
    {
        [_requestQueue addOperation:request];
    }
} /* requestDataWithID */

- (void)cancelRequestWithID:(NSString*)ID
{
    DataSourceRequest *request = [_requests valueForKey:ID];

    if (request)
    {
        [request cancel];
        [_requests removeObjectForKey:ID];
    }
}

@end
