//
//  UIColor+Hex.h
//  SuYunDriver
//
//  Created by shaozhou li on 2017/7/18.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 线条颜色
 */
+ (UIColor *)lineColor;

/**
 获取十六进制颜色
 
 @param hex 十六进制数值
 */
+ (UIColor *)colorOfHex:(UInt32)hex;

/**
 获取十六进制颜色
 
 @param hexString 十六进制字符串 @"0xff0000"
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 获取十六进制颜色
 
 @param hex 十六进制数值
 @param alpha 透明度
 */
+ (UIColor *)colorOfHex:(UInt32)hex alpha:(CGFloat)alpha;



@end
