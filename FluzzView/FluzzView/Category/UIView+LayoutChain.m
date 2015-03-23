//
// UIView+LayoutChain.m
// FluzzView
//
// Created by wangchaojs02 on 15/3/22.
// Copyright (c) 2015年 wangchaojs02. All rights reserved.
//

#import "UIView+LayoutChain.h"

@implementation UIView (LayoutChain)

@end
@implementation UIViewLayout
#pragma mark -helper
+ (UIView*)commonSuperViewForView1:(UIView*)view1 view2:(UIView*)view2
{
    UIView *ancestorForView1      = view1.superview;
    int     ancestorDepthForView1 = 1;

    while (ancestorForView1 && ancestorForView1.superview)
    {
        ancestorDepthForView1++;
        ancestorForView1 = ancestorForView1.superview;
    }

    UIView *ancestorForView2      = view2.superview;
    int     ancestorDepthForView2 = 1;

    while (ancestorForView2 && ancestorForView2.superview)
    {
        ancestorDepthForView2++;
        ancestorForView2 = ancestorForView2.superview;
    }

    /// 存在共同的祖先
    if (ancestorForView1 == ancestorForView2)
    {
        /// 找到最近的祖先
        UIView *tempView1 = view1;
        UIView *tempView2 = view2;

        /// 消除偏移量
        if (ancestorDepthForView1 > ancestorDepthForView2)
        {
            int  offset = ancestorDepthForView1 - ancestorDepthForView2;

            while (offset > 0)
            {
                tempView1 = tempView1.superview;
                offset--;
            }
        }
        else
        {
            int  offset = ancestorDepthForView2 - ancestorDepthForView1;

            while (offset > 0)
            {
                tempView2 = tempView2.superview;
                offset--;
            }
        }

        /// 同步查找
        while(tempView1 != tempView2)
        {
            tempView1 = tempView1.superview;
            tempView2 = tempView2.superview;
        }

        return tempView1;
    }

    return nil;
} /* commonSuperViewForView1 */
+ (void)addConstraint:(NSLayoutConstraint*)constaint
      betweenHostView:(UIView*)hostView
           relateView:(UIView*)relateView
{
    if ( !relateView || (hostView == relateView) )
    {
        [hostView setTranslatesAutoresizingMaskIntoConstraints:NO];

        [hostView addConstraint:constaint];
    }
    else
    {
        /// 找到最近的公共父节点
        UIView *superView = nil;

        if (relateView.superview == hostView)
        {
            superView = hostView;
        }
        else if(relateView == hostView.superview)
        {
            superView = relateView;
        }
        else
        {
            superView = [[self class] commonSuperViewForView1:hostView view2:relateView];
        }

        if (superView)
        {
            [hostView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [superView addConstraint:constaint];
        }
    }
} /* addConstraint */
#pragma mark - equal
- (NSArray*)constraints
{
    if (!_constraints)
    {
        _constraints = [NSMutableArray array];
    }

    return _constraints;
}
#if 0
- (void) equal:(UIViewLayout*)layout
    multiplier:(CGFloat)multiplier
      constant:(CGFloat)constant
{
    NSLayoutConstraint *constaint =
        [NSLayoutConstraint constraintWithItem:self.view
                                     attribute:self.attribute
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:layout.view
                                     attribute:layout ? layout.attribute : NSLayoutAttributeNotAnAttribute
                                    multiplier:multiplier
                                      constant:constant];

    [(NSMutableArray*) self.constraints addObject:constaint];
    self.lastConstraint = constaint;
    [[self class] addConstraint:constaint betweenHostView:self.view relateView:layout.view];
}     /* equal */
- (void)equalToConstant:(CGFloat)constant
{
    [self equal:nil multiplier:0 constant:constant];
}
- (void)equal:(UIViewLayout*)layout
{
    [self equal:layout multiplier:1 constant:0];
}
- (void)equal:(UIViewLayout*)layout
     constant:(CGFloat)constant
{
    [self equal:layout multiplier:1 constant:constant];
}
  #pragma mark - less
- (void)  less:(UIViewLayout*)layout
    multiplier:(CGFloat)multiplier
      constant:(CGFloat)constant
{
    NSLayoutConstraint *constaint =
        [NSLayoutConstraint constraintWithItem:self.view
                                     attribute:self.attribute
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                        toItem:layout.view
                                     attribute:layout ? layout.attribute : NSLayoutAttributeNotAnAttribute
                                    multiplier:multiplier
                                      constant:constant];

    [(NSMutableArray*) self.constraints addObject:constaint];
    self.lastConstraint = constaint;
    [[self class] addConstraint:constaint betweenHostView:self.view relateView:layout.view];
}     /* less */
- (void)lessToConstant:(CGFloat)constant
{
    [self less:nil multiplier:0 constant:constant];
}
- (void)less:(UIViewLayout*)layout
{
    [self less:layout multiplier:1 constant:0];
}
- (void)less:(UIViewLayout*)layout
    constant:(CGFloat)constant
{
    [self less:layout multiplier:1 constant:constant];
}
  #pragma mark - greater
- (void)greater:(UIViewLayout*)layout
     multiplier:(CGFloat)multiplier
       constant:(CGFloat)constant
{
    NSLayoutConstraint *constaint =
        [NSLayoutConstraint constraintWithItem:self.view
                                     attribute:self.attribute
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                        toItem:layout.view
                                     attribute:layout ? layout.attribute : NSLayoutAttributeNotAnAttribute
                                    multiplier:multiplier
                                      constant:constant];

    [(NSMutableArray*) self.constraints addObject:constaint];
    self.lastConstraint = constaint;
    [[self class] addConstraint:constaint betweenHostView:self.view relateView:layout.view];
}     /* greater */
- (void)greaterToConstant:(CGFloat)constant
{
    [self greater:nil multiplier:0 constant:constant];
}
- (void)greater:(UIViewLayout*)layout
{
    [self greater:layout multiplier:1 constant:0];
}
- (void)greater:(UIViewLayout*)layout
       constant:(CGFloat)constant
{
    [self greater:layout multiplier:1 constant:constant];
}
#endif /* if 0 */
@end

#import <objc/runtime.h>

@implementation UIViewLayout (Chain)
- (NSMutableDictionary*)layoutCache
{
    id  obj = objc_getAssociatedObject(self, _cmd);

    if (!obj)
    {
        obj                = [NSMutableDictionary dictionary];
        obj[@"multiplier"] = @(1.0);
        obj[@"relation"]   = @(NSLayoutRelationEqual);
        obj[@"constant"]   = @(0);

        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN);
    }
    return obj;
} /* cache */
- ( UIViewLayout*(^)(UIViewLayout*) )equalTo
{
    return ^UIViewLayout* (UIViewLayout *right ){
               self.layoutCache[@"relation"] = @(NSLayoutRelationEqual);
               self.layoutCache[@"item"]     = right;
               return self;
    };
}
- ( UIViewLayout*(^)(UIViewLayout*) )greaterThan
{
    return ^UIViewLayout* (UIViewLayout *right ){
               self.layoutCache[@"relation"] = @(NSLayoutRelationGreaterThanOrEqual);
               self.layoutCache[@"item"]     = right;
               return self;
    };
}
- ( UIViewLayout*(^)(UIViewLayout*) )lessThan
{
    return ^UIViewLayout* (UIViewLayout *right ){
               self.layoutCache[@"relation"] = @(NSLayoutRelationLessThanOrEqual);
               self.layoutCache[@"item"]     = right;
               return self;
    };
}
- ( UIViewLayout*(^)(float) )mul
{
    return ^UIViewLayout* (float value ){
               self.layoutCache[@"multiplier"] = @(value);
               return self;
    };
}
- ( UIViewLayout*(^)(float) )constant
{
    return ^UIViewLayout* (float value ){
               self.layoutCache[@"constant"] = @(value);
               return self;
    };
}
- ( UIViewLayout*(^)(UILayoutPriority) )priority
{
    return ^UIViewLayout* (float value ){
               self.layoutCache[@"priority"] = @(value);
               return self;
    };
}
- ( UIViewLayout*(^)() )install
{
    return ^UIViewLayout* (){
               UIViewLayout       *layout     = self.layoutCache[@"item"];
               CGFloat             multiplier = [self.layoutCache[@"multiplier"] floatValue];
               CGFloat             constant   = [self.layoutCache[@"constant"] floatValue];
               NSLayoutRelation    relation   = [self.layoutCache[@"relation"] intValue];

               NSLayoutConstraint *constaint  =
                   [NSLayoutConstraint constraintWithItem:self.view
                                                attribute:self.attribute
                                                relatedBy:relation
                                                   toItem:layout.view
                                                attribute:layout ? layout.attribute : NSLayoutAttributeNotAnAttribute
                                               multiplier:multiplier
                                                 constant:constant];

               [(NSMutableArray*) self.constraints addObject:constaint];
               self.lastConstraint = constaint;
               [[self class] addConstraint:constaint betweenHostView:self.view relateView:layout.view];

               return self;
    };
} /* install */
@end
@implementation UIView (UIViewLayout)

- (NSString*)layoutName
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLayoutName:(NSString*)layoutName
{
    objc_setAssociatedObject(self, @selector(layoutName), layoutName, OBJC_ASSOCIATION_RETAIN);
}
- (UIViewLayout*)layoutForAttribute:(SEL)attribute
{
    UIViewLayout           *layout = objc_getAssociatedObject(self, attribute);
    static NSDictionary    *map    = nil;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        map = @{NSStringFromSelector( @selector(layout_left) ):@(NSLayoutAttributeLeft)
                , NSStringFromSelector( @selector(layout_right) ):@(NSLayoutAttributeRight)
                , NSStringFromSelector( @selector(layout_top) ):@(NSLayoutAttributeTop)
                , NSStringFromSelector( @selector(layout_bottom) ):@(NSLayoutAttributeBottom)
                , NSStringFromSelector( @selector(layout_centerX) ):@(NSLayoutAttributeCenterX)
                , NSStringFromSelector( @selector(layout_centerY) ):@(NSLayoutAttributeCenterY)
                , NSStringFromSelector( @selector(layout_leading) ):@(NSLayoutAttributeLeading)
                , NSStringFromSelector( @selector(layout_trailing) ):@(NSLayoutAttributeTrailing)
                , NSStringFromSelector( @selector(layout_width) ):@(NSLayoutAttributeWidth)
                , NSStringFromSelector( @selector(layout_height) ):@(NSLayoutAttributeHeight)};
    });

    if (!layout)
    {
        layout      = [UIViewLayout new];
        layout.view = self;

        NSNumber *attributeNumber = [map valueForKey:NSStringFromSelector(attribute)];

        if (!attributeNumber)
        {
            NSLog( @"%s %d %@ not exist", __FUNCTION__, __LINE__, NSStringFromSelector(attribute) );
        }

        layout.attribute = [attributeNumber integerValue];

        objc_setAssociatedObject(self, attribute, layout, OBJC_ASSOCIATION_RETAIN);
    }
    return layout;
} /* layoutForAttribute */
- (UIViewLayout*)layout_left
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_right
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_top
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_bottom
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_centerX
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_centerY
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_leading
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_trailing
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_width
{
    return [self layoutForAttribute:_cmd];
}
- (UIViewLayout*)layout_height
{
    return [self layoutForAttribute:_cmd];
}
@end
