//
//  NSString+Size.m
//  SuYunDriver
//
//  Created by 朱琳芳 on 2017/8/11.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)stringSizeWithFont:(UIFont *)font constrainSize:(CGSize)size{
    if ([self isEmpty]) {
        return CGSizeZero;
    }
    return [self boundingRectWithSize:CGSizeMake(size.width, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
- (CGSize)stringSizeWithFont:(UIFont *)font constrainWidth:(NSInteger)width{
    if ([self isEmpty]) {
        return CGSizeZero;
    }
    return [self boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (CGFloat)stringHeightWithFont:(UIFont *)font constrainWidth:(NSInteger)width{
    if ([self isEmpty]) {
        return 0;
    }
     return [self boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

- (CGSize)stringSizeWithFont:(UIFont *)font{
    if ([self isEmpty]) {
        return CGSizeZero;
    }
    return [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
}


- (BOOL)isEmpty{
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (self == nil) {
        return YES;
    }
    if (self.length == 0 ||
        [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return YES;
    }
    if ([self isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

@end
