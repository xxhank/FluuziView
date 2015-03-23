//
// PageView.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLuzzView.h"

@interface PageView : FLuuziPage
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
+ (instancetype)pageView;
@end
