//
// ViewController.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM (NSUInteger, PanGestureDirection)
{
    PanGestureDirectionUndetected   ///< 滑动距离过短，无法检测方向
    , PanGestureDirectionVertical   ///< 垂直方向
    , PanGestureDirectionHorizontal ///< 水平方向
};


@interface ViewController : UIViewController
@property (nonatomic, assign) CGPoint             panGestureBegin;
@property (nonatomic, assign) CGPoint             lastPanGestureLocation;
@property (nonatomic, assign) PanGestureDirection panGestureDirection;

@property (nonatomic, assign) NSUInteger numberOfVerticalPoints;   ///< 垂直方向记录的点数
@property (nonatomic, assign) NSUInteger numberOfHorizontalPoints; ///< 水平方向记录的点数
@end
