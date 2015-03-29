//
// UIPanGestureRecognizerEx.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "UIPanGestureRecognizerEx.h"

@interface UIPanGestureRecognizerEx ()
@property (nonatomic, assign) PanGestureDirection direction;
@property (nonatomic, assign) CGPoint             gestureBegin;
@property (nonatomic, assign) CGPoint             lastGestureLocation;

@property (nonatomic, assign) CGFloat distance;                                  ///< 手势划过的距离
@property (nonatomic, assign) CGFloat offset;                                    ///< 相对上次手势偏移量
/// 用于判断方向
@property (nonatomic, assign) NSUInteger               numberOfVerticalPoints;   ///< 垂直方向记录的点数
@property (nonatomic, assign) NSUInteger               numberOfHorizontalPoints; ///< 水平方向记录的点数
@property (nonatomic, assign) UIGestureRecognizerState stateEx;
@end

@implementation UIPanGestureRecognizerEx
{
    SEL _proxyAction; ///< 事件转发处理方法
    id  _proxyTarget; ///< 事件转发对象
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:self action:@selector(panGestureHandler_Private:)];

    if (self)
    {
        _proxyAction    = action;
        _proxyTarget    = target;
        _detectDistance = 20;
        _detectDelta    = 5;
    }
    return self;
} /* initWithTarget */

- (CGPoint)gestureLocation:(UIPanGestureRecognizer*)gesture
{
    return [gesture locationInView:self.view];
}

#pragma mark - detect help
- (void)detectDirectionForGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [self gestureLocation:gesture];

    if ( (ABS(location.x - _lastGestureLocation.x) < _detectDelta) )
    {
        _numberOfVerticalPoints++;
    }

    if (ABS(location.y - _lastGestureLocation.y ) < _detectDelta)
    {
        _numberOfHorizontalPoints++;
    }

    if ( (ABS(location.x - _gestureBegin.x) > _detectDistance)
         || (ABS(location.y - _gestureBegin.y) > _detectDistance) )
    {
        if (_numberOfVerticalPoints > _numberOfHorizontalPoints)
        {
            [self gesture:gesture detectedDirection:PanGestureDirectionVertical ];
        }
        else if(_numberOfVerticalPoints < _numberOfHorizontalPoints)
        {
            [self gesture:gesture detectedDirection:PanGestureDirectionHorizontal];
        }
        else
        {
            // YCLogDebug(@"unexcept direction:%@", @"PanGestureDirectionUndetected");
        }
    }
} /* detectDirectoryForGesture */

- (void)gesture:(UIPanGestureRecognizer*)gesture detectedDirection:(PanGestureDirection)direction
{
    _direction           = direction;
    _gestureBegin        = [self gestureLocation:gesture];
    _lastGestureLocation = _gestureBegin;
    _distance            = 0;
    _offset              = 0;
    _stateEx             = UIGestureRecognizerStateBegan;

    [self notifyGestureEvent];
} /* detectedDirectory */

- (void)notifyGestureEvent
{
    #pragma clang diagnostic pop
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_proxyTarget performSelector:_proxyAction withObject:self];
    #pragma clang diagnostic pop
}

#pragma mark - gesture handler
- (void)panGestureHandler_Private:(UIPanGestureRecognizer*)gesture
{
    // YCLogDebug(@"%@", gesture);
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            {
                _gestureBegin             = [self gestureLocation:gesture];
                _lastGestureLocation      = _gestureBegin;
                _numberOfVerticalPoints   = 0;
                _numberOfHorizontalPoints = 0;
                _direction                = PanGestureDirectionUndetected;
            }
            break;

        default:
            {
                // YCLogDebug(@"%ld", gesture.state);
                if ( (UIGestureRecognizerStateChanged == gesture.state)
                     && ( PanGestureDirectionUndetected == _direction) )
                {
                    [self detectDirectionForGesture:gesture];
                }
                else
                {
                    CGPoint location = [self gestureLocation:gesture];

                    if (_direction == PanGestureDirectionVertical)
                    {
                        _distance = location.y - _gestureBegin.y;
                        _offset   = location.y - _lastGestureLocation.y;
                    }
                    else
                    {
                        _distance = location.x - _gestureBegin.x;
                        _offset   = location.x - _lastGestureLocation.x;
                    }


                    _stateEx             = gesture.state;
                    [self notifyGestureEvent];
                    _lastGestureLocation = location;
                }
            }
            break;
    } /* switch */
}     /* panGestureHandler */

@end
