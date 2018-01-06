//
//  CalculatorResultModel.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/12.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorResultModel : NSObject
@property (copy, nonatomic) NSString                *fangJiaZongE;//房价总款
@property (copy, nonatomic) NSString                *huanDaiZongE;//还贷总额
@property (copy, nonatomic) NSString                *zhiFuLiXi;//支付利息
@property (copy, nonatomic) NSString                *huanKuanYueShu;//还款月数
@property (strong, nonatomic) NSMutableArray         <PayModel *>*payArray;

@property (strong, nonatomic) NSString               *yueDiJian;//每月递减
@end
