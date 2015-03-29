//
// ViewController.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "ViewController.h"
#import "ViewController_Private.h"
#import "ViewController+Gesture.h"
#import "ViewController+Mark.h"

#import "FLuzzView.h"
#import "FluuzViewDefine.h"
#import "PageView.h"
#import "UIPanGestureRecognizerEx.h"
#import "DataSource.h"
#import "AsynchronousData.h"
#import "ContentLoader.h"

@interface ViewController ()< FLuuziViewDataSource
                              , FLuuziViewDelegate >

@end



@implementation ViewController
{
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
    self.numberOfSectionSlider.value = 1;
    self.numberOfPagesSlider.value   = 1;
    int numberOfSections = self.numberOfSectionSlider.maximumValue;

    for (int i = 0; i < numberOfSections; i++)
    {
        SectionData *sectionData = [SectionData new];
        sectionData.ID        = @(i);
        sectionData.pageDatas = [NSMutableArray array];
        [_datas setValue:sectionData forKey:[NSString stringWithFormat:@"%@", @(i)]];
    }

    self.fontSize                                = 14;
    // self.fluuzView.mode       = FLuuziViewModeCard;
    self.fluuzView.dataSource                    = self;
    self.fluuzView.delegate                      = self;

    [self.fluuzView reloadData];

    self.fluuzView.panGesture.delaysTouchesBegan = YES;

    [self buildUI_Gesture];
} /* buildUI */

#pragma mark - action
- (IBAction)changeSectionCount:(UISlider*)sender
{
    int section            = (int) sender.value - 1;

    YCLogDebug( @"%@", @(section) );
    NSIndexPath *indexPath = INDEX_PATH(0, section);
    [self.fluuzView setCurrent:indexPath];
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
    return self.numberOfSectionSlider.maximumValue;
}

- (NSUInteger)fluuzView:(FLuzzView*)view numberOfPagesInSection:(NSUInteger)section
{
    NSString    *sectionKey  = [NSString stringWithFormat:@"%@", @(section)];
    SectionData *sectionData = [_datas valueForKey:sectionKey];

    if (sectionData.state == 0)
    {
        return 1;
    }
    return sectionData.pageDatas.count;
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

    NSString    *sectionKey = [NSString stringWithFormat:@"%@", @(indexPath.section)];
    SectionData *section    = [_datas valueForKey:sectionKey];

    if ( (section.state != 2) && (section.state != 3) )
    {
        pageView.sectionLoadingIndicatorView.hidden = NO;
        pageView.pageLoadingIndicatorView.hidden    = YES;
    }
    else
    {
        pageView.sectionLoadingIndicatorView.hidden = YES;
        pageView.pageLoadingIndicatorView.hidden    = YES;


        NSArray  *pages = section.pageDatas;
        PageData *page  = [pages objectAtIndex:indexPath.row];

        if ( (page.state != 2) && (page.state != 3) )
        {
            pageView.pageLoadingIndicatorView.hidden = NO;
        }
        else
        {
            pageView.pageLoadingIndicatorView.hidden = YES;

            id content = page.content;

            pageView.indexLabel.text                 = [NSString stringWithFormat:@"%ld %ld/%ld", (long) indexPath.section, (long) indexPath.row + 1, pages.count];
            pageView.contentLabel.font               = [UIFont systemFontOfSize:self.fontSize];
            pageView.backgroundColor                 = content[@"color"];
        }
    }

    return pageView;
} /* fluuzView */

#pragma mark - FLuuziViewDelegate
- (void)fluuzView:(FLuzzView*)view pageWillAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    YCLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
    NSString    *sectionKey = [NSString stringWithFormat:@"%@", @(indexPath.section)];
    SectionData *section    = [_datas valueForKey:sectionKey];

    if ([section isNotReady])
    {
        WEAK_OBJ(self);
        [DataSource requestDataWithID:sectionKey
                               params:section
                               worker:[SectionLoader new]
                             complete: ^(id result, NSError *aError) {
            YCLogDebug(@"section load data finished. error:%@", aError ? : @"");
            [section setSuccess:aError == nil];
            STRONG_OBJ(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.fluuzView reloadData];
            });
        }];
    }
    else if(section.state == 2)
    {
        PageData *page = [section pageAtIndexPath:indexPath];

        if ([page isNotReady])
        {
            NSString *pageKey = [NSString stringWithFormat:@"%@-%@", @(indexPath.section), @(indexPath.row)];
            [DataSource requestDataWithID:pageKey
                                   params:page
                                   worker:[PageLoader new]
                                 complete: ^(id result, NSError *aError) {
                YCLogDebug(@"page load data finished. error:%@", aError ? : @"");
                [page setSuccess:aError == nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.fluuzView reloadData];
                });
            }];
        }
    }
} /* fluuzView */

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
    YCLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);

    NSString    *sectionKey = [NSString stringWithFormat:@"%@", @(indexPath.section)];
    NSString    *pageKey    = [NSString stringWithFormat:@"%@-%@", @(indexPath.section), @(indexPath.row)];
    SectionData *section    = [_datas valueForKey:sectionKey];
    PageData    *page       = [section pageAtIndexPath:indexPath];

    if ([section isLoading])
    {
        [section reset];
    }

    if ([page isLoading])
    {
        [section reset];
    }
    [DataSource cancelRequestWithID:sectionKey];
    [DataSource cancelRequestWithID:pageKey];
} /* fluuzView */

@end
