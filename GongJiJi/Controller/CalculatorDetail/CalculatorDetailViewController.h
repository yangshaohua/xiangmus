//
//  CalculatorDetailViewController.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/10.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorDetailViewController : BaseViewController
@property (copy, nonatomic) NSString *daiKuanJine;
@property (copy, nonatomic) NSString *daiKuanYears;
@property (copy, nonatomic) NSString *daiKuanLilv;

@property (copy, nonatomic) NSString *gongJiJinDaiKuanJinE;
@property (copy, nonatomic) NSString *gongJiJinDaiKuanLiLv;

@property (copy, nonatomic) NSString *shouCiHuanKuanDate;//首次还款时间
@property (copy, nonatomic) NSString *tiQianHuanKuanDate;//提前还款时间
@property (assign, nonatomic) NSString *quanBuHuanKuan;//是否提前全部还款
@property (copy, nonatomic) NSString *tiQianHuanKuanJinE;//提前还款金额
@property (copy, nonatomic) NSString *tiQianHuanKuanFangShi;//提前还款处理方式

@property (assign, nonatomic) LoanType  loanType;
@end
