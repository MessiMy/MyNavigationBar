//
//  UINavigationController+Cloudox.m
//  MyNavigationBar
//
//  Created by 梅毅 on 2017/4/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import "UINavigationController+Cloudox.h"
#import <objc/runtime.h>
#import "UIViewController+Cloudox.m"

@implementation UINavigationController (Cloudox)

#pragma mark - 初始化方法
+(void)initialize
{
    if (self == [UINavigationController self]) {
        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
        SEL swizzledSelector = NSSelectorFromString(@"et__updateInteractiveTransition:");
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
#pragma mark - 设置导航栏的透明度
-(void)setNeedsNavigationBackground:(CGFloat)alpha
{
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];//_UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];//UIImageView
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        }
        else
        {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];//UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    }
    else
    {
        barBackgroundView.alpha = alpha;
    }
    //对导航栏下面的分割线做处理
    self.navigationBar.clipsToBounds = alpha == 0.0;
}
#pragma mark - 交换方法，监控滑动手势
-(void)et__updateInteractiveTransition:(CGFloat)percentComplete
{
    [self et__updateInteractiveTransition:(percentComplete)];
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        //随着滑动的过程设置导航栏的透明度渐变
        id<UIViewControllerTransitionCoordinator>coor = topVC.transitionCoordinator;
        if (coor != nil) {
            CGFloat fromAlpha = [[coor viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha floatValue];
            CGFloat toAlpha = [[coor viewControllerForKey:UITransitionContextToViewControllerKey].navBarBgAlpha floatValue];
            CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
            [self setNeedsNavigationBackground:nowAlpha];
        }
    }
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>context){
                [self dealInteractionChanges:context];
            }];
        }
    }
}
-(void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context
{
    if ([context isCancelled])//自动取消了返回手势
    {
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha floatValue];
            [self setNeedsNavigationBackground:nowAlpha];
        }];
    }
    else //自动完成了返回手势
    {
        NSTimeInterval finishedDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishedDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:UITransitionContextToViewControllerKey].navBarBgAlpha floatValue];
            [self setNeedsNavigationBackground:nowAlpha];
        }];
    }
}
#pragma mark - UINavigationBarDelegate

-(void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    if (self.viewControllers.count >= navigationBar.items.count) {//点击返回按钮
        UIViewController *popToVC = self.viewControllers[self.viewControllers.count - 1];
        [self setNeedsNavigationBackground:[popToVC.navBarBgAlpha floatValue]];
    }
}

-(void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item
{
    //push到一个新界面
    [self setNeedsNavigationBackground:[self.topViewController.navBarBgAlpha floatValue]];
}
//定义常量
//static char *CloudoxKey = "CloudoxKey";
-(void)setCloudox:(NSString *)cloudox
{
    objc_setAssociatedObject(self, CloudoxKey, cloudox, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)cloudox
{
    return objc_getAssociatedObject(self, CloudoxKey);
}

@end
