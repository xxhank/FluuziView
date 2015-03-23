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
                XXLogInfo(@"swip to right");
            }
            break;

        case UISwipeGestureRecognizerDirectionLeft:
            {
                XXLogInfo(@"swip to left");
            }
            break;

        case UISwipeGestureRecognizerDirectionUp:
            {
                XXLogInfo(@"swip to up");
            }
            break;

        case UISwipeGestureRecognizerDirectionDown:
            {
                XXLogInfo(@"swip to down");
            }
            break;

        default:
            {
            }
            break;
    } /* switch */
}     /* swipe */

@end
