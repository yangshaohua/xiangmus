//
//  UITabBar+customBar.m
//  SuYunDriver
//
//  Created by 张佳炫 on 2017/8/31.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import "UITabBar+customBar.h"

@implementation UITabBar (customBar)

//设置下阴影
- (void)ul_setUpLineColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setShadowImage:img];
    [self setBackgroundImage:[[UIImage alloc]init]];
}

@end
