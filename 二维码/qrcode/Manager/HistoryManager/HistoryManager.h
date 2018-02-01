//
//  HistoryManager.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/16.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryManager : NSObject

//扫描历史记录
+ (void)addScanHistory:(NSString *)string;
+ (NSMutableArray *)scanHistory;
+ (void)cleanScan;

//生成历史记录
+ (void)addCreateHistory:(NSString *)string;
+ (NSMutableArray *)createHistory;
+ (void)cleanCreate;
@end
