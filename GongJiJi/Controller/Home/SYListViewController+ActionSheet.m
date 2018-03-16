//
//  SYListViewController+ActionSheet.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/15.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "SYListViewController+ActionSheet.h"

@implementation SYListViewController (ActionSheet)
- (void)showPickerViewSelectList:(NSMutableArray *)selectList withCustomStyle:(BOOL)custom
{
    FCPickerView * pickerView = [[FCPickerView alloc] initWithDelegate:self selectList:selectList currentSelectedModel:self.currentModel.valueModel withCustom:custom];
    [pickerView show];
}

- (void)showDatePicker
{
    FCDatePickerView * pickerView = [[FCDatePickerView alloc] initWithDelegate:self selectList:nil currentSelectedModel:self.currentModel.valueModel];
    [pickerView show];
}

#pragma mark - action
- (void)selectFirstPay
{
    [self showPickerViewSelectList:[self firstPayArray] withCustomStyle:NO];
}

- (NSMutableArray *)firstPayArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *keyArray = [[NSMutableArray alloc] initWithObjects:@"一成", @"二成", @"三成", @"四成", @"五成", @"六成", @"七成", @"八成", @"九成", @"全额", nil];
    for (NSInteger i = 0; i < keyArray.count; i ++) {
        ValueModel *model = [[ValueModel alloc] init];
        model.key = keyArray[i];
        model.value = [NSString stringWithFormat:@"%.1f", (i + 1.0)/10.0];
        [array addObject:model];
    }
    return array;
}

- (void)selectYears
{
    [self showPickerViewSelectList:[self yearsArray] withCustomStyle:NO];
}

- (NSMutableArray *)yearsArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 30; i ++) {
        ValueModel *model = [[ValueModel alloc] init];
        model.key = [NSString stringWithFormat:@"%ld年(%ld期)", i + 1, (i + 1) * 12];
        model.value = [NSString stringWithFormat:@"%ld", i + 1];
        [array addObject:model];
    }
    return array;
}

- (void)selectFirstDate
{
    [self showDatePicker];
}

- (void)selectLiLvShangYe
{
    [self showPickerViewSelectList:[self liLvShangYeArray] withCustomStyle:YES];
}

- (void)selectLiLvGongJiJIn
{
    [self showPickerViewSelectList:[self liLvGongJiJinArray] withCustomStyle:YES];
}

- (NSMutableArray *)liLvShangYeArray
{
    CGFloat value = self.shangDaiLiLv;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ValueModel *model = [[ValueModel alloc] init];
    model.key = [NSString stringWithFormat:@"7折(%.2f%@)", 0.7 * value, @"%"];
    model.value = [NSString stringWithFormat:@"%.4f", 0.7 * value];
    [array addObject:model];
    
    ValueModel *model1 = [[ValueModel alloc] init];
    model1.key = [NSString stringWithFormat:@"75折(%.2f%@)", 0.75 * value, @"%"];
    model1.value = [NSString stringWithFormat:@"%.4f", 0.75 * value];
    [array addObject:model1];
    
    ValueModel *model2 = [[ValueModel alloc] init];
    model2.key = [NSString stringWithFormat:@"8折(%.2f%@)", 0.8 * value, @"%"];
    model2.value = [NSString stringWithFormat:@"%.4f", 0.8 * value];
    [array addObject:model2];
    
    ValueModel *model3 = [[ValueModel alloc] init];
    model3.key = [NSString stringWithFormat:@"85折(%.2f%@)", 0.85 * value, @"%"];
    model3.value = [NSString stringWithFormat:@"%.4f", 0.85 * value];
    [array addObject:model3];
    
    ValueModel *model4 = [[ValueModel alloc] init];
    model4.key = [NSString stringWithFormat:@"9折(%.2f%@)", 0.9 * value, @"%"];
    model4.value = [NSString stringWithFormat:@"%.4f", 0.9 * value];
    [array addObject:model4];
    
    ValueModel *model5 = [[ValueModel alloc] init];
    model5.key = [NSString stringWithFormat:@"95折(%.2f%@)", 0.95 * value, @"%"];
    model5.value = [NSString stringWithFormat:@"%.4f", 0.95 * value];
    [array addObject:model5];
    
    ValueModel *model6 = [[ValueModel alloc] init];
    model6.key = [NSString stringWithFormat:@"基准利率(%.2f%@)", value, @"%"];
    model6.value =  [NSString stringWithFormat:@"%.4f", 1 * value];
    [array addObject:model6];
    
    ValueModel *model7 = [[ValueModel alloc] init];
    model7.key = [NSString stringWithFormat:@"上浮5(%.2f%@)", 1.05 * value, @"%"];
    model7.value = [NSString stringWithFormat:@"%.4f", 1.05 * value];
    [array addObject:model7];
    
    ValueModel *model8 = [[ValueModel alloc] init];
    model8.key = [NSString stringWithFormat:@"上浮10(%.2f%@)", 1.1 * value, @"%"];
    model8.value = [NSString stringWithFormat:@"%.4f", 1.1 * value];
    [array addObject:model8];
    
    ValueModel *model9 = [[ValueModel alloc] init];
    model9.key = [NSString stringWithFormat:@"上浮15(%.2f%@)", 1.15 * value, @"%"];
    model9.value = [NSString stringWithFormat:@"%.4f", 1.15 * value];
    [array addObject:model9];
    
    ValueModel *model10 = [[ValueModel alloc] init];
    model10.key = [NSString stringWithFormat:@"上浮20(%.2f%@)", 1.2 * value, @"%"];
    model10.value = [NSString stringWithFormat:@"%.4f", 1.2 * value];
    [array addObject:model10];
    
    ValueModel *model11 = [[ValueModel alloc] init];
    model11.key = [NSString stringWithFormat:@"上浮25(%.2f%@)", 1.25 * value, @"%"];
    model11.value = [NSString stringWithFormat:@"%.4f", 1.25 * value];
    [array addObject:model11];
    
    ValueModel *model12 = [[ValueModel alloc] init];
    model12.key = [NSString stringWithFormat:@"上浮30(%.2f%@)", 1.3 * value, @"%"];
    model12.value = [NSString stringWithFormat:@"%.4f", 1.3 * value];
    [array addObject:model12];
    
    return array;
}

- (NSMutableArray *)liLvGongJiJinArray
{
    CGFloat value = self.gongJiJinLiLv;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ValueModel *model = [[ValueModel alloc] init];
    model.key = [NSString stringWithFormat:@"7折(%.2f%@)", 0.7 * value, @"%"];
    model.value = [NSString stringWithFormat:@"%.4f", 0.7 * value];
    [array addObject:model];
    
    ValueModel *model1 = [[ValueModel alloc] init];
    model1.key = [NSString stringWithFormat:@"75折(%.2f%@)", 0.75 * value, @"%"];
    model1.value = [NSString stringWithFormat:@"%.4f", 0.75 * value];
    [array addObject:model1];
    
    ValueModel *model2 = [[ValueModel alloc] init];
    model2.key = [NSString stringWithFormat:@"8折(%.2f%@)", 0.8 * value, @"%"];
    model2.value = [NSString stringWithFormat:@"%.4f", 0.8 * value];
    [array addObject:model2];
    
    ValueModel *model3 = [[ValueModel alloc] init];
    model3.key = [NSString stringWithFormat:@"85折(%.2f%@)", 0.85 * value, @"%"];
    model3.value = [NSString stringWithFormat:@"%.4f", 0.85 * value];
    [array addObject:model3];
    
    ValueModel *model4 = [[ValueModel alloc] init];
    model4.key = [NSString stringWithFormat:@"9折(%.2f%@)", 0.9 * value, @"%"];
    model4.value = [NSString stringWithFormat:@"%.4f", 0.9 * value];
    [array addObject:model4];
    
    ValueModel *model5 = [[ValueModel alloc] init];
    model5.key = [NSString stringWithFormat:@"95折(%.2f%@)", 0.95 * value, @"%"];
    model5.value = [NSString stringWithFormat:@"%.4f", 0.95 * value];
    [array addObject:model5];
    
    ValueModel *model6 = [[ValueModel alloc] init];
    model6.key = [NSString stringWithFormat:@"基准利率(%.2f%@)", value, @"%"];
    model6.value =  [NSString stringWithFormat:@"%.4f", 1 * value];
    [array addObject:model6];
    
    ValueModel *model7 = [[ValueModel alloc] init];
    model7.key = [NSString stringWithFormat:@"上浮5(%.2f%@)", 1.05 * value, @"%"];
    model7.value = [NSString stringWithFormat:@"%.4f", 1.05 * value];
    [array addObject:model7];
    
    ValueModel *model8 = [[ValueModel alloc] init];
    model8.key = [NSString stringWithFormat:@"上浮10(%.2f%@)", 1.1 * value, @"%"];
    model8.value = [NSString stringWithFormat:@"%.4f", 1.1 * value];
    [array addObject:model8];
    
    ValueModel *model9 = [[ValueModel alloc] init];
    model9.key = [NSString stringWithFormat:@"上浮15(%.2f%@)", 1.15 * value, @"%"];
    model9.value = [NSString stringWithFormat:@"%.4f", 1.15 * value];
    [array addObject:model9];
    
    ValueModel *model10 = [[ValueModel alloc] init];
    model10.key = [NSString stringWithFormat:@"上浮20(%.2f%@)", 1.2 * value, @"%"];
    model10.value = [NSString stringWithFormat:@"%.4f", 1.2 * value];
    [array addObject:model10];
    
    ValueModel *model11 = [[ValueModel alloc] init];
    model11.key = [NSString stringWithFormat:@"上浮25(%.2f%@)", 1.25 * value, @"%"];
    model11.value = [NSString stringWithFormat:@"%.4f", 1.25 * value];
    [array addObject:model11];
    
    ValueModel *model12 = [[ValueModel alloc] init];
    model12.key = [NSString stringWithFormat:@"上浮30(%.2f%@)", 1.3 * value, @"%"];
    model12.value = [NSString stringWithFormat:@"%.4f", 1.3 * value];
    [array addObject:model12];
    
    return array;
}

- (void)selectTiQianHuanKuan
{
    [self showPickerViewSelectList:[self tiQianHuanKuanArray] withCustomStyle:NO];
}

- (NSMutableArray *)tiQianHuanKuanArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ValueModel *model = [[ValueModel alloc] init];
    model.key = @"一次性提前还款";
    model.value = @"1";
    [array addObject:model];
    
    ValueModel *model1 = [[ValueModel alloc] init];
    model1.key = @"部分提前还款";
    model1.value = @"2";
    [array addObject:model1];
    
    return array;
}

- (void)selectChuLiFangShi
{
    [self showPickerViewSelectList:[self chuLiFangShiArray] withCustomStyle:NO];
}

- (NSMutableArray *)chuLiFangShiArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ValueModel *model = [[ValueModel alloc] init];
    model.key = @"还款时间不变";
    model.value = @"1";
    [array addObject:model];
    
    ValueModel *model1 = [[ValueModel alloc] init];
    model1.key = @"月供不变";
    model1.value = @"2";
    [array addObject:model1];
    
    return array;
}

#pragma mark - FCPickerViewDelegate
- (void)didFCPickerViewSelectDidChangedWithModel:(ValueModel *)model
{
    self.currentModel.valueModel = model;
    [self.tableView reloadData];
}

- (void)didFCFCDatePickerViewSelectDidChangedWithModel:(ValueModel *)model
{
    self.currentModel.valueModel = model;
    [self.tableView reloadData];
}

- (void)didSYListCellDidChangedWithModel:(ValueModel *)model
{
    
}
@end
