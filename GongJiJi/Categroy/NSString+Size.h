//
//  NSString+Size.h
//  SuYunDriver
//
//  Created by 朱琳芳 on 2017/8/11.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)stringSizeWithFont:(UIFont *)font;
- (CGSize)stringSizeWithFont:(UIFont *)font constrainWidth:(NSInteger)width;
- (CGSize)stringSizeWithFont:(UIFont *)font constrainSize:(CGSize)size;

- (CGFloat)stringHeightWithFont:(UIFont *)font constrainWidth:(NSInteger)width;

@end
