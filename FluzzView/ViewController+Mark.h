//
// ViewController+Mark.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "ViewController.h"
#import "HZIPPageViewSelection.h"
#import "PageView.h"

@interface ViewController (Mark)<PageViewDelegate
                                 , PageViewDataSource>

@end
@interface Mark : NSObject<HZIPPageViewSelection>
@property (nonatomic, assign) CGPoint  begin; ///< 开始位置
@property (nonatomic, assign) CGPoint  end;   ///< 结束位置
@property (nonatomic, strong) NSArray *rects;
@end
