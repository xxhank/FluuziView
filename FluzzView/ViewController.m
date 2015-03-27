//
// ViewController.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "ViewController.h"
#import "FLuzzView.h"
#import "FluuzViewDefine.h"
#import "FLuzzView_Private.h"

#import "PageView.h"

@interface Mark : NSObject<HZIPPageViewSelection>
@property (nonatomic, assign) CGPoint  begin; ///< 开始位置
@property (nonatomic, assign) CGPoint  end;   ///< 结束位置
@property (nonatomic, strong) NSArray *rects;
@end

@implementation Mark
+ (instancetype)markWithSelection:(id<HZIPPageViewSelection>)selection
{
    Mark *mark = [Mark new];

    mark.begin = selection.begin;
    mark.end   = selection.end;
    return mark;
}

@end

@interface ViewController ()< FLuuziViewDataSource
                              , FLuuziViewDelegate
                              , PageViewDelegate
                              , PageViewDataSource
                              , UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet FLuzzView *fluuzView;
@property (weak, nonatomic) IBOutlet UISlider  *numberOfSectionSlider;
@property (weak, nonatomic) IBOutlet UISlider  *numberOfPagesSlider;

@property (nonatomic, strong) UIPanGestureRecognizer   *fontChangeGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *fontChangeGesture2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceLeadingToParrent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceTrailingToParrent;

@property (nonatomic, assign) CGFloat fontSize;
@end

@implementation ViewController
{
    NSMutableDictionary *_datas;
    NSMutableDictionary *_marks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self buildData];
    [self buildUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildData
{
    _datas = [NSMutableDictionary dictionary];
    _marks = [NSMutableDictionary dictionary];
}

#define RandomValue(min, max) (arc4random_uniform(max - min) + min)
- (void)buildUI
{
    self.numberOfSectionSlider.value = RandomValue(self.numberOfSectionSlider.minimumValue, self.numberOfSectionSlider.maximumValue);
    self.numberOfPagesSlider.value   = 4;// RandomValue(self.numberOfPagesSlider.minimumValue, self.numberOfPagesSlider.maximumValue);

    int numberOfSections = self.numberOfSectionSlider.value;

    for (int i = 0; i < numberOfSections; i++)
    {
        NSMutableArray *datasInSection = [NSMutableArray array];

        int numberOfPages              = self.numberOfPagesSlider.value;

        for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++)
        {
            id data = @{@"color":COLOR_RANDOM()};
            [datasInSection addObject:data];
        }

        [_datas setValue:datasInSection forKey:[NSString stringWithFormat:@"%@", @(i)]];
    }

    self.fontSize                                = 14;
    // self.fluuzView.mode       = FLuuziViewModeCard;
    self.fluuzView.dataSource                    = self;
    self.fluuzView.delegate                      = self;

    [self.fluuzView reloadData];

    self.fluuzView.panGesture.delaysTouchesBegan = YES;

    _fontChangeGesture                           = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    _fontChangeGesture.minimumNumberOfTouches    = 2;
    _fontChangeGesture.maximumNumberOfTouches    = 2;
    _fontChangeGesture.delegate                  = self;

    [self.view addGestureRecognizer:_fontChangeGesture];

    _fontChangeGesture2                          = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(fontChangeHandler:)];
    _fontChangeGesture2.delegate                 = self;
    [self.fluuzView addGestureRecognizer:_fontChangeGesture2];
} /* buildUI */

#pragma mark - action
- (IBAction)changeSectionCount:(id)sender
{
}

- (IBAction)changePageCountInSection:(id)sender
{
}

- (IBAction)prevPage:(id)sender
{
    [self.fluuzView setCurrent:[self.fluuzView prevPageIndex:self.fluuzView.current] animate:YES];
}

- (IBAction)nexPage:(id)sender
{
    [self.fluuzView setCurrent:[self.fluuzView nextPageIndex:self.fluuzView.current] animate:YES];
}

#pragma mark - FLuuziViewDataSource
- (NSUInteger)numberOfSectionInView:(FLuzzView*)view
{
    return self.numberOfSectionSlider.value;
}

- (NSUInteger)fluuzView:(FLuzzView*)view numberOfPagesInSection:(NSUInteger)section
{
    NSString *sectionKey     = [NSString stringWithFormat:@"%@", @(section)];
    NSArray  *datasInSection = [_datas valueForKey:sectionKey];

    return datasInSection.count;
}

- (UIView*)fluuzView:(FLuzzView*)view pageViewAtIndexPath:(NSIndexPath*)indexPath reuseView:(FLuuziPage*)reuseView
{
    PageView *pageView = (PageView*) reuseView;

    if (!pageView)
    {
        pageView            = [PageView pageView];
        pageView.delegate   = self;
        pageView.dataSource = self;
    }

    NSString *sectionKey     = [NSString stringWithFormat:@"%@", @(indexPath.section)];
    NSArray  *datasInSection = [_datas valueForKey:sectionKey];
    id        data           = [datasInSection objectAtIndex:indexPath.row];

    // pageView.contentLabel.text = [NSString stringWithFormat:@"page#%ld,%ld", (long) indexPath.section, (long) indexPath.row];
    pageView.indexLabel.text   = [NSString stringWithFormat:@"%ld %ld/%ld", (long) indexPath.section, (long) indexPath.row + 1, datasInSection.count];
    pageView.contentLabel.font = [UIFont systemFontOfSize:self.fontSize];
    pageView.backgroundColor   = data[@"color"];
    return pageView;
} /* fluuzView */

#pragma mark - FLuuziViewDelegate
- (void)fluuzView:(FLuzzView*)view pageWillAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    YCLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

- (void)fluuzView:(FLuzzView*)view pageDidAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    YCLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

- (void)fluuzView:(FLuzzView*)view pageWillDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    YCLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

- (void)fluuzView:(FLuzzView*)view pageDidDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    YCLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

#pragma mark -  PageViewDelegate
- (void)pageView:(PageView*)pageView markFinished:(id < HZIPPageViewSelection > )mark
{
    if (![mark isKindOfClass:[Mark class]])
    {
        Mark        *newMark   = [Mark markWithSelection:mark];
        NSIndexPath *indexPath = [self.fluuzView indexPathOfPageView:(pageView)];
        NSString    *key       = [NSString stringWithFormat:@"%@-%@", @(indexPath.section), @(indexPath.row)];

        NSMutableArray *marks  = [_marks objectForKey:key];

        if (!marks)
        {
            marks = [NSMutableArray array];
        }
        [marks addObject:newMark];
    }
} /* pageView */

#pragma mark - PageViewDataSource
- (BOOL)pageView:(PageView*)pageView tapped:(BOOL)tapInSection
{
    return YES;
}

- (NSArray*)marksForPageView:(PageView*)pageView
{
    NSIndexPath *indexPath = [self.fluuzView indexPathOfPageView:(pageView)];
    NSString    *key       = [NSString stringWithFormat:@"%@-%@", @(indexPath.section), @(indexPath.row)];

    return [_marks objectForKey:key];
}

- (NSArray*)pageView:(PageView*)pageView rectsFromBegin:(CGPoint)begin end:(CGPoint)end
{
    // CGPoint begin            = frame.origin;
    // CGPoint end              = {frame.origin.x, frame.origin.y + frame.size.height};

    const CGFloat lineHeight = 20;

    CGRect frame             = {begin.x, begin.y, 0, end.y - begin.y};

    if (CGRectGetHeight(frame) < lineHeight)
    {
        return nil;
    }

    NSMutableArray *rects = [NSMutableArray array];

    CGRect contentBounds  = self.fluuzView.bounds;
    CGRect rect           = frame;

    rect.size.height = lineHeight;
    rect.size.width  = CGRectGetMaxX(contentBounds) - rect.origin.x;

    [rects addObject:[NSValue valueWithCGRect:rect]];
    begin.y         += lineHeight;

    rect             = contentBounds;
    rect.size.height = lineHeight;

    for (CGFloat offsetY = begin.y; offsetY < end.y - lineHeight; offsetY += lineHeight)
    {
        rect.origin.y = offsetY;
        [rects addObject:[NSValue valueWithCGRect:rect]];
    }

    rect.size.width = end.x;
    [rects addObject:[NSValue valueWithCGRect:rect]];

    return rects;
} /* pageView */

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
- (void)panGestureHandler:(UIPanGestureRecognizer*)gesture
{
    // YCLogDebug(@"%@", gesture);
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            {
                _panGestureBegin          = [gesture locationInView:self.view];
                _lastPanGestureLocation   = _panGestureBegin;
                _numberOfVerticalPoints   = 0;
                _numberOfHorizontalPoints = 0;
                _panGestureDirection      = PanGestureDirectionUndetected;
            }
            break;

        case UIGestureRecognizerStateChanged:
            {
                CGPoint location = [gesture locationInView:self.view];

                switch (_panGestureDirection)
                {
                    case PanGestureDirectionUndetected:
                        {
                            if ( (ABS(location.x - _lastPanGestureLocation.x) < 5) )
                            {
                                _numberOfVerticalPoints++;
                            }

                            if (ABS(location.y - _lastPanGestureLocation.y ) < 5)
                            {
                                _numberOfHorizontalPoints++;
                            }

                            if ( (ABS(location.x - _panGestureBegin.x) > 20)
                                 || ABS(location.y - _panGestureBegin.y > 20) )
                            {
                                if (_numberOfVerticalPoints > _numberOfHorizontalPoints)
                                {
                                    _panGestureDirection    = PanGestureDirectionVertical;
                                    _panGestureBegin        = [gesture locationInView:self.view];
                                    _lastPanGestureLocation = _panGestureBegin;
                                }
                                else if(_numberOfVerticalPoints < _numberOfHorizontalPoints)
                                {
                                    _panGestureDirection    = PanGestureDirectionHorizontal;
                                    _panGestureBegin        = [gesture locationInView:self.view];
                                    _lastPanGestureLocation = _panGestureBegin;
                                }
                                else
                                {
                                    // _panGestureDirection = PanGestureDirectionHorizontal;
                                }
                            }
                        }
                        break;

                    case PanGestureDirectionVertical:
                        {
                            /// 垂直方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureChangedInVertical:(location.y - _panGestureBegin.y)];
                        }
                        break;

                    case PanGestureDirectionHorizontal:
                        {
                            /// 水平方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureChangedInHorizontal:(location.x - _panGestureBegin.x)];
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
            {
                CGPoint location = [gesture locationInView:self.view];

                switch (_panGestureDirection)
                {
                    case PanGestureDirectionVertical:
                        {
                            /// 垂直方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureEndedInVertical:(location.y - _panGestureBegin.y)];
                        }
                        break;

                    case PanGestureDirectionHorizontal:
                        {
                            /// 水平方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureEndedInHorizontal:location.x - _panGestureBegin.x];
                        }
                        break;

                    default:
                        {
                        }
                        break;
                } /* switch */
            }
            break;

        case UIGestureRecognizerStateCancelled:
            {
                CGPoint location = [gesture locationInView:self.view];
                switch (_panGestureDirection)
                {
                    case PanGestureDirectionVertical:
                        {
                            /// 垂直方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureCancelledInVertical:(location.y - _panGestureBegin.y)];
                        }
                        break;

                    case PanGestureDirectionHorizontal:
                        {
                            /// 水平方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureCancelledInHorizontal:location.x - _panGestureBegin.x  ];
                        }
                        break;

                    default:
                        {
                        }
                        break;
                } /* switch */
            }
            break;

        case UIGestureRecognizerStateFailed:
            {
                CGPoint location = [gesture locationInView:self.view];

                switch (_panGestureDirection)
                {
                    case PanGestureDirectionVertical:
                        {
                            /// 垂直方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureFailedInVertical:(location.y - _panGestureBegin.y)];
                        }
                        break;

                    case PanGestureDirectionHorizontal:
                        {
                            /// 水平方向
                            _lastPanGestureLocation = location;
                            [self handlePanGestureFailedInHorizontal:location.x - _panGestureBegin.x  ];
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
