//
//  UIColor+Hex.m
//  SuYunDriver
//
//  Created by shaozhou li on 2017/7/18.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)lineColor {
    return [self colorOfHex:0x999999];
}

+ (UIColor *)colorOfHex:(UInt32)hex {
    return [self colorOfHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    unsigned int hex = 0;
    [scanner scanHexInt:&hex];
    return [UIColor colorOfHex:hex alpha:1.0];
}

+ (UIColor *)colorOfHex:(UInt32)hex alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0
                                     green:((hex & 0xFF00) >> 8) / 255.0
                                      blue:(hex & 0xFF) / 255.0
                                     alpha:alpha];
    return color;
}

@end
