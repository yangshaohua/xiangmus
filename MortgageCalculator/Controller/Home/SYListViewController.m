//
//  SYOrderListVC.m
//  SuYun
//
//  Created by ysh on 16/7/15.
//  Copyright © 2016年 58. All rights reserved.
//

#import "SYListViewController.h"
#import "SYListCell.h"
#import "SYListViewController+ActionSheet.h"
@interface SYListViewController ()

@end
@implementation SYListViewController

#pragma mark - Life Cycle
- (void)dealloc
{
    
}

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
    
    [self initData];
    
    [self initSubviews];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark - 初始化数据
- (void)initData
{
 
}

- (NSMutableArray *)getShouFuData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    return array;
}

#pragma mark - 初始化views
- (void)initSubviews
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = ColorOfHex(0xe0e0e0);
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(PX_1);
    }];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 100)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 30, kScreenSize.width - 60, 40);
    button.backgroundColor = kSkin_Color;
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button setTitle:@"计 算" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calculator) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
    [self.tableFooterView addSubview:button];
    
    self.tableView.tableFooterView = self.tableFooterView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    SYListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SYListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    CalculatorModel *model = self.dataArray[indexPath.row];
    [cell updateSYListCellWithCalculatorModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalculatorModel *model = [self.dataArray objectAtIndex:indexPath.row];
    self.currentModel = model;
    switch (model.modelType) {
        case CalculatorModelType_Date:
        {
            [self selectFirstDate];
        }
            break;
        case CalculatorModelType_DateTiQian:
        {
            [self selectFirstDate];
        }
            break;
        case CalculatorModelType_LiLvShangYe:
        {
            [self selectLiLvShangYe];
        }
            break;
        case CalculatorModelType_LiLvGongJiJin:
        {
            [self selectLiLvGongJiJIn];
        }
            break;
        case CalculatorModelType_FirstPay:
        {
            [self selectFirstPay];
        }
            break;
        case CalculatorModelType_Years:
        {
            [self selectYears];
        }
            break;
        case CalculatorModelType_TiQianHuanKuan:
        {
            [self selectTiQianHuanKuan];
        }
            break;
        case CalculatorModelType_ChuLiFangShi:
        {
            [self selectChuLiFangShi];
        }
            break;
            
        default:
            break;
    }
}

- (void)calculator
{
    if (![self canCalculator]) {
        [ProgressHUD show:NSLocalizedString(@"Please perfect the information", nil)];
        return;
    }
    UIViewController *vc = [self getPushVC];
    if (!vc) {
        return;
    }
    [kRootNavigation pushViewController:vc animated:YES];
}

- (UIViewController *)getPushVC
{
    CalculatorDetailViewController *VC = [[CalculatorDetailViewController alloc] init];
    VC.daiKuanJine = [self getModelWithIndex:0].valueModel.value;
    VC.daiKuanYears = [self getModelWithIndex:1].valueModel.value;
    VC.daiKuanLilv = [self getModelWithIndex:2].valueModel.value;
    return VC;
}

- (BOOL)canCalculator
{
    BOOL can = YES;
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        CalculatorModel * model = [self.dataArray objectAtIndex:i];
        if (model.valueModel.value.length <= 0) {
            can = NO;
        }
    }
    return can;
}

- (CalculatorModel *)getModelWithIndex:(NSInteger)index
{
    if (self.dataArray.count > index) {
         return [self.dataArray objectAtIndex:index];
    }
    return nil;
}

- (void)pushVC:(UIViewController *)vc
{
    
}

- (CalculatorModel *)getModelWithType:(CalculatorModelType)type
{
    CalculatorModel *model = nil;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        CalculatorModel *itemModel = self.dataArray[i];
        if (itemModel.modelType == type) {
            model = itemModel;
        }
    }
    return model;
}
@end
