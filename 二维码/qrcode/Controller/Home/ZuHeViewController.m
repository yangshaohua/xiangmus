//
//  ZuHeViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/15.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "ZuHeViewController.h"

@interface ZuHeViewController ()

@end

@implementation ZuHeViewController
- (instancetype)init
{
    if (self = [super init]) {
        self.shangDaiLiLv = 4.9;
        self.gongJiJinLiLv = 3.25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initData
{
    ValueModel *vModel0 = [[ValueModel alloc] init];
    CalculatorModel *model0 = [[CalculatorModel alloc] init];
    model0.title = @"商业贷:";
    model0.desc = @"万元";
    model0.valueModel = vModel0;
    model0.modelType = CalculatorModelType_NormalDai;
    [self.dataArray addObject:model0];
    
    ValueModel *vModel1 = [[ValueModel alloc] init];
    CalculatorModel *model1 = [[CalculatorModel alloc] init];
    model1.title = @"公积金贷:";
    model1.desc = @"万元";
    model1.valueModel = vModel1;
    model1.modelType = CalculatorModelType_NormalDai;
    [self.dataArray addObject:model1];
    
    ValueModel *vModel2 = [[ValueModel alloc] init];
    vModel2.key = @"20年(240期)";
    vModel2.value = @"20";
    CalculatorModel *model2 = [[CalculatorModel alloc] init];
    model2.title = @"按揭年数:";
    model2.valueModel = vModel2;
    model2.modelType = CalculatorModelType_Years;
    [self.dataArray addObject:model2];
    
    ValueModel *vmodel3 = [[ValueModel alloc] init];
    vmodel3.key = [NSDate getCurrentDate];
    vmodel3.value = [NSDate getCurrentDate];
    CalculatorModel *model3 = [[CalculatorModel alloc] init];
    model3.title = @"首次还款时间(年月):";
    model3.valueModel = vmodel3;
    model3.modelType = CalculatorModelType_Date;
    [self.dataArray addObject:model3];
    
    ValueModel *vmodel4 = [[ValueModel alloc] init];
    vmodel4.key = @"基准利率(4.90%)";
    vmodel4.value = @"4.9";
    CalculatorModel *model4 = [[CalculatorModel alloc] init];
    model4.title = @"商业利率:";
    model4.valueModel = vmodel4;
    model4.modelType = CalculatorModelType_LiLvShangYe;
    [self.dataArray addObject:model4];
    
    ValueModel *vmodel5 = [[ValueModel alloc] init];
    vmodel5.key = @"基准利率(3.25%)";
    vmodel5.value = @"3.25";
    CalculatorModel *model5 = [[CalculatorModel alloc] init];
    model5.title = @"公积金利率:";
    model5.valueModel = vmodel5;
    model5.modelType = CalculatorModelType_LiLvGongJiJin;
    [self.dataArray addObject:model5];
}

- (UIViewController *)getPushVC
{
    CalculatorDetailViewController *VC = [[CalculatorDetailViewController alloc] init];
    VC.daiKuanJine = [self getModelWithIndex:0].valueModel.value;
    VC.gongJiJinDaiKuanJinE = [self getModelWithIndex:1].valueModel.value;
    
    VC.daiKuanYears = [self getModelWithType:CalculatorModelType_Years].valueModel.value;
    VC.daiKuanLilv = [self getModelWithType:CalculatorModelType_LiLvShangYe].valueModel.value;
    VC.gongJiJinDaiKuanLiLv = [self getModelWithType:CalculatorModelType_LiLvGongJiJin].valueModel.value;
    VC.loanType = self.loanType;
    return VC;
}

#pragma mark - FCPickerViewDelegate
- (void)didFCPickerViewSelectDidChangedWithModel:(ValueModel *)model
{
    self.currentModel.valueModel = model;
    
    //按揭年数
    if (self.currentModel.modelType == CalculatorModelType_Years) {
        CalculatorModel *changeModel = [self getModelWithType:CalculatorModelType_LiLvShangYe];
        CalculatorModel *changeModel1 = [self getModelWithType:CalculatorModelType_LiLvGongJiJin];
        
        NSInteger years = self.currentModel.valueModel.value.integerValue;
        if (years <= 1) {//1年
            self.shangDaiLiLv = 4.35;
            self.gongJiJinLiLv = 2.75;
        }else if (years > 1 && years <= 5){//1-5年
            self.shangDaiLiLv = 4.75;
            self.gongJiJinLiLv = 2.75;
        }else{//大于5年
            self.shangDaiLiLv = 4.9;
            self.gongJiJinLiLv = 3.25;
        }
        
        changeModel.valueModel.key = [NSString stringWithFormat:@"基准利率(%.2f%@)", self.shangDaiLiLv, @"%"];
        changeModel.valueModel.value = [NSString stringWithFormat:@"%.2f", self.shangDaiLiLv];
        
        changeModel1.valueModel.key = [NSString stringWithFormat:@"基准利率(%.2f%@)", self.gongJiJinLiLv, @"%"];
        changeModel1.valueModel.value = [NSString stringWithFormat:@"%.2f", self.gongJiJinLiLv];
        
        
    }
    
    [self.tableView reloadData];
}

- (void)didFCFCDatePickerViewSelectDidChangedWithModel:(ValueModel *)model
{
    self.currentModel.valueModel = model;
    
    
    [self.tableView reloadData];
}
@end
