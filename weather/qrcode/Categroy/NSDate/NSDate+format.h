//
//  NSDate+format.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/15.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (format)
+ (NSString *)getCurrentDate;

+ (NSDate *)dateWithString:(NSString *)string;

+ (NSString *)stringWithDate:(NSDate *)date;

+ (NSString *)yearStringWithDate:(NSDate *)date;
+ (NSString *)yueStringWithDate:(NSDate *)date;

@end
