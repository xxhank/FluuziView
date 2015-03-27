//
// FLuuziView+CardMode.m
// FluzzView
//
// Created by wangchao on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuuziView+CardMode.h"
#import "FLuzzView_Private.h"

#if __has_include("UIView+LayoutChain.h")
    #import "UIView+LayoutChain.h"
#endif

@implementation FLuzzView (CardMode)
- (void)card_setupPageView:(FLuuziPage*)pageView offset:(NSInteger)offsetFromCenter
{
    if (!pageView)
    {
        return;
    }

    if (!pageView.trailingConstraint && !pageView.leadingContraint)
    {
        /// 建立约束
        pageView.translatesAutoresizingMaskIntoConstraints = NO;
        pageView.layout_top.equalTo(self.layout_top).install();
        pageView.layout_bottom.equalTo(self.layout_bottom).install();
        pageView.layout_width.equalTo(self.layout_width).install();
    }

    if (offsetFromCenter >= 0)
    {
        [self removeConstraint:pageView.leadingContraint];
        [self removeConstraint:pageView.trailingConstraint];
        pageView.layout_trailing.equalTo(self.layout_trailing).install();
        pageView.trailingConstraint = pageView.layout_trailing.lastConstraint;
    }
    else
    {
        [self removeConstraint:pageView.leadingContraint];
        [self removeConstraint:pageView.trailingConstraint];
        pageView.layout_trailing.equalTo(self.layout_leading).install();
        pageView.trailingConstraint = pageView.layout_trailing.lastConstraint;
    }
} /* setupPageViewForCardMode */

- (void)card_dragingWithOffset:(CGFloat)offsetX
{
    if (offsetX)
    {
        /// 方向:->
        self.panDirection = FLuuziViewPanDirectionRight;

        NSIndexPath *prevIndex = [self prevPageIndex:self.current];

        if (prevIndex)
        {
            FLuuziPage *pageView = [self pageAtIndexPath:prevIndex];
            pageView.trailingConstraint.constant
                = offsetX;
        }
        else
        {
            FLuuziPage *pageView = [self pageAtIndexPath:self.current];
            pageView.trailingConstraint.constant
                = offsetX;
        }
    }
    else
    {
        /// 方向:<-
        self.panDirection = FLuuziViewPanDirectionLeft;

        FLuuziPage *pageView = [self pageAtIndexPath:self.current];
        pageView.trailingConstraint.constant
                          = offsetX;
    }
} /* cardmode_dragingWithOffset */

- (void)card_finishedDragWithOffset:(CGFloat)offset velocity:(CGPoint)velocity
{
    CGFloat width = CGRectGetWidth(self.bounds);

    switch (self.panDirection)
    {
        case FLuuziViewPanDirectionUnknown:
            {
            }
            break;

        case FLuuziViewPanDirectionRight:
            {
                NSIndexPath *prevIndex = [self prevPageIndex:self.current];

                if (prevIndex)
                {
                    if ( offset > (width / 2.0) )
                    {
                        [self animationToPrevPage];
                    }
                    else
                    {
                        [self resetPrevPage:prevIndex];
                    }
                }
                else
                {
                    [self resetCurrentPage];
                }
            }
            break;

        case FLuuziViewPanDirectionLeft:
            {
                NSIndexPath *nextIndex = [ self nextPageIndex:self.current];

                if (nextIndex)
                {
                    if ( offset > (width / 2.0) )
                    {
                        [self animationToNextPage];
                    }
                    else
                    {
                        [self resetCurrentPage];
                    }
                }
                else
                {
                    [self resetCurrentPage];
                }
            }
            break;

        default:
            {
            }
            break;
    } /* switch */
}          /* cardMode_finishedDragWithOffset */

@end
