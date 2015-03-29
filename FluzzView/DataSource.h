//
// DataSource.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceWorker.h"

typedef void (^DataSourceComplete)(id result, NSError *aError);
@interface DataSource : NSObject
+ (void)requestDataWithID:(NSString*)ID
                   params:(id)params
                   worker:(id<DataSourceWorker>)worker
                 complete:(DataSourceComplete)complete;
+ (void)cancelRequestWithID:(NSString*)ID;
@end
