//
//  CalculatorModel.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/8.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

typedef NS_ENUM(NSInteger, CalculatorModelType){
    CalculatorModelType_NormalFang = 0,//房子
    
    CalculatorModelType_NormalDai,//贷款
    
    CalculatorModelType_NormalTiQian,//提前贷款
    
    CalculatorModelType_Date,//  还款日期选择
    
    CalculatorModelType_DateTiQian,//  提前还日期选择
    
    CalculatorModelType_LiLvShangYe,//商业利率
    
    CalculatorModelType_LiLvGongJiJin,//公积金利率
    
    CalculatorModelType_FirstPay,//首付比例
    
    CalculatorModelType_Years,//按揭年数
    
    CalculatorModelType_TiQianHuanKuan,//提前还款方式  1、一次性提前还清。2、部分提前还清
    
    CalculatorModelType_ChuLiFangShi//处理方式 1、缩短还款年限，月还款额基本不变  2、减少月还款额，还款期不变
};

typedef NS_ENUM(NSInteger, LoanType){
    LoanType_Commercial = 0,//商业贷款
    LoanType_Accumulation,//公积金贷款
    LoanType_Combination,//组合贷款
    LoanType_Advance //提前还贷
};


#import <Foundation/Foundation.h>
@interface ValueModel : NSObject
@property (copy, nonatomic) NSString                *key;//显示
@property (copy, nonatomic) NSString                *value;//值
@end


@interface CalculatorModel : NSObject

@property (copy, nonatomic) NSString                *title;//标题

@property (strong, nonatomic) ValueModel              *valueModel;//值

@property (copy, nonatomic) NSString                *desc;//后面默认文案

@property (copy, nonatomic) NSString                *descImage;//后面默认图片

@property (assign, nonatomic) CalculatorModelType    modelType;//类型

@end
