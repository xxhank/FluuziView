//
// ViewController+Gesture.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "ViewController+Gesture.h"
#import "ViewController_Private.h"

@implementation ViewController (Gesture)
- (void)buildUI_Gesture
{
    UIPanGestureRecognizerEx *panGesture = [[UIPanGestureRecognizerEx alloc] initWithTarget:self action:@selector(panGestureHandler:)];

    panGesture.minimumNumberOfTouches = 2;
    panGesture.maximumNumberOfTouches = 2;
    panGesture.delegate               = self;

    [self.view addGestureRecognizer:panGesture];
    self.panGesture                   = panGesture;

    UIPinchGestureRecognizer *fontChangeGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(fontChangeHandler:)];
    fontChangeGesture.delegate        = self;
    [self.fluuzView addGestureRecognizer:fontChangeGesture];

    self.fontChangeGesture            = fontChangeGesture;
} /* buildUI_Gesture */

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    // YCLogDebug(@"%@", gestureRecognizer);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    return NO;
}

#pragma mark -
- (void)panGestureHandler:(UIPanGestureRecognizerEx*)gesture
{
    YCLogDebug(@"%ld", gesture.stateEx);
    // YCLogDebug(@"%@", gesture);
    switch (gesture.stateEx)
    {
        case UIGestureRecognizerStateChanged:
            {
                switch (gesture.direction)
                {
                    case PanGestureDirectionVertical:
                        {
                            /// 垂直方向
                            [self handlePanGestureChangedInVertical:gesture.offset];
                        }
                        break;

                    case PanGestureDirectionHorizontal:
                        {
                            /// 水平方向
                            [self handlePanGestureChangedInHorizontal:gesture.distance];
                        }
                        break;

                    default:
                        {
                        }
                        break;
                } /* switch */
            }
            break;

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            {
                switch (gesture.direction)
                {
                    case PanGestureDirectionVertical:
                        {
                            /// 垂直方向
                            [self handlePanGestureEndedInVertical:gesture.offset];
                        }
                        break;

                    case PanGestureDirectionHorizontal:
                        {
                            /// 水平方向
                            [self handlePanGestureEndedInHorizontal:gesture.distance];
                        }
                        break;

                    default:
                        {
                        }
                        break;
                } /* switch */
            }
            break;

        default:
            {
            }
            break;
    } /* switch */
}     /* panGestureHandler */

- (void)handlePanGestureChangedInVertical:(CGFloat)offset
{
    YCLogDebug(@"offset:%f brightness:%f", offset, [UIScreen mainScreen].brightness);
    CGFloat brightnessOffset = (offset / 500.0);

    [UIScreen mainScreen].brightness += brightnessOffset;
}

- (void)handlePanGestureEndedInVertical:(CGFloat)offset
{
}

- (void)handlePanGestureCancelledInVertical:(CGFloat)offset
{
}

- (void)handlePanGestureFailedInVertical:(CGFloat)offset
{
}

- (void)handlePanGestureChangedInHorizontal:(CGFloat)offset
{
    if ( (self.fluuzView.current.section == 0)
         && (self.fluuzView.current.row == 0) )
    {
        self.spaceLeadingToParrent.constant  = offset;
        self.spaceTrailingToParrent.constant = -offset;
    }
}

- (void)handlePanGestureEndedInHorizontal:(CGFloat)offset
{
    CGFloat pageOffset = 0;

    if (offset > CGRectGetWidth(self.fluuzView.frame) / 2)
    {
        pageOffset = CGRectGetWidth(self.fluuzView.frame);
    }

    [UIView animateWithDuration:.3 animations: ^{
        self.spaceLeadingToParrent.constant = pageOffset;
        self.spaceTrailingToParrent.constant = -pageOffset;

        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
        self.spaceLeadingToParrent.constant = pageOffset;
        self.spaceTrailingToParrent.constant = -pageOffset;
    }];
} /* handlePanGestureEndedInHorizontal */

- (void)handlePanGestureCancelledInHorizontal:(CGFloat)offset
{
    CGFloat pageOffset = 0;

    if (offset > CGRectGetWidth(self.fluuzView.frame) / 2)
    {
        pageOffset = CGRectGetWidth(self.fluuzView.frame);
    }

    [UIView animateWithDuration:.3 animations: ^{
        self.spaceLeadingToParrent.constant = pageOffset;
        self.spaceTrailingToParrent.constant = -pageOffset;

        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
        self.spaceLeadingToParrent.constant = pageOffset;
        self.spaceTrailingToParrent.constant = -pageOffset;
    }];
} /* handlePanGestureCancelledInHorizontal */

- (void)handlePanGestureFailedInHorizontal:(CGFloat)offset
{
}

- (void)fontChangeHandler:(UIPinchGestureRecognizer*)gesture
{
    static CGFloat scale         = 0;
    CGFloat        newScale      = floor(gesture.scale * 2);

    static CGFloat minFontSize   = 14;
    static CGFloat maxFontSize   = 20;
    static CGFloat maxScaleLevel = 10;

    if ( (scale != newScale) && (newScale <= maxScaleLevel) )
    {
        scale         = newScale;
        NSInteger newFontSize = minFontSize + (scale / maxScaleLevel) * (maxFontSize - minFontSize);
        self.fontSize = newFontSize;

        [self.fluuzView reloadData];
        YCLogDebug(@"%f %d", scale, (int) newFontSize);
    }
    else
    {
        // YCLogDebug(@"%f", gesture.scale);
    }
} /* fontChangeHandler */

@end
