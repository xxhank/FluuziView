//
// FLuuziView.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuzzView.h"
#import <objc/runtime.h>

#if __has_include("UIView+LayoutChain.h")
    #import "UIView+LayoutChain.h"
#endif

#import "FLuzzView_Private.h"
#import "FluuzViewDefine.h"

@implementation UIView (FLuuziPage)
- (NSLayoutConstraint*)trailingConstraint
{
    return objc_getAssociatedObject( self, @selector(trailingConstraint) );
}

- (void)setTrailingConstraint:(NSLayoutConstraint*)trailingConstraint
{
    objc_setAssociatedObject(self, @selector(trailingConstraint), trailingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint*)leadingContraint
{
    return objc_getAssociatedObject( self, @selector(leadingContraint) );
}

- (void)setLeadingContraint:(NSLayoutConstraint*)leadingContraint
{
    objc_setAssociatedObject(self, @selector(leadingContraint), leadingContraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation FLuzzView
{
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    _current       = [NSIndexPath indexPathForRow:0 inSection:0];
    _pageViews     = [NSMutableDictionary dictionary];
    _reusableViews = [NSMutableArray array];
    _swipeGesture  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self addGestureRecognizer:_swipeGesture];

    _panGesture    = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:_panGesture];
}

#pragma mark - cache and reuse
+ (NSString*)keyForIndexPath:(NSIndexPath*)indexPath
{
    return [NSString stringWithFormat:@"%ld-%ld", (long) indexPath.section, (long) indexPath.row];
}

- (void)cacheView:(id)view atIndexPath:(NSIndexPath*)indexPath
{
    NSString *key = [[self class] keyForIndexPath:indexPath];

    [_pageViews setValue:view forKey:key];
}

- (id)cacheViewForIndexPath:(NSIndexPath*)indexPath
{
    NSString *key = [[self class] keyForIndexPath:indexPath];

    return [_pageViews objectForKey:key];
}

- (void)reuseViewAtIndexPath:(NSIndexPath*)indexPath
{
    NSString   *key      = [[self class] keyForIndexPath:indexPath];
    FLuuziPage *pageView = [_pageViews valueForKey:key];

    [_pageViews removeObjectForKey:key];

    [self reuseView:pageView];
} /* reuseViewAtIndexPath */

- (void)reuseView:(UIView*)pageView
{
    if (pageView)
    {
        if ([pageView respondsToSelector:@selector(prepareForReuse)])
        {
            [pageView performSelector:@selector(prepareForReuse)];
        }

        [_reusableViews addObject:pageView];
        pageView.leadingContraint   = nil;
        pageView.trailingConstraint = nil;
        [pageView removeFromSuperview];
    }
} /* reuseView */

- (FLuuziPage*)reuseView
{
    FLuuziPage *pageView = [_reusableViews lastObject];

    [_reusableViews removeLastObject];

    return pageView;
}

#pragma mark - helper
- (BOOL)isInvalid
{
    if (!_current)
    {
        return YES;
    }

    if (!_dataSource)
    {
        return YES;
    }

    if (_current.section > [self.dataSource numberOfSectionInView:self])
    {
        return YES;
    }

    if (_current.row > [self.dataSource fluuzView:self numberOfPagesInSection:_current.section])
    {
        return YES;
    }

    return NO;
} /* isInvalid */

- (NSUInteger)numberOfSections
{
    return [self.dataSource numberOfSectionInView:self];
}

- (NSUInteger)numberOfPagesInSection:(NSUInteger)section
{
    return [self.dataSource fluuzView:self numberOfPagesInSection:section];
}

#pragma mark - NSIndexPath
- (NSIndexPath*)nextPageInSection:(NSIndexPath*)indexPath
{
    if (indexPath.row + 1 > [self numberOfPagesInSection:indexPath.section])
    {
        return nil;
    }
    return INDEX_PATH(indexPath.row + 1, indexPath.section);
}

- (NSIndexPath*)prevPageInSection:(NSIndexPath*)indexPath
{
    if (indexPath.row < 1)
    {
        return nil;
    }

    if (indexPath.row + 1 > [self numberOfPagesInSection:indexPath.section])
    {
        return nil;
    }
    return INDEX_PATH(indexPath.row - 1, indexPath.section);
} /* prevPageInSection */

- (NSIndexPath*)firstPageInNextSection:(NSIndexPath*)indexPath
{
    if (indexPath.section + 1 > [self numberOfSections])
    {
        return nil;
    }

    if (0 == [self numberOfPagesInSection:indexPath.section + 1])
    {
        return nil;
    }
    return INDEX_PATH(0, indexPath.section + 1);
} /* firstPageIndexNextSection */

- (NSIndexPath*)lastPageInPrevSection:(NSIndexPath*)indexPath
{
    if (indexPath.section < 1)
    {
        return nil;
    }

    if (indexPath.section + 1 > [self numberOfSections])
    {
        return nil;
    }

    NSUInteger pageCount = [self numberOfPagesInSection:indexPath.section - 1];

    if (0 == pageCount)
    {
        return nil;
    }
    return INDEX_PATH(pageCount - 1, indexPath.section - 1);
} /* lastPageIndexPrevSection */

- (NSIndexPath*)nextPageIndex:(NSIndexPath*)currentIndex
{
    NSIndexPath *nextIndexPath = nil;

    if ( (currentIndex.row + 1) == [self numberOfPagesInSection:currentIndex.section] )
    {
        nextIndexPath = [self firstPageInNextSection:currentIndex];
    }
    else
    {
        nextIndexPath = [self nextPageInSection:currentIndex];
    }
    return nextIndexPath;
} /* nexPageIndex */

- (NSIndexPath*)prevPageIndex:(NSIndexPath*)currentIndex
{
    NSIndexPath *prevIndexPath = nil;

    if (currentIndex.row == 0)
    {
        prevIndexPath = [self lastPageInPrevSection:currentIndex];
    }
    else
    {
        prevIndexPath = [self prevPageInSection:currentIndex];
    }
    return prevIndexPath;
} /* prevPageIndex */

#pragma mark - pageAtIndexPath
- (FLuuziPage*)pageAtIndexPath:(NSIndexPath*)indexPath
{
    if (!indexPath)
    {
        return nil;
    }

    FLuuziPage *pageView = [self cacheViewForIndexPath:indexPath];

    if (!pageView)
    {
        FLuuziPage *reuseView = [self reuseView];
        pageView = [self.dataSource fluuzView:self pageViewAtIndexPath:indexPath reuseView:reuseView];
        [self cacheView:pageView atIndexPath:indexPath];

        [self addSubview:pageView];
    }

    return pageView;
} /* pageAtIndexPath */

#pragma mark - notifier
- (void)pageWillAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    if (!indexPath || !_delegate)
    {
        return;
    }

    [self.delegate fluuzView:self pageWillAppear:pageView atIndexPath:indexPath];
}

- (void)pageDidAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    if (!indexPath || !_delegate)
    {
        return;
    }
    [self.delegate fluuzView:self pageDidAppear:pageView atIndexPath:indexPath];
}

- (void)pageWillDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    if (!indexPath || !_delegate)
    {
        return;
    }
    [self.delegate fluuzView:self pageWillDisAppear:pageView atIndexPath:indexPath];
}

- (void)pageDidDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    if (!indexPath || !_delegate)
    {
        return;
    }
    [self.delegate fluuzView:self pageDidDisAppear:pageView atIndexPath:indexPath];
}

#pragma mark - reloadData
- (void)reloadData
{
    if ([self isInvalid])
    {
        return;
    }

    NSIndexPath *current = _current;
    _current = nil;
    [self setCurrent:current animate:NO];
} /* reloadData */

- (void)recycleViews
{
    NSIndexPath *nextIndexPath     = [self nextPageIndex:_current];
    NSIndexPath *prevIndexPath     = [self prevPageIndex:_current];

    NSString *currentKey           = [[self class] keyForIndexPath:_current];
    NSString *prevKey              = [[self class] keyForIndexPath:prevIndexPath];
    NSString *nextKey              = [[self class] keyForIndexPath:nextIndexPath];

    NSMutableDictionary *pageViews = [NSMutableDictionary dictionary];

    [pageViews setValue:_pageViews[currentKey] forKey:currentKey];
    [pageViews setValue:_pageViews[prevKey] forKey:prevKey];
    [pageViews setValue:_pageViews[nextKey] forKey:nextKey];

    [_pageViews removeObjectForKey:currentKey];
    [_pageViews removeObjectForKey:prevKey];
    [_pageViews removeObjectForKey:nextKey];

    [_pageViews enumerateKeysAndObjectsUsingBlock: ^(id key, UIView *obj, BOOL *stop) {
        [self reuseView:obj];
    }];
    _pageViews = pageViews;
} /* reuseViews */

- (void)setCurrent:(NSIndexPath*)current animate:(BOOL)animate
{
    if (!_current || !animate)
    {
        _current = current;
        /// 首次？
        NSIndexPath *currentIndex = _current;
        FLuuziPage  *currentView  = [self pageAtIndexPath:currentIndex];
        [self addSubview:currentView];
        [self setupPageView:currentView offset:0];

        [self  pageWillAppear:currentView atIndexPath:currentIndex];
        [self  pageDidAppear:currentView atIndexPath:currentIndex];


        NSIndexPath *nextIndexPath = [self nextPageIndex:currentIndex];
        FLuuziPage  *nextView      = [self pageAtIndexPath:nextIndexPath];
        [self insertSubview:nextView belowSubview:currentView];
        [self setupPageView:nextView offset:1];
        [self  pageWillAppear:nextView atIndexPath:nextIndexPath];


        NSIndexPath *prevIndexPath = [self prevPageIndex:currentIndex];
        FLuuziPage  *prevView      = [self pageAtIndexPath:prevIndexPath];
        [self insertSubview:prevView aboveSubview:currentView];
        [self setupPageView:prevView offset:-1];
        [self pageWillAppear:prevView atIndexPath:prevIndexPath];

        /// 清理view
        [self recycleViews];
        return;
    }

    /// 计算偏移量

    /// 加载右面的页面
    NSInteger count = 0;

    if (current.section > _current.section)
    {
        count  = current.section - _current.section;
        count += [self numberOfPagesInSection:_current.section] - _current.row - 1;
        count += current.row;
    }
    else if(current.section < _current.section)
    {
        count  = _current.section - current.section;
        count += [self numberOfPagesInSection:current.section] - current.row - 1;
        count += _current.row;

        count  = -count;
    }
    else
    {
        count = current.row - _current.row;
    }

    if (count == 0)
    {
        return;
    }

    if (ABS(count) == 1)
    {
        if (count == 1)
        {
            [self animationToNextPage];
        }
        else
        {
            [self animationToPrevPage];
        }
    }
    else
    {
        [self setCurrent:current animate:NO];
    }
} /* setCurrent */

#pragma mark - layout helper
- (void)animationToNextPage
{
    // move to next page
    NSIndexPath *oldCurrentPath = _current;

    [UIView animateWithDuration:FLuuziViewAnimationDuration animations: ^{
        FLuuziPage *currentPage = [self pageAtIndexPath:oldCurrentPath];
        [self setupPageView:currentPage offset:-1];
        [self pageWillDisAppear:currentPage atIndexPath:oldCurrentPath];

        NSIndexPath *nextIndex = [self nextPageIndex:oldCurrentPath];
        FLuuziPage *nextPage = [self pageAtIndexPath:nextIndex];
        [self setupPageView:nextPage offset:0];
        [self pageWillAppear:nextPage atIndexPath:nextIndex];

        [self layoutIfNeeded];
    } completion: ^(BOOL finished) {
        FLuuziPage *currentPage = [self pageAtIndexPath:oldCurrentPath];
        [self pageDidDisAppear:currentPage atIndexPath:oldCurrentPath];

        NSIndexPath *indexIndex = [self nextPageIndex:oldCurrentPath];
        FLuuziPage *nextPage = [self pageAtIndexPath:indexIndex];
        [self setupPageView:nextPage offset:0];
        [self pageDidAppear:nextPage atIndexPath:indexIndex];

        /// 回收不需要的页面
        [self recycleViews];
    }];

    _current = [self nextPageIndex:_current];

    // reload next page
    NSIndexPath *nextIndex = [self nextPageIndex:_current];
    FLuuziPage  *nextPage  = [self pageAtIndexPath:nextIndex];
    [self setupPageView:nextPage offset:1];
    [self pageWillAppear:nextPage atIndexPath:nextIndex];

    if (FLuuziViewModeCard == _mode)
    {
        /// 调整顺序
        [self sendSubviewToBack:nextPage];
    }
} /* animationToNextPage */

- (void)animationToPrevPage
{
    // move to prev page
    NSIndexPath *oldCurrentPath = _current;

    [UIView animateWithDuration:FLuuziViewAnimationDuration animations: ^{
        FLuuziPage *currentPage = [self pageAtIndexPath:oldCurrentPath];
        [self setupPageView:currentPage offset:1];
        [self pageWillDisAppear:currentPage atIndexPath:oldCurrentPath];

        NSIndexPath *prevIndex = [self prevPageIndex:oldCurrentPath];
        FLuuziPage *nextPage = [self pageAtIndexPath:prevIndex];
        [self setupPageView:nextPage offset:0];
        [self pageWillAppear:nextPage atIndexPath:prevIndex];


        [self layoutIfNeeded];
    } completion: ^(BOOL finished) {
        FLuuziPage *currentPage = [self pageAtIndexPath:oldCurrentPath];
        [self pageDidDisAppear:currentPage atIndexPath:oldCurrentPath];

        NSIndexPath *prevIndex = [self prevPageIndex:oldCurrentPath];
        FLuuziPage *nextPage = [self pageAtIndexPath:prevIndex];
        [self setupPageView:nextPage offset:0];
        [self pageDidAppear:nextPage atIndexPath:prevIndex];

        /// 回收不需要的页面
        [self recycleViews];
    }];

    _current = [self prevPageIndex:_current];
    // reload prev page
    NSIndexPath *prevIndex = [self prevPageIndex:_current];
    FLuuziPage  *prevPage  = [self pageAtIndexPath:prevIndex];
    [self setupPageView:prevPage offset:-1];
    [self pageWillAppear:prevPage atIndexPath:prevIndex];

    if (FLuuziViewModeCard == _mode)
    {
        /// 调整顺序
        [self bringSubviewToFront:prevPage];
    }
} /* animationToPrevPage */

- (void)setupPageView:(FLuuziPage*)pageView offset:(NSInteger)offsetFromCenter
{
    if (_mode == FLuuziViewModeSlip)
    {
        [self slip_setupPageView:pageView offset:offsetFromCenter];
    }
    else
    {
        [self card_setupPageView:pageView offset:offsetFromCenter];
    }
}

#pragma mark - rest pages
- (void)resetCurrentPage
{
    [UIView animateWithDuration:FLuuziViewAnimationDuration animations: ^{
        FLuuziPage *pageView = [self pageAtIndexPath:self.current];
        pageView.trailingConstraint.constant = 0;

        [self layoutIfNeeded];
    } completion: ^(BOOL finished) {
    }];
}

- (void)resetPrevPage:(NSIndexPath*)prevIndex
{
    [UIView animateWithDuration:FLuuziViewAnimationDuration animations: ^{
        FLuuziPage *pageView = [self pageAtIndexPath:prevIndex];
        pageView.trailingConstraint.constant = 0;

        [self layoutIfNeeded];
    } completion: ^(BOOL finished) {
    }];
}

- (void)resetNextPage:(NSIndexPath*)nextIndex
{
    [UIView animateWithDuration:FLuuziViewAnimationDuration animations: ^{
        FLuuziPage *pageView = [self pageAtIndexPath:nextIndex];
        pageView.leadingContraint.constant = 0;

        [self layoutIfNeeded];
    } completion: ^(BOOL finished) {
    }];
}

@end
