//
// AsynchronousData.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  @author 王超(技术02), 15-03-29 16:03
 *
 *  @brief  数据加载状态
 */
typedef NS_ENUM (NSUInteger, AsynchronousDataState)
{
    AsynchronousDataNotReady,    ///< 数据未加载
    AsynchronousDataLoading,     ///< 数据加载中
    AsynchronousDataLoadSuccess, ///< 数据加载成功
    AsynchronousDataLoadFailed   ///< 数据加载失败
};
@interface AsynchronousData : NSObject
/**
 *  @author 王超(技术02), 15-03-29 16:03
 *
 *  @brief  数据标识
 */
@property (nonatomic, strong) id ID;

/**
 *  @author 王超(技术02), 15-03-29 16:03
 *
 *  @brief  状态
 *
 */
@property (nonatomic, assign) AsynchronousDataState state;

- (BOOL)isNotReady;               ///< 数据未加载
- (BOOL)isLoading;                ///< 数据加载中
- (BOOL)isSuccess;                ///< 数据加载成功
- (BOOL)isFailed;                 ///< 数据加载失败

- (void)reset;                    ///< 重置状态
- (void)setSuccess:(BOOL)success; ///< 设置是否下载成功
@end

@class PageData;
@interface SectionData : AsynchronousData
@property (nonatomic, strong) NSMutableArray *pageDatas;
- (PageData*)pageAtIndexPath:(NSIndexPath*)indexPath;
- (PageData*)pageAtIndex:(NSUInteger)index;

@end

@interface PageData : AsynchronousData
@property (nonatomic, strong) id content;
@end
