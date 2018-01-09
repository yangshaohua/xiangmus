//
//  TiQianHuanDaiViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/15.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "TiQianHuanDaiViewController.h"

@interface TiQianHuanDaiViewController ()

@end

@implementation TiQianHuanDaiViewController
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isYiCiXingHuanKuan]) {
        return 6;
    }else{
        return 8;
    }
}

- (BOOL)isYiCiXingHuanKuan
{
    CalculatorModel *tiQianModel = nil;
    for (CalculatorModel *model in self.dataArray) {
        if (model.modelType == CalculatorModelType_TiQianHuanKuan) {
            tiQianModel = model;
            break;
        }
    }
    if (tiQianModel.valueModel.value.integerValue == 1) {
        return YES;
    }
    return NO;
}

- (BOOL)canCalculator
{
    BOOL can = YES;
    NSInteger count = ([self getModelWithType:CalculatorModelType_TiQianHuanKuan].valueModel.value.integerValue == 1 ? 6 : self.dataArray.count);
    for (NSInteger i = 0; i < count; i ++) {
        CalculatorModel * model = [self.dataArray objectAtIndex:i];
        if (model.valueModel.value.length <= 0) {
            can = NO;
        }
    }
    return can;
}

- (void)initData
{
    ValueModel *vModel2 = [[ValueModel alloc] init];
    CalculatorModel *model2 = [[CalculatorModel alloc] init];
    model2.title = @"贷款总额:";
    model2.desc = @"万元";
    model2.valueModel = vModel2;
    model2.modelType = CalculatorModelType_NormalDai;
    [self.dataArray addObject:model2];
    
    ValueModel *vModel3 = [[ValueModel alloc] init];
    vModel3.key = @"20年(240期)";
    vModel3.value = @"20";
    CalculatorModel *model3 = [[CalculatorModel alloc] init];
    model3.title = @"按揭年数:";
    model3.valueModel = vModel3;
    model3.modelType = CalculatorModelType_Years;
    [self.dataArray addObject:model3];
    
    ValueModel *vmodel4 = [[ValueModel alloc] init];
    vmodel4.key = [NSDate getCurrentDate];
    vmodel4.value = [NSDate getCurrentDate];
    CalculatorModel *model4 = [[CalculatorModel alloc] init];
    model4.title = @"首次还款时间(年月):";
    model4.valueModel = vmodel4;
    model4.modelType = CalculatorModelType_Date;
    [self.dataArray addObject:model4];
    
    ValueModel *vmodel5 = [[ValueModel alloc] init];
    vmodel5.key = @"基准利率(4.90%)";
    vmodel5.value = @"4.9";
    CalculatorModel *model5 = [[CalculatorModel alloc] init];
    model5.title = @"利  率:";
    model5.valueModel = vmodel5;
    model5.modelType = CalculatorModelType_LiLvShangYe;
    [self.dataArray addObject:model5];
    
    ValueModel *vmodel6 = [[ValueModel alloc] init];
    vmodel6.key = [NSDate getCurrentDate];
    vmodel6.value = [NSDate getCurrentDate];
    CalculatorModel *model6 = [[CalculatorModel alloc] init];
    model6.title = @"提前还款时间(年月):";
    model6.valueModel = vmodel6;
    model6.modelType = CalculatorModelType_DateTiQian;
    [self.dataArray addObject:model6];
    
    ValueModel *vmodel7 = [[ValueModel alloc] init];
    vmodel7.key = @"一次性提前还清";
    vmodel7.value = @"1";
    CalculatorModel *model7 = [[CalculatorModel alloc] init];
    model7.title = @"提前还款方式:";
    model7.valueModel = vmodel7;
    model7.modelType = CalculatorModelType_TiQianHuanKuan;
    [self.dataArray addObject:model7];
    
    ValueModel *vModel8 = [[ValueModel alloc] init];
    CalculatorModel *model8 = [[CalculatorModel alloc] init];
    model8.title = @"提前还款金额:";
    model8.desc = @"万元";
    model8.valueModel = vModel8;
    model8.modelType = CalculatorModelType_NormalDai;
    [self.dataArray addObject:model8];
    
    ValueModel *vmodel9 = [[ValueModel alloc] init];
    vmodel9.key = @"还款时间不变";
    vmodel9.value = @"1";
    CalculatorModel *model9 = [[CalculatorModel alloc] init];
    model9.title = @"处理方式:";
    model9.valueModel = vmodel9;
    model9.modelType = CalculatorModelType_ChuLiFangShi;
    [self.dataArray addObject:model9];
}

- (UIViewController *)getPushVC
{
    CalculatorDetailViewController *VC = [[CalculatorDetailViewController alloc] init];
    VC.daiKuanJine = [self getModelWithIndex:0].valueModel.value;
    VC.daiKuanYears = [self getModelWithType:CalculatorModelType_Years].valueModel.value;
    VC.daiKuanLilv = [self getModelWithType:CalculatorModelType_LiLvShangYe].valueModel.value;
    
    VC.shouCiHuanKuanDate = [self getModelWithType:CalculatorModelType_Date].valueModel.value;
    VC.tiQianHuanKuanDate = [self getModelWithType:CalculatorModelType_DateTiQian].valueModel.value;
    VC.quanBuHuanKuan = [self getModelWithType:CalculatorModelType_TiQianHuanKuan].valueModel.value;
    VC.tiQianHuanKuanJinE = [self getModelWithIndex:6].valueModel.value;
    VC.tiQianHuanKuanFangShi = [self getModelWithType:CalculatorModelType_ChuLiFangShi].valueModel.value;
    
    VC.loanType = self.loanType;
    
    NSDate *dateShouFu = [NSDate dateWithString:VC.shouCiHuanKuanDate];
    NSDate *dateTiQian = [NSDate dateWithString:VC.tiQianHuanKuanDate];
    NSString *tiQianYear = [NSDate yearStringWithDate:dateTiQian];
    NSString *tiQianYue = [NSDate yueStringWithDate:dateTiQian];
    
    NSString *shouFuYear = [NSDate yearStringWithDate:dateShouFu];
    NSString *shouFuYue = [NSDate yueStringWithDate:dateShouFu];
    
    NSInteger yue1 = (tiQianYear.integerValue - shouFuYear.integerValue) * 12 + (tiQianYue.integerValue - shouFuYue.integerValue);
    if (yue1 <= 0) {
        [ProgressHUD show:@"提前还款时间必须大于第一次还款时间"];
        return nil;
    }
    
    if (yue1 >= tiQianYear.integerValue * 12) {
        [ProgressHUD show:@"提前还款时间必须小于等于按揭时间"];
        return nil;
    }
    
    return VC;
}

#pragma mark - FCPickerViewDelegate
- (void)didFCPickerViewSelectDidChangedWithModel:(ValueModel *)model
{
    self.currentModel.valueModel = model;
    
    //按揭年数
    if (self.currentModel.modelType == CalculatorModelType_Years) {
        CalculatorModel *changeModel = [self getModelWithType:CalculatorModelType_LiLvShangYe];
        
        NSInteger years = self.currentModel.valueModel.value.integerValue;
        if (years <= 1) {//1年
            self.shangDaiLiLv = 4.35;
        }else if (years > 1 && years <= 5){//1-5年
            self.shangDaiLiLv = 4.75;
        }else{//大于5年
            self.shangDaiLiLv = 4.9;
        }
        
        changeModel.valueModel.key = [NSString stringWithFormat:@"基准利率(%.2f%@)", self.shangDaiLiLv, @"%"];
        changeModel.valueModel.value = [NSString stringWithFormat:@"%.2f", self.shangDaiLiLv];
    }
    
    //首付比例
    if (self.currentModel.modelType == CalculatorModelType_FirstPay) {
        CalculatorModel *changeModel = [self getModelWithType:CalculatorModelType_NormalFang];
        if (changeModel.valueModel.value.integerValue > 0) {
            CalculatorModel *model = [self getModelWithType:CalculatorModelType_NormalDai];
            model.valueModel.value = [NSString stringWithFormat:@"%ld", (NSInteger)(changeModel.valueModel.value.doubleValue - (changeModel.valueModel.value.doubleValue * self.currentModel.valueModel.value.doubleValue))];
            model.valueModel.key = model.valueModel.value;
        }
    }
    
    [self.tableView reloadData];
}

- (void)didFCFCDatePickerViewSelectDidChangedWithModel:(ValueModel *)model
{
    self.currentModel.valueModel = model;
    
    
    [self.tableView reloadData];
}
@end
