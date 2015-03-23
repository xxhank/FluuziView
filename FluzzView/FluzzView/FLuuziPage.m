//
// FLuuziPage.m
// FluzzView
//
// Created by wangchao on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "FLuuziPage.h"

@interface FLuuziPage ()

@end

@implementation FLuuziPage
{
    NSLayoutConstraint *_trailingConstraint;
    NSLayoutConstraint *_leadingContraint;
}

- (NSLayoutConstraint*)trailingConstraint
{
    return _trailingConstraint;
}
- (void)setTrailingConstraint:(NSLayoutConstraint*)trailingConstraint
{
    _trailingConstraint = trailingConstraint;
}
- (NSLayoutConstraint*)leadingContraint
{
    return _leadingContraint;
}
- (void)setLeadingContraint:(NSLayoutConstraint*)leadingContraint
{
    _leadingContraint = leadingContraint;
}
@end
