//
//  UINavigationController+Cloudox.h
//  MyNavigationBar
//
//  Created by 梅毅 on 2017/4/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Cloudox) <UINavigationBarDelegate,UINavigationControllerDelegate>

@property(copy, nonatomic)NSString *cloudox;

-(void)setNeedsNavigationBackground:(CGFloat)alpha;

@end
