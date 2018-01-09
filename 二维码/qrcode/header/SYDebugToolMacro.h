//
//  SYDebugToolMacro.h
//  SuYunDriver
//
//  Created by shaozhou li on 2017/7/26.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#ifndef SYDebugToolMacro_h
#define SYDebugToolMacro_h

#define _SYDEBUGGER YES // 用于测试调试阶段

#ifdef _SYDEBUGGER
#define SYLog(FORMAT, ...)                                                                                             \
fprintf(stderr, "SUYUNLOG********************************************************************\n\
%s:%d\t%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],          \
__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define SYLog(FORMAT, ...) nil
#endif

/** VALID CHECKING**/
#define SYCHECK_VALID_STRING(__string)               (__string && [__string isKindOfClass:[NSString class]] && [__string length])
#define SYCHECK_VALID_NUMBER(__aNumber)               (__aNumber && [__aNumber isKindOfClass:[NSNumber class]])
#define SYHECK_VALID_ARRAY(__aArray)                 (__aArray && [__aArray isKindOfClass:[NSArray class]] && [__aArray count])
#define SYHECK_VALID_DICT(__aDICT)                 (__aDICT && [__aDICT isKindOfClass:[NSDictionary class]] && [__aDICT allKeys])

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define WeakSelf(weakSelf)      __weak __typeof(&*self)    weakSelf  = self;
#define StrongSelf(strongSelf)  __strong __typeof(&*self) strongSelf = weakSelf;


#endif /* SYDebugToolMacro_h */
