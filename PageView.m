//
// PageView.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "PageView.h"
#import "FluuzViewDefine.h"

@implementation PageView
+ (instancetype)pageView
{
    UINib   *nib     = [UINib nibWithNibName:@"PageView" bundle:0];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];

    return objects[0];
}
- (void)awakeFromNib
{
    XXLogInfo( @"%@", NSStringFromSelector(_cmd) );
}
- (void)dealloc
{
    XXLogInfo( @"%@", NSStringFromSelector(_cmd) );
}
- (NSString*)description
{
    return self.indexLabel.text;
}
@end
