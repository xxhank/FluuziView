//
// UIPanGestureRecognizerEx.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, PanGestureDirection)
{
    PanGestureDirectionUndetected   ///< 滑动距离过短，无法检测方向
    , PanGestureDirectionVertical   ///< 垂直方向
    , PanGestureDirectionHorizontal ///< 水平方向
};

@protocol UIPanGestureRecognizerEx <NSObject>
@end

@interface UIPanGestureRecognizerEx : UIPanGestureRecognizer

/**
 *  @author 王超(技术02), 15-03-29 12:03
 *
 *  @brief  检测距离， 大于0，默认为20pt
 *  @note  一般来说检测距离越长，越准确
 */
@property (nonatomic, assign) NSUInteger detectDistance;

/**
 *  @author 王超(技术02), 15-03-29 12:03
 *
 *  @brief 检测误差，大于0， 默认为5pt
 *  @note 主要用来检测直线的笔直程度
 */
@property (nonatomic, assign) NSUInteger                 detectDelta;
@property (nonatomic, readonly) UIGestureRecognizerState stateEx;        ///< 避免使用state判断状态

@property (nonatomic, readonly) CGPoint             gestureBegin;        ///< 手势开始位置
@property (nonatomic, readonly) CGPoint             lastGestureLocation; ///< 上次手势的位置
@property (nonatomic, readonly) PanGestureDirection direction;
@property (nonatomic, readonly) CGFloat             distance;            ///< 手势划过的距离
@property (nonatomic, readonly) CGFloat             offset;              ///< 相对上次手势偏移量
@end
