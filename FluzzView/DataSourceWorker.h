//
// DataSourceWorker.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataSourceWokerObserver <NSObject>
- (void)notifyWorkComplete:(id)result error:(NSError*)error;
@end

@protocol DataSourceWokerDataSource <NSObject>
@property (nonatomic, readonly) id ID;           /// 标识
@property (nonatomic, readonly) id params;       ///< 启动参数
@end


@protocol DataSourceWorker <NSObject>
@property (nonatomic, weak) id<DataSourceWokerObserver>   observer;   ///< 工作完成之后的通知对象
@property (nonatomic, weak) id<DataSourceWokerDataSource> dataSource; ///< 完成工作所需要的数据源

- (BOOL)isAsynchronous;                                               ///< 是否是异步任务

- (void)run;                                                          ///< 在这里执行任务
- (void)cancel;                                                       ///< 终止任务
@end

/**
 *  @author 王超(技术02), 15-03-29 18:03
 *
 *  @brief  同步工作者
 */

@interface DataSourceSyncWorkder : NSObject<DataSourceWorker>
@property (nonatomic, weak) id<DataSourceWokerObserver>   observer;   ///< 工作完成之后的通知对象
@property (nonatomic, weak) id<DataSourceWokerDataSource> dataSource; ///< 完成工作所需要的数据源
@end

/**
 *  @author 王超(技术02), 15-03-29 18:03
 *
 *  @brief  异步工作者
 */
@interface DataSourceAsyncWorkder : NSObject<DataSourceWorker>
@property (nonatomic, weak) id<DataSourceWokerObserver>   observer;   ///< 工作完成之后的通知对象
@property (nonatomic, weak) id<DataSourceWokerDataSource> dataSource; ///< 完成工作所需要的数据源
@end

@interface TimerWorker : DataSourceAsyncWorkder
- (void)timerFired;
@end
