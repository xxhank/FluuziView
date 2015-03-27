//
// PageView.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "PageView.h"
#import "FluuzViewDefine.h"
#import "SLView.h"

@interface PageView ()
@property (weak, nonatomic) IBOutlet SLView *markView;
@end

@implementation PageView
+ (instancetype)pageView
{
    UINib   *nib     = [UINib nibWithNibName:@"PageView" bundle:0];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];

    return objects[0];
}

- (void)awakeFromNib
{
    YCLogInfo( @"" );
    [self initialize];
}

- (void)dealloc
{
    YCLogInfo( @"" );
}

- (void)initialize
{
    WEAK_OBJ(self);
    [self.markView setTapInView: ^BOOL (id sender, BOOL tapInSelection) {
        STRONG_OBJ(self);
        return [self.dataSource pageView:self tapped:tapInSelection];
    }];

    [self.markView setSelections: ^NSArray*{
        STRONG_OBJ(self);
        return [self.dataSource marksForPageView:self];
    }];

    [self.markView setMarkLineFinished: ^(id < HZIPPageViewSelection > selection) {
        STRONG_OBJ(self);
        [self.delegate pageView:self markFinished:selection];
    }];

    [self.markView setRectsFromSelection: ^NSArray*(CGPoint begin, CGPoint end) {
        STRONG_OBJ(self);
        
        return [self.dataSource pageView:self rectsFromBegin:begin end:end];
    }];
} /* initialize */

- (NSString*)description
{
    return self.indexLabel.text;
}

@end
