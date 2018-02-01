//
//  HistoryManager.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/16.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "HistoryManager.h"
static NSString * const addArray = @"addArray";
static NSString * const createArray = @"createArray";
@implementation HistoryManager
//扫描历史记录
+ (void)addScanHistory:(NSString *)string1
{
    NSMutableArray *usArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:addArray]];
    
    NSInteger cuIndex = -1;
    for (NSInteger i = 0; i < usArray.count; i++) {
        NSString *string = [usArray objectAtIndex:i];
        if ([string1 isEqualToString:string]) {
            cuIndex = i;
        }
    }
    if (cuIndex >= 0) {
        [usArray exchangeObjectAtIndex:cuIndex withObjectAtIndex:0];
    }else{
        [usArray insertObject:string1 atIndex:0];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:usArray forKey:addArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)scanHistory
{
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:addArray];
    return array;
}

+ (void)cleanScan
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:addArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//生成历史记录
+ (void)addCreateHistory:(NSString *)string1
{
    NSMutableArray *usArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:createArray]];
    
    NSInteger cuIndex = -1;
    for (NSInteger i = 0; i < usArray.count; i++) {
        NSString *string = [usArray objectAtIndex:i];
        if ([string1 isEqualToString:string]) {
            cuIndex = i;
        }
    }
    if (cuIndex >= 0) {
        [usArray exchangeObjectAtIndex:cuIndex withObjectAtIndex:0];
    }else{
        [usArray insertObject:string1 atIndex:0];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:usArray forKey:createArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)createHistory
{
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:createArray];
    return array;
}

+ (void)cleanCreate
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:createArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
