//
//  NSDate+format.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/15.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "NSDate+format.h"

@implementation NSDate (format)
+ (NSString *)getCurrentDate
{
    return [self getDateStringWithFormat:@"yyyy-MM"];
}

+ (NSString *)getDateStringWithFormat:(NSString *)formatString
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
//    [format setDateStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的日期格式
//    [format setTimeStyle:NSDateFormatterFullStyle];
    NSString *string = [format stringFromDate:date];
    return string;
}

+ (NSDate *)dateWithString:(NSString *)string
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
//    [format setDateStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的日期格式
//    [format setTimeStyle:NSDateFormatterFullStyle];
    NSDate *date = [format dateFromString:string];
    return date;
}

+ (NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSString *string = [format stringFromDate:date];
    return string;
}

+ (NSString *)yearStringWithDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSString *string = [format stringFromDate:date];
    return string;
}

+ (NSString *)yueStringWithDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    NSString *string = [format stringFromDate:date];
    return string;
}
@end
