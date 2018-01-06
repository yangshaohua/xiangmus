//
//  SYTabbedScrollView.m
//  SuYun
//
//  Created by 郭杨 on 15/11/30.
//  Copyright © 2015年 58. All rights reserved.
//

#import "SYTabbedScrollView.h"

@implementation SYTabbedScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesMoved:touches withEvent:event];
}

@end
