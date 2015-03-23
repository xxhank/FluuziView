//
// UIView+LayoutChain.h
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIViewLayout : NSObject
@property (nonatomic, weak) UIView              *view;
@property (nonatomic, assign) NSLayoutAttribute  attribute;
@property (nonatomic, strong) NSArray           *constraints;
@property (nonatomic, weak)  NSLayoutConstraint *lastConstraint;

#if 0
    #pragma mark - equal
    - (void) equal:(UIViewLayout*)layout
        multiplier:(CGFloat)multiplier
          constant:(CGFloat)constant;
    - (void)equal:(UIViewLayout*)layout
         constant:(CGFloat)constant;
    - (void)equal:(UIViewLayout*)layout;
    - (void)equalToConstant:(CGFloat)constant;

    #pragma mark - less
    - (void)  less:(UIViewLayout*)layout
        multiplier:(CGFloat)multiplier
          constant:(CGFloat)constant;
    - (void)less:(UIViewLayout*)layout
        constant:(CGFloat)constant;
    - (void)less:(UIViewLayout*)layout;
    - (void)lessToConstant:(CGFloat)constant;

    #pragma mark - greater
    - (void)greater:(UIViewLayout*)layout
         multiplier:(CGFloat)multiplier
           constant:(CGFloat)constant;
    - (void)greater:(UIViewLayout*)layout
           constant:(CGFloat)constant;
    - (void)greater:(UIViewLayout*)layout;
    - (void)greaterToConstant:(CGFloat)constant;
#endif /* if 0 */
@end

/**
 *  @author 王超(技术02), 15-01-05 19:01
 *
 *  @brief  链式调用
 *  @code
 *  - (void)usage
 *  {
 *      UIView *view1, *view2;
 *
 *      view1.layout_left
 *          .equalTo(view1.layout_left)
 *          .mul(1)
 *          .constant(100)
 *          .priority(999)
 *          .install();
 *  }
 *  @endcode
 */
@interface UIViewLayout (Chain)
@property (nonatomic, readonly, copy) UIViewLayout* (^ equalTo)(UIViewLayout *right);
@property (nonatomic, readonly, copy) UIViewLayout* (^ lessThan)(UIViewLayout *right);
@property (nonatomic, readonly, copy) UIViewLayout* (^ greaterThan)(UIViewLayout *right);
@property (nonatomic, readonly, copy) UIViewLayout* (^ mul)(float mutiplier);
@property (nonatomic, readonly, copy) UIViewLayout* (^ constant)(float constant);
@property (nonatomic, readonly, copy) UIViewLayout* (^ priority)(UILayoutPriority priority);
@property (nonatomic, readonly, copy) UIViewLayout* (^ install)();/// 安装约束到相关的view
@end

/**
 *  @category
 *  @author 王超(技术02), 15-01-04 15:01
 *
 *  @brief  为UIView添加自动布局的快速方法
 *  @note 使用方法
 *  @code
 *  [view1.layout_left equal:view2.layout_left
 *                multiplier:1
 *                  constant:10];
 *  @endcode
 */

@interface UIView (UIViewLayout)
@property (nonatomic, strong) NSString *layoutName;

@property (nonatomic, readonly) UIViewLayout *layout_left;
@property (nonatomic, readonly) UIViewLayout *layout_right;
@property (nonatomic, readonly) UIViewLayout *layout_top;
@property (nonatomic, readonly) UIViewLayout *layout_bottom;
@property (nonatomic, readonly) UIViewLayout *layout_centerX;
@property (nonatomic, readonly) UIViewLayout *layout_centerY;

@property (nonatomic, readonly) UIViewLayout *layout_leading;
@property (nonatomic, readonly) UIViewLayout *layout_trailing;

@property (nonatomic, readonly) UIViewLayout *layout_width;
@property (nonatomic, readonly) UIViewLayout *layout_height;

@end
