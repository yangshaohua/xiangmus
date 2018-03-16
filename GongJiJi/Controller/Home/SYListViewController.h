//
//  SYOrderListVC.h
//  SuYun
//
//  Created by ysh on 16/7/15.
//  Copyright © 2016年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CalculatorDetailViewController.h"
#import "SYListCell.h"

@interface SYListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) LoanType         loanType;//贷款类型

@property (strong, nonatomic) NSMutableArray  *dataArray;//列表数据

@property (strong, nonatomic) UITableView     *tableView;

@property (strong, nonatomic) UIView          *tableFooterView;

@property (strong, nonatomic) CalculatorModel *currentModel;

@property (assign, nonatomic) CGFloat          shangDaiLiLv;//商代基准利率
@property (assign, nonatomic) CGFloat          gongJiJinLiLv;//公积金基准利率

- (void)initData;

- (void)calculator;

- (BOOL)canCalculator;

- (UIViewController *)getPushVC;

- (CalculatorModel *)getModelWithIndex:(NSInteger)index;

- (CalculatorModel *)getModelWithType:(CalculatorModelType)type;
@end
