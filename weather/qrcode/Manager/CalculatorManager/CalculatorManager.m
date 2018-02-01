//
//  CalculatorManager.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/7.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "CalculatorManager.h"

@implementation CalculatorManager
+ (CalculatorResultModel *)getDataWithYears:(NSString *)daiKuanYears liLv:(NSString *)daiKuanLilv jinE:(NSString *)jinE withType:(PayType)payType
{
    CalculatorResultModel *model = nil;
    if (payType == PayType_DengEBenXi) {
        model = [self getDengEBenXiDataWithYue:daiKuanYears.integerValue * 12 liLv:daiKuanLilv jinE:jinE];
    }else if (payType == PayType_DengEBenJin){
        model = [self getDengEBenJinDataWithYue:daiKuanYears.integerValue * 12 liLv:daiKuanLilv jinE:jinE];
    }
    return model;
}

+ (CalculatorResultModel *)getDengEBenXiDataWithYue:(NSInteger)yue liLv:(NSString *)daiKuanLilv jinE:(NSString *)jinE
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    //利率
    NSDecimalNumber *nianLilv = [NSDecimalNumber decimalNumberWithString:daiKuanLilv];
    NSDecimalNumber *lilv = [nianLilv decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSDecimalNumber *yueLiLv = [lilv decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
    
    //总贷款
    NSDecimalNumber *daiKuan = [[NSDecimalNumber decimalNumberWithString:jinE] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]];
    
    //每月月供额=〔贷款本金×月利率×(1＋月利率)＾还款月数〕÷〔(1＋月利率)＾还款月数-1〕
    
    NSDecimalNumber *value1 = [daiKuan decimalNumberByMultiplyingBy:yueLiLv];
    
    NSDecimalNumber *value2 = [yueLiLv decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
    NSDecimalNumber *value3 = [value2 decimalNumberByRaisingToPower:yue];
    
    NSDecimalNumber *value4 = [value3 decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1"]];
    
    NSDecimalNumber *value = [[value1 decimalNumberByMultiplyingBy:value3] decimalNumberByDividingBy:value4];
    
    CalculatorResultModel *model = [[CalculatorResultModel alloc] init];
    NSDecimalNumber *fangJiaZongE = [value decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (long)yue]]];
    model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", fangJiaZongE.doubleValue / 10000];
    model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", daiKuan.doubleValue / 10000];
    model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", [fangJiaZongE decimalNumberBySubtracting:daiKuan].doubleValue / 10000];
    model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)yue];
    
    double yueGongDouble = value.doubleValue;
    
    //每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
    for (NSInteger i = 0; i < yue; i++) {
        NSDecimalNumber *value5 = [value3 decimalNumberBySubtracting:[value2 decimalNumberByRaisingToPower:i + 1 - 1]];
        
        NSDecimalNumber *valueYueHuan = [[value1 decimalNumberByMultiplyingBy:value5] decimalNumberByDividingBy:value4];
        
        
        //每月应还本金=贷款本金×月利率×(1+月利率)^(还款月序号-1)÷〔(1+月利率)^还款月数-1〕
        NSDecimalNumber *value6 = [value2 decimalNumberByRaisingToPower:i + 1 - 1];
        
        NSDecimalNumber *valueBenJinHuan = [[value1 decimalNumberByMultiplyingBy:value6] decimalNumberByDividingBy:value4];
        
        NSDecimalNumber *shengYuBenJin = [daiKuan decimalNumberBySubtracting:valueBenJinHuan];
        
        if (shengYuBenJin.doubleValue <= 0) {
            shengYuBenJin = [[NSDecimalNumber decimalNumberWithString:@"0"] decimalNumberBySubtracting:shengYuBenJin];
        }
        
        PayModel *model = [[PayModel alloc] init];
        model.yueGong = [NSString stringWithFormat:@"%.2f", yueGongDouble];
        model.liXi = [NSString stringWithFormat:@"%.2f", valueYueHuan.doubleValue];;
        model.benJin = [NSString stringWithFormat:@"%.2f", valueBenJinHuan.doubleValue];
        model.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", shengYuBenJin.doubleValue];
        
        [array addObject:model];
        
        daiKuan = shengYuBenJin;
    }
    
    model.payArray = array;
    
    return model;
}

+ (CalculatorResultModel *)getDengEBenJinDataWithYue:(NSInteger)yue liLv:(NSString *)daiKuanLilv jinE:(NSString *)jinE
{
    /*
     等额本金还款法:
     每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
     每月应还利息=剩余本金×月利率=(贷款本金-已归还本金累计额)×月利率
     总利息=〔(总贷款额÷还款月数+总贷款额×月利率)+总贷款额÷还款月数×(1+月利率)〕÷2×还款月数-总贷款额
     */
    NSDecimalNumber *yueDec = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (long)yue]];
    //利率
    NSDecimalNumber *nianLilv = [NSDecimalNumber decimalNumberWithString:daiKuanLilv];
    NSDecimalNumber *lilv = [nianLilv decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSDecimalNumber *yueLiLv = [lilv decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
    
    //总贷款
    NSDecimalNumber *daiKuan = [[NSDecimalNumber decimalNumberWithString:jinE] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]];
    
    //每月应还本金
    NSDecimalNumber *yueBenJin = [daiKuan decimalNumberByDividingBy:yueDec];
    //每月月供递减额
    NSDecimalNumber *meiYueDiJian = [yueBenJin decimalNumberByMultiplyingBy:yueLiLv];
    //已归还本金
    NSDecimalNumber *yiHuanBenJin = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    //总还款
    NSDecimalNumber *zongJi = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < yue; i++) {
        NSDecimalNumber *value1 = [daiKuan decimalNumberByDividingBy:yueDec];
        NSDecimalNumber *value2 = [[daiKuan decimalNumberBySubtracting:yiHuanBenJin] decimalNumberByMultiplyingBy:yueLiLv];
        NSDecimalNumber *yueGong = [value1 decimalNumberByAdding:value2];
        NSDecimalNumber *liXiDec = [[daiKuan decimalNumberBySubtracting:yiHuanBenJin] decimalNumberByMultiplyingBy:yueLiLv];
        
        yiHuanBenJin = [yiHuanBenJin decimalNumberByAdding:yueBenJin];
        NSDecimalNumber *shengYuDaiKuan = [daiKuan decimalNumberBySubtracting:yiHuanBenJin];

        
        PayModel *model = [[PayModel alloc] init];
        model.yueGong = [NSString stringWithFormat:@"%.2f", yueGong.doubleValue];
        model.liXi = [NSString stringWithFormat:@"%.2f", liXiDec.doubleValue];;
        model.benJin = [NSString stringWithFormat:@"%.2f", yueBenJin.doubleValue];
        model.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan.doubleValue];;
        [array addObject:model];
        
        zongJi = [zongJi decimalNumberByAdding:yueGong];
    }
    
    CalculatorResultModel *model = [[CalculatorResultModel alloc] init];
    model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", zongJi.doubleValue / 10000];
    model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", daiKuan.doubleValue / 10000];
    model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", [zongJi decimalNumberBySubtracting:daiKuan].doubleValue / 10000];
    model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)yue];
    model.yueDiJian = [NSString stringWithFormat:@"%.2f", meiYueDiJian.doubleValue];
    
    model.payArray = array;
    
    return model;
}
/*
 等额本息还款法:
 每月月供额=〔贷款本金×月利率×(1＋月利率)＾还款月数〕÷〔(1＋月利率)＾还款月数-1〕
 每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
 每月应还本金=贷款本金×月利率×(1+月利率)^(还款月序号-1)÷〔(1+月利率)^还款月数-1〕
 总利息=还款月数×每月月供额-贷款本金
 等额本金还款法:
 每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
 每月应还本金=贷款本金÷还款月数
 每月应还利息=剩余本金×月利率=(贷款本金-已归还本金累计额)×月利率
 每月月供递减额=每月应还本金×月利率=贷款本金÷还款月数×月利率
 总利息=〔(总贷款额÷还款月数+总贷款额×月利率)+总贷款额÷还款月数×(1+月利率)〕÷2×还款月数-总贷款额
 说明:月利率=年利率÷12 15^4=15×15×15×15(15的4次方,即4个15相乘的意思)
 贷款金额:150000元
 贷款年限:5年(60个月)
 利率不变还清全部贷款时的几种情况:
 按照商业贷款,等额本息计算
 */
+ (CalculatorResultModel *)getDataWithYears:(NSString *)daiKuanYears
                                       liLv:(NSString *)daiKuanLilv
                                       jinE:(NSString *)jinE
                                   withType:(PayType)payType
                         shouCiHuanKuanDate:(NSString *)shouCiHuanKuanDate
                         tiQianHuanKuanDate:(NSString *)tiQianHuanKuanDate quanBuHuanKuan:(NSString *)quanBuHuanKuan
                         tiQianHuanKuanJinE:(NSString *)tiQianHuanKuanJinE1
                      tiQianHuanKuanFangShi:(NSString *)tiQianHuanKuanFangShi
{
    NSDate *dateShouFu = [NSDate dateWithString:shouCiHuanKuanDate];
    NSDate *dateTiQian = [NSDate dateWithString:tiQianHuanKuanDate];
    
    NSString *tiQianYear = [NSDate yearStringWithDate:dateTiQian];
    NSString *tiQianYue = [NSDate yueStringWithDate:dateTiQian];
    
    NSString *shouFuYear = [NSDate yearStringWithDate:dateShouFu];
    NSString *shouFuYue = [NSDate yueStringWithDate:dateShouFu];
    
    //利率
    NSDecimalNumber *nianLilv = [NSDecimalNumber decimalNumberWithString:daiKuanLilv];
    NSDecimalNumber *lilv = [nianLilv decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSDecimalNumber *yueLiLv = [lilv decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
    
    NSDecimalNumber *tiQianHuanHuanDec = [NSDecimalNumber decimalNumberWithString:@"0"];
    if (tiQianHuanKuanJinE1.doubleValue > 0) {
        tiQianHuanHuanDec = [[NSDecimalNumber decimalNumberWithString:tiQianHuanKuanJinE1] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]];
    }
    
    NSInteger yue = daiKuanYears.integerValue * 12;
    NSInteger yue1 = (tiQianYear.integerValue - shouFuYear.integerValue) * 12 + (tiQianYue.integerValue - shouFuYue.integerValue);
    NSInteger yue2 = yue - yue1;
    
    //等额本息算法
    if (payType == PayType_DengEBenXi) {
        CalculatorResultModel *model = [self getDengEBenXiDataWithYue:yue liLv:daiKuanLilv jinE:jinE];
        //一次性全部还款
        if (quanBuHuanKuan.integerValue == 1) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[model.payArray subarrayWithRange:NSMakeRange(0, yue1)]];
            PayModel *lastModel = (PayModel *)[array lastObject];
            
            PayModel *paymodel = [[PayModel alloc] init];
            paymodel.liXi = [NSString stringWithFormat:@"%.2f", yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue];
            paymodel.yueGong = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue + paymodel.liXi.doubleValue];
            paymodel.benJin = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue];
            paymodel.shengYuDaiKuan = @"0";
            [array addObject:paymodel];
            
            double zongE = 0;
            double lixi = 0;
            for (NSInteger i = 0; i < array.count; i++) {
                PayModel *paymodel = array[i];
                zongE += paymodel.yueGong.doubleValue;
                lixi += paymodel.liXi.doubleValue;
            }
            
            model.payArray = array;
             model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", zongE / 10000];
             model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", jinE.doubleValue];
             model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", lixi / 10000];
             model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)yue1 + 1];
            return model;
        }else{
            //部分提前还款
            //部分提前还款。并且时间不变，直接把剩余的本金再算一遍剩下的时间久行了额。
            if (tiQianHuanKuanFangShi.integerValue == 1) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:[model.payArray subarrayWithRange:NSMakeRange(0, yue1)]];
                PayModel *lastModel = (PayModel *)[array lastObject];
                
                PayModel *paymodel = [[PayModel alloc] init];
                paymodel.liXi = [NSString stringWithFormat:@"%.2f", yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue];
                paymodel.yueGong = [NSString stringWithFormat:@"%.2f", lastModel.yueGong.doubleValue + tiQianHuanHuanDec.doubleValue];
                paymodel.benJin = [NSString stringWithFormat:@"%.2f", lastModel.yueGong.doubleValue - paymodel.liXi.doubleValue + tiQianHuanHuanDec.doubleValue];
                paymodel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue - paymodel.benJin.doubleValue];
                [array addObject:paymodel];
                
                if (yue2 > 0) {
                    //剩余本金paymodel.shengYuDaiKuan。   再次进行等额本息计算
                    CalculatorResultModel *zaiCiJiSuanModel = [self getDengEBenXiDataWithYue:yue2 - 1 liLv:daiKuanLilv jinE:[NSString stringWithFormat:@"%f", paymodel.shengYuDaiKuan.doubleValue / 10000.0]];
                    
                    [array addObjectsFromArray:zaiCiJiSuanModel.payArray];
                    
                    
                    double lixi1 = 0;
                    for (NSInteger i = 0; i < array.count; i++) {
                        PayModel *model11 = array[i];
                        lixi1 += model11.liXi.doubleValue;
                    }
                    
                    //计算总额
                    model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", jinE.doubleValue];
                    model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", lixi1 / 10000];
                    model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)yue];
                    model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", model.zhiFuLiXi.doubleValue + model.huanDaiZongE.doubleValue];
                    
                    model.payArray = array;
                    return model;
                }
                
            }else{
                //部分提前还款。时间缩短
                NSMutableArray *array = [NSMutableArray arrayWithArray:[model.payArray subarrayWithRange:NSMakeRange(0, yue1)]];
                PayModel *lastModel = (PayModel *)[array lastObject];
                
                PayModel *paymodel = [[PayModel alloc] init];
                paymodel.liXi = [NSString stringWithFormat:@"%.2f", yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue];
                paymodel.yueGong = [NSString stringWithFormat:@"%.2f", lastModel.yueGong.doubleValue + tiQianHuanHuanDec.doubleValue];
                paymodel.benJin = [NSString stringWithFormat:@"%.2f", lastModel.yueGong.doubleValue - paymodel.liXi.doubleValue + tiQianHuanHuanDec.doubleValue];
                paymodel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue - paymodel.benJin.doubleValue];
                [array addObject:paymodel];
                
                double shengYuDaiKuan1 = paymodel.shengYuDaiKuan.doubleValue;
                for (NSInteger i = 0; i < yue2 - 1; i ++) {
                    //剩余的钱小于月供
                    double yueGong1 = shengYuDaiKuan1 + shengYuDaiKuan1 * yueLiLv.doubleValue;
                    if (yueGong1 <= lastModel.yueGong.doubleValue) {
                        PayModel *aModel = [[PayModel alloc] init];
                        aModel.yueGong = [NSString stringWithFormat:@"%.2f", yueGong1];
                        aModel.liXi = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1 * yueLiLv.doubleValue];
                        aModel.benJin = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1];
                        shengYuDaiKuan1 = 0;
                        aModel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", 0.0];
                        [array addObject:aModel];
                        break;
                    }else{
                        double benJin1 = lastModel.yueGong.doubleValue - shengYuDaiKuan1 * yueLiLv.doubleValue;
                        PayModel *aModel = [[PayModel alloc] init];
                        aModel.yueGong = lastModel.yueGong;
                        aModel.liXi = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1 * yueLiLv.doubleValue];
                        aModel.benJin = [NSString stringWithFormat:@"%.2f", benJin1];
                        shengYuDaiKuan1 = shengYuDaiKuan1 - benJin1;
                        aModel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1];
                        [array addObject:aModel];
                    }
                }
                
                double lixi1 = 0;
                for (NSInteger i = 0; i < array.count; i ++) {
                    PayModel *aModel = array[i];
                    lixi1 += aModel.liXi.doubleValue;
                }
                
                //计算总额
                model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", jinE.doubleValue];
                model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", lixi1 / 10000];
                model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)array.count];
                model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", (model.zhiFuLiXi.doubleValue + model.huanDaiZongE.doubleValue)];
                
                model.payArray = array;
                
                return model;
            }
        }
    }else if (payType == PayType_DengEBenJin){//等额本金算法
        //一次性还清
        CalculatorResultModel *model = [self getDengEBenJinDataWithYue:yue liLv:daiKuanLilv jinE:jinE];
        if (quanBuHuanKuan.integerValue == 1) {
            //获取等额本金列表
            NSMutableArray *array = [NSMutableArray arrayWithArray:[model.payArray subarrayWithRange:NSMakeRange(0, yue1)]];
            PayModel *lastModel = (PayModel *)[array lastObject];
            
            PayModel *paymodel = [[PayModel alloc] init];
            paymodel.liXi = [NSString stringWithFormat:@"%.2f", yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue];
            paymodel.yueGong = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue + paymodel.liXi.doubleValue];
            paymodel.benJin = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue];
            paymodel.shengYuDaiKuan = @"0";
            [array addObject:paymodel];
            
            double zongE = 0;
            double lixi = 0;
            for (NSInteger i = 0; i < array.count; i++) {
                PayModel *paymodel = array[i];
                zongE += paymodel.yueGong.doubleValue;
                lixi += paymodel.liXi.doubleValue;
            }
            
            model.payArray = array;
            model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", zongE / 10000];
            model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", jinE.doubleValue];
            model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", lixi / 10000];
            model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)yue1 + 1];
            return model;
        }else{
            //部分提前还款
            //部分提前还款。并且时间不变，直接把剩余的本金再算一遍剩下的时间。
            if (tiQianHuanKuanFangShi.integerValue == 1) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:[model.payArray subarrayWithRange:NSMakeRange(0, yue1)]];
                PayModel *lastModel = (PayModel *)[array lastObject];
                
                PayModel *paymodel = [[PayModel alloc] init];
                paymodel.liXi = [NSString stringWithFormat:@"%.2f", yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue];
                paymodel.benJin = [NSString stringWithFormat:@"%.2f", lastModel.benJin.doubleValue];
                paymodel.yueGong = [NSString stringWithFormat:@"%.2f", lastModel.benJin.doubleValue + yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue + tiQianHuanHuanDec.doubleValue];
                paymodel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue - lastModel.benJin.doubleValue - tiQianHuanHuanDec.doubleValue];
                [array addObject:paymodel];
                
                if (yue2 > 0) {
                    //剩余本金paymodel.shengYuDaiKuan。   再次进行等额本息计算
                    CalculatorResultModel *zaiCiJiSuanModel = [self getDengEBenJinDataWithYue:yue2 - 1 liLv:daiKuanLilv jinE:[NSString stringWithFormat:@"%f", paymodel.shengYuDaiKuan.doubleValue / 10000.0]];
                    
                    [array addObjectsFromArray:zaiCiJiSuanModel.payArray];
                    
                    model.payArray = array;
                    
                    double lixi1 = 0;
                    for (NSInteger i = 0; i < array.count; i ++) {
                        PayModel *aModel = array[i];
                        lixi1 += aModel.liXi.doubleValue;
                    }
                    
                    //计算总额
                    model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", jinE.doubleValue];
                    model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", lixi1 / 10000];
                    model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)yue];
                    model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", model.zhiFuLiXi.doubleValue + model.huanDaiZongE.doubleValue];
                    return model;
                }
                
            }else{
                //部分提前还款。时间缩短
                NSMutableArray *array = [NSMutableArray arrayWithArray:[model.payArray subarrayWithRange:NSMakeRange(0, yue1)]];
                PayModel *lastModel = (PayModel *)[array lastObject];
                
                PayModel *paymodel = [[PayModel alloc] init];
                paymodel.liXi = [NSString stringWithFormat:@"%.2f", yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue];
                paymodel.benJin = [NSString stringWithFormat:@"%.2f", lastModel.benJin.doubleValue];
                paymodel.yueGong = [NSString stringWithFormat:@"%.2f", lastModel.benJin.doubleValue + yueLiLv.doubleValue * lastModel.shengYuDaiKuan.doubleValue + tiQianHuanHuanDec.doubleValue];
                paymodel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", lastModel.shengYuDaiKuan.doubleValue - lastModel.benJin.doubleValue - tiQianHuanHuanDec.doubleValue];
                [array addObject:paymodel];
                
                double shengYuDaiKuan1 = paymodel.shengYuDaiKuan.doubleValue;
                for (NSInteger i = 0; i < yue2 - 1; i ++) {
                    //剩余的贷款小于 本金  直接换完
                    if (lastModel.benJin.doubleValue >= shengYuDaiKuan1) {
                        PayModel *aModel = [[PayModel alloc] init];
                        aModel.yueGong = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1 + shengYuDaiKuan1 * yueLiLv.doubleValue];
                        aModel.liXi = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1 * yueLiLv.doubleValue];
                        aModel.benJin = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1];
                        shengYuDaiKuan1 = 0;
                        aModel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", 0.0];
                        [array addObject:aModel];
                        break;
                    }else{
                        PayModel *aModel = [[PayModel alloc] init];
                        aModel.liXi = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1 * yueLiLv.doubleValue];
                        aModel.benJin = [NSString stringWithFormat:@"%.2f", lastModel.benJin.doubleValue];//本金不变
                        aModel.yueGong = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1 * yueLiLv.doubleValue + lastModel.benJin.doubleValue];
                        shengYuDaiKuan1 = shengYuDaiKuan1 - lastModel.benJin.doubleValue;
                        aModel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", shengYuDaiKuan1];
                        [array addObject:aModel];
                    }
                }
                
                double lixi1 = 0;
                for (NSInteger i = 0; i < array.count; i ++) {
                    PayModel *aModel = array[i];
                    lixi1 += aModel.liXi.doubleValue;
                }
                
                //计算总额
                model.huanDaiZongE = [NSString stringWithFormat:@"%.2f万", jinE.doubleValue];
                model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f万", lixi1 / 10000];
                model.huanKuanYueShu = [NSString stringWithFormat:@"%ld", (long)array.count];
                model.fangJiaZongE = [NSString stringWithFormat:@"%.2f万", (model.zhiFuLiXi.doubleValue + model.huanDaiZongE.doubleValue)];
                
                model.payArray = array;
                
                return model;
            
            }
        }
    }
    
    return nil;
}
@end
