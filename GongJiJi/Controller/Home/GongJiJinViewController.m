//
//  GongJiJinViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/15.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "GongJiJinViewController.h"

@interface GongJiJinViewController ()

@end

@implementation GongJiJinViewController
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
    [self setUpNavigation];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(kNavigationHeight);
        make.bottom.mas_equalTo(self.view);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"公积金贷款", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront: topNavi];
}

- (void)initData
{
    ValueModel *vModel0 = [[ValueModel alloc] init];
    CalculatorModel *model0 = [[CalculatorModel alloc] init];
    model0.title = @"房价总款:";
    model0.desc = @"万元";
    model0.valueModel = vModel0;
    model0.modelType = CalculatorModelType_NormalFang;
    [self.dataArray addObject:model0];
    
    ValueModel *vModel1 = [[ValueModel alloc] init];
    vModel1.key = @"三成";
    vModel1.value = @"0.3";
    CalculatorModel *model1 = [[CalculatorModel alloc] init];
    model1.title = @"首付比例:";
    model1.valueModel = vModel1;
    model1.modelType = CalculatorModelType_FirstPay;
    [self.dataArray addObject:model1];
    
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
    vmodel5.key = @"基准利率(3.25%)";
    vmodel5.value = @"3.25";
    CalculatorModel *model5 = [[CalculatorModel alloc] init];
    model5.title = @"利  率:";
    model5.valueModel = vmodel5;
    model5.modelType = CalculatorModelType_LiLvGongJiJin;
    [self.dataArray addObject:model5];
}

- (UIViewController *)getPushVC
{
    CalculatorDetailViewController *VC = [[CalculatorDetailViewController alloc] init];
    VC.daiKuanJine = [self getModelWithType:CalculatorModelType_NormalDai].valueModel.value;
    VC.daiKuanYears = [self getModelWithType:CalculatorModelType_Years].valueModel.value;
    VC.daiKuanLilv = [self getModelWithType:CalculatorModelType_LiLvGongJiJin].valueModel.value;
    VC.loanType = self.loanType;
    return VC;
}

#pragma mark - FCPickerViewDelegate
- (void)didFCPickerViewSelectDidChangedWithModel:(ValueModel *)model
{
    self.currentModel.valueModel = model;
    
    //按揭年数
    if (self.currentModel.modelType == CalculatorModelType_Years) {
        CalculatorModel *changeModel = [self getModelWithType:CalculatorModelType_LiLvGongJiJin];
        
        NSInteger years = self.currentModel.valueModel.value.integerValue;
        if (years <= 5){//1-5年
            self.gongJiJinLiLv = 2.75;
        }else{//大于5年
            self.gongJiJinLiLv = 3.25;
        }
        
        changeModel.valueModel.key = [NSString stringWithFormat:@"基准利率(%.2f%@)", self.gongJiJinLiLv, @"%"];
        changeModel.valueModel.value = [NSString stringWithFormat:@"%.2f", self.gongJiJinLiLv];
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

- (void)didSYListCellDidChangedWithModel:(ValueModel *)model andCell:(SYListCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    if (index.row == 0) {
        CalculatorModel *changeModel = [self getModelWithType:CalculatorModelType_FirstPay];
        
        CalculatorModel *model1 = [self getModelWithType:CalculatorModelType_NormalDai];
        model1.valueModel.value = [NSString stringWithFormat:@"%ld", (NSInteger)(model.value.doubleValue - (model.value.doubleValue * changeModel.valueModel.value.doubleValue))];
        model1.valueModel.key = model1.valueModel.value;
        
        NSArray *array = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]];
        [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
