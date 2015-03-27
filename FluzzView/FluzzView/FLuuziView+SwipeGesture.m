//
// FLuuziView+SwipeGesture.m
// FluzzView
//
// Created by wangchao on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuuziView+SwipeGesture.h"
#import "FluuzViewDefine.h"

@implementation FLuzzView (SwipeGesture)
#pragma mark - swipe gesture
- (void)swipe:(UISwipeGestureRecognizer*)gesture
{
    switch (gesture.direction)
    {
        case UISwipeGestureRecognizerDirectionRight:
            {
                YCLogInfo(@"swip to right");
            }
            break;

        case UISwipeGestureRecognizerDirectionLeft:
            {
                YCLogInfo(@"swip to left");
            }
            break;

        case UISwipeGestureRecognizerDirectionUp:
            {
                YCLogInfo(@"swip to up");
            }
            break;

        case UISwipeGestureRecognizerDirectionDown:
            {
                YCLogInfo(@"swip to down");
            }
            break;

        default:
            {
            }
            break;
    } /* switch */
}     /* swipe */

@end
