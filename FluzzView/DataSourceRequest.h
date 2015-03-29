//
// DataSourceRequest.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceWorker.h"

@interface  DataSourceRequest : NSOperation
@property (nonatomic, readonly) id                 ID;     /// 标识
@property (nonatomic, readonly) id                 params; ///< 启动参数
@property (nonatomic, readonly) id                 result; ///< 结果
@property (nonatomic, readonly) NSError           *error;  ///< 错误原因
@property (nonatomic, strong) id<DataSourceWorker> worker;

+ (instancetype)requestWithID:(id)ID params:(id)params;

@end
