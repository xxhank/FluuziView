//
// FLuuziView+PanGeture.m
// FluzzView
//
// Created by wangchao on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuuziView+PanGeture.h"
#import "FLuzzView_Private.h"
#import "FLuzzView.h"
#import "FluuzViewDefine.h"

@implementation FLuzzView (PanGeture)

- (void)pan:(UIPanGestureRecognizer*)gesture
{
    // YCLogInfo ( @"%@", @(gesture.state) );
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            {
                self.swipeGestureBegin = [gesture locationInView:self];
                self.panDirection      = FLuuziViewPanDirectionLeft;
            };
            break;

        case UIGestureRecognizerStateChanged:
            {
                CGPoint swipeGesturePoint = [gesture locationInView:self];
                CGFloat offsetY           = swipeGesturePoint.y - self.swipeGestureBegin.y;

                if ( 20 < ABS(offsetY) )
                {
                    return;
                }

                CGFloat offsetX = swipeGesturePoint.x - self.swipeGestureBegin.x;

                [self dragingWithOffset:offsetX];
            };
            break;

        case UIGestureRecognizerStateEnded:
            {
                CGPoint swipeGesturePoint = [gesture locationInView:self];

                if ( 20 < ABS(swipeGesturePoint.y - self.swipeGestureBegin.y) )
                {
                    // return;
                }

                CGFloat offset   = ABS(swipeGesturePoint.x - self.swipeGestureBegin.x);
                CGPoint velocity = [gesture velocityInView:self];
                [self dragFinisehdWithOffset:offset velocity:velocity ];
            };
            break;

        case UIGestureRecognizerStateCancelled:
            {
                CGPoint swipeGesturePoint = [gesture locationInView:self];

                if ( 20 < ABS(swipeGesturePoint.y - self.swipeGestureBegin.y) )
                {
                    // return;
                }
                CGPoint velocity = [gesture velocityInView:self];
                CGFloat offset   = ABS(swipeGesturePoint.x - self.swipeGestureBegin.x);
                [self dragFinisehdWithOffset:offset velocity:velocity];
            }
            break;

        default:
            {
            }
            break;
    } /* switch */
}     /* pan */

- (void)dragingWithOffset:(CGFloat)offsetX
{
    switch (self.mode)
    {
        case FLuuziViewModeSlip:
            {
                [self slip_dragingWithOffset:offsetX];
            }
            break;

        case FLuuziViewModeCard:
            {
                [self card_dragingWithOffset:offsetX];
            }
            break;

        default:
            {
            }
            break;
    } /* switch */
}     /* dragingWithOffset */

- (void)dragFinisehdWithOffset:(CGFloat)offset velocity:(CGPoint)velocity
{
    switch (self.mode)
    {
        case FLuuziViewModeSlip:
            {
                [self slip_finishedDragWithOffset:offset velocity:velocity];
            }
            break;

        case FLuuziViewModeCard:
            {
                [self card_finishedDragWithOffset:offset velocity:velocity];
            }
            break;

        default:
            {
            }
            break;
    } /* switch */
}     /* finishedDragWithOffset */

@end
