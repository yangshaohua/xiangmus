//
//  UITabBar+badge.m
//  SuYunDriver
//
//  Created by 于洪志 on 2017/9/22.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import "UITabBar+badge.h"

@implementation UITabBar (badge)


-(UIView *)showBadgeOnItmIndex:(NSInteger )index withItemsCount:(NSInteger)count{
    //新建小红点
    UIView *bview = [[UIView alloc]init];
    bview.tag = 888+index;
    bview.layer.cornerRadius = 3;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.65)/count;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    bview.frame = CGRectMake(x, y, 6, 6);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
    return bview;
}

@end
