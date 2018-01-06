//
//  ViewController.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/7.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
/**
 *  是否刷新
 */
@property (nonatomic, assign) BOOL isRefresh;

/**
 *  设置需要刷新
 *
 *  @param refreshState @(YES)或@(NO), 在SYTabController2中调用
 */
- (void)initRefreshState:(NSNumber *)refreshState;
- (void)showIndex:(NSInteger)index;

@end

