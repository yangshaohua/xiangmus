//
//  CreateViewController.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateViewController : BaseViewController
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
