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

@interface ViewController ()<FLuuziViewDataSource, FLuuziViewDelegate>
@property (weak, nonatomic) IBOutlet FLuzzView *fluuzView;
@property (weak, nonatomic) IBOutlet UISlider  *numberOfSectionSlider;
@property (weak, nonatomic) IBOutlet UISlider  *numberOfPagesSlider;
@end

@implementation ViewController
{
    NSMutableDictionary *_datas;
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

    // self.fluuzView.mode       = FLuuziViewModeCard;
    self.fluuzView.dataSource = self;
    self.fluuzView.delegate   = self;

    [self.fluuzView reloadData];
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
        pageView = [PageView pageView];
    }

    NSString *sectionKey     = [NSString stringWithFormat:@"%@", @(indexPath.section)];
    NSArray  *datasInSection = [_datas valueForKey:sectionKey];
    id        data           = [datasInSection objectAtIndex:indexPath.row];

    pageView.contentLabel.text = [NSString stringWithFormat:@"page#%ld,%ld", (long) indexPath.section, (long) indexPath.row];
    pageView.indexLabel.text   = [NSString stringWithFormat:@"%ld %ld/%ld", (long) indexPath.section, (long) indexPath.row + 1, datasInSection.count];
    pageView.backgroundColor   = data[@"color"];
    return pageView;
} /* fluuzView */

#pragma mark - FLuuziViewDelegate
- (void)fluuzView:(FLuzzView*)view pageWillAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    XXLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

- (void)fluuzView:(FLuzzView*)view pageDidAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    XXLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

- (void)fluuzView:(FLuzzView*)view pageWillDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    XXLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

- (void)fluuzView:(FLuzzView*)view pageDidDisAppear:(FLuuziPage*)pageView atIndexPath:(NSIndexPath*)indexPath
{
    XXLogInfo(@"%@ %ld,%ld", pageView, indexPath.section, indexPath.row);
}

@end
