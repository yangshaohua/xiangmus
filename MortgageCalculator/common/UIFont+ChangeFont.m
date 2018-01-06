//
//  UIFont+ChangeFont.m
//  Jiazheng
//
//  Created by xzm58 on 16/7/7.
//  Copyright © 2016年 58. All rights reserved.
//

#import "UIFont+ChangeFont.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIFont (ChangeFont)
+ (void)load
{
    Method origMethod = class_getClassMethod([self class],@selector(systemFontOfSize:));
    Method newMethod = class_getClassMethod([self class], @selector(systemFontOfSizeAlt:));
    method_exchangeImplementations(origMethod, newMethod);

    Method boldOrigMethod = class_getClassMethod([self class],@selector(boldSystemFontOfSize:));
    Method boldNewMethod = class_getClassMethod([self class], @selector(boldSystemFontOfSizeAlt:));
    method_exchangeImplementations(boldOrigMethod, boldNewMethod);
    
//    Method nameOrigMethod = class_getClassMethod([self class],@selector(fontWithName:size:));
//    Method nameNewMethod = class_getClassMethod([self class], @selector(SYfontWithName:size:));
//    method_exchangeImplementations(nameOrigMethod, nameNewMethod);
}

+ (UIFont *)systemFontOfSizeAlt:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
    if (!font) {
        if(IS_IOS10_LATER){
            fontSize -= 1.0f;
        }
        font = [UIFont systemFontOfSizeAlt:fontSize];
    }
    return font;
}

+ (UIFont *)boldSystemFontOfSizeAlt:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    if (!font) {
        if(IS_IOS10_LATER){
            fontSize -= 1.0f;
        }
        font = [UIFont systemFontOfSizeAlt:fontSize];
    }
    return font;
}

//+ (UIFont *)SYfontWithName:(NSString *)fontName size:(CGFloat)fontSize
//{
//    UIFont *font = [UIFont SYfontWithName:fontName size:fontSize];
//    if (!font) {
//        font = [UIFont systemFontOfSizeAlt:fontSize];
//    }
//    return font;
//}
@end
