//
//  CalculatorManager.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/7.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PayType){
    PayType_DengEBenXi = 0,//等额本息
    
    PayType_DengEBenJin//等额本金
};
@interface CalculatorManager : NSObject
+ (CalculatorResultModel *)getDataWithYears:(NSString *)daiKuanYears liLv:(NSString *)daiKuanLilv jinE:(NSString *)jinE withType:(PayType)payType;

+ (CalculatorResultModel *)getDataWithYears:(NSString *)daiKuanYears
                                       liLv:(NSString *)daiKuanLilv
                                       jinE:(NSString *)jinE
                                   withType:(PayType)payType
                         shouCiHuanKuanDate:(NSString *)shouCiHuanKuanDate
                         tiQianHuanKuanDate:(NSString *)tiQianHuanKuanDate quanBuHuanKuan:(NSString *)quanBuHuanKuan
                         tiQianHuanKuanJinE:(NSString *)tiQianHuanKuanJinE
                      tiQianHuanKuanFangShi:(NSString *)tiQianHuanKuanFangShi;

@end
