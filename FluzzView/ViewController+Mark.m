//
// ViewController+Mark.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "ViewController+Mark.h"
#import "ViewController_Private.h"

#import "PageView.h"


@implementation Mark
+ (instancetype)markWithSelection:(id<HZIPPageViewSelection>)selection
{
    Mark *mark = [Mark new];

    mark.begin = selection.begin;
    mark.end   = selection.end;
    return mark;
}

@end
@implementation ViewController (Mark)

#pragma mark -  PageViewDelegate
- (void)pageView:(PageView*)pageView markFinished:(id < HZIPPageViewSelection > )mark
{
    if (![mark isKindOfClass:[Mark class]])
    {
        Mark        *newMark   = [Mark markWithSelection:mark];
        NSIndexPath *indexPath = [self.fluuzView indexPathOfPageView:(pageView)];
        NSString    *key       = [NSString stringWithFormat:@"%@-%@", @(indexPath.section), @(indexPath.row)];

        NSMutableArray *marks  = [self.marks objectForKey:key];

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

    return [self.marks objectForKey:key];
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

@end
