//
// ViewController_Private.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/29.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "ViewController.h"
#import "UIPanGestureRecognizerEx.h"
#import "FLuzzView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FLuzzView *fluuzView;
@property (weak, nonatomic) IBOutlet UISlider  *numberOfSectionSlider;
@property (weak, nonatomic) IBOutlet UISlider  *numberOfPagesSlider;

@property (nonatomic, strong) UIPanGestureRecognizerEx *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *fontChangeGesture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceLeadingToParrent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceTrailingToParrent;

@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, strong) NSMutableDictionary *datas;
@property (nonatomic, strong) NSMutableDictionary *marks;
@end
