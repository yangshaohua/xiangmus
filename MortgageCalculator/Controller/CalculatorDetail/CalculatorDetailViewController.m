//
//  CalculatorDetailViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/10.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "CalculatorDetailViewController.h"
#import "SYTopNaviBarView.h"
#import "CalculatorManager.h"
#import "ResultCell.h"
#import "CalculatorDetailViewController+Custom.h"
@import GoogleMobileAds;

@interface CalculatorDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
    CalculatorResultModel *_resultModel;
    
    CalculatorResultModel *_resultModel1;
    
    CalculatorResultModel *_resultModel2;
    
    UIView    *_buttonView;
    
    BOOL       _adHasShow;
}

@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation CalculatorDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorOfHex(0xffffff);
    
    [self initData];
    
    _resultModel = _resultModel1;
    
    [self initSubviews];
    
    [self setUpNavigation];
    
    [self addADMob];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //触发 评分／广告
    if (arc4random() % 100 >= 1) {
        if (!_adHasShow) {
            [self pingFen];
            _adHasShow = YES;
        }
    }
    
    [[self class] setGestureEnabled:YES];
}

- (void)initData
{
    //商贷或者公积金 直接用下面的方式计算
    if (self.loanType == LoanType_Commercial || self.loanType == LoanType_Accumulation) {
        _resultModel1 = [CalculatorManager getDataWithYears:self.daiKuanYears liLv:self.daiKuanLilv jinE:self.daiKuanJine withType:PayType_DengEBenXi];
        
        _resultModel2 = [CalculatorManager getDataWithYears:self.daiKuanYears liLv:self.daiKuanLilv jinE:self.daiKuanJine withType:PayType_DengEBenJin];
    }else if (self.loanType == LoanType_Combination){
        _resultModel1 = [self getLoanType_CombinationWithType:PayType_DengEBenXi];
        _resultModel2 = [self getLoanType_CombinationWithType:PayType_DengEBenJin];
    }else if (self.loanType == LoanType_Advance){
        _resultModel1 = [CalculatorManager getDataWithYears:self.daiKuanYears liLv:self.daiKuanLilv jinE:self.daiKuanJine withType:PayType_DengEBenXi shouCiHuanKuanDate:self.shouCiHuanKuanDate tiQianHuanKuanDate:self.tiQianHuanKuanDate quanBuHuanKuan:self.quanBuHuanKuan tiQianHuanKuanJinE:self.tiQianHuanKuanJinE tiQianHuanKuanFangShi:self.tiQianHuanKuanFangShi];
        
        _resultModel2 = [CalculatorManager getDataWithYears:self.daiKuanYears liLv:self.daiKuanLilv jinE:self.daiKuanJine withType:PayType_DengEBenJin shouCiHuanKuanDate:self.shouCiHuanKuanDate tiQianHuanKuanDate:self.tiQianHuanKuanDate quanBuHuanKuan:self.quanBuHuanKuan tiQianHuanKuanJinE:self.tiQianHuanKuanJinE tiQianHuanKuanFangShi:self.tiQianHuanKuanFangShi];
    }
}

- (CalculatorResultModel *)getLoanType_CombinationWithType:(PayType)type
{
    CalculatorResultModel *model = [[CalculatorResultModel alloc] init];
    CalculatorResultModel *shangYeDaiKuan = [CalculatorManager getDataWithYears:self.daiKuanYears liLv:self.daiKuanLilv jinE:self.daiKuanJine withType:type];
    
    CalculatorResultModel *gongJiJinDaiKuan = [CalculatorManager getDataWithYears:self.daiKuanYears liLv:self.gongJiJinDaiKuanLiLv jinE:self.gongJiJinDaiKuanJinE withType:type];
    
    model.fangJiaZongE = [NSString stringWithFormat:@"%.2f", shangYeDaiKuan.fangJiaZongE.doubleValue + gongJiJinDaiKuan.fangJiaZongE.doubleValue];
    model.huanDaiZongE = [NSString stringWithFormat:@"%.2f", shangYeDaiKuan.huanDaiZongE.doubleValue + gongJiJinDaiKuan.huanDaiZongE.doubleValue];
    model.zhiFuLiXi = [NSString stringWithFormat:@"%.2f", shangYeDaiKuan.zhiFuLiXi.doubleValue + gongJiJinDaiKuan.zhiFuLiXi.doubleValue];
    model.huanKuanYueShu = shangYeDaiKuan.huanKuanYueShu;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < model.huanKuanYueShu.integerValue; i++) {
        PayModel *model1 = [shangYeDaiKuan.payArray objectAtIndex:i];
        PayModel *model2 = [gongJiJinDaiKuan.payArray objectAtIndex:i];
        
        PayModel *payModel = [[PayModel alloc] init];
        payModel.yueGong = [NSString stringWithFormat:@"%.2f", model1.yueGong.doubleValue + model2.yueGong.doubleValue];
        payModel.benJin = [NSString stringWithFormat:@"%.2f", model1.benJin.doubleValue + model2.benJin.doubleValue];
        payModel.liXi = [NSString stringWithFormat:@"%.2f", payModel.yueGong.doubleValue - payModel.benJin.doubleValue];
        payModel.shengYuDaiKuan = [NSString stringWithFormat:@"%.2f", model1.shengYuDaiKuan.doubleValue + model2.shengYuDaiKuan.doubleValue];
        [array addObject:payModel];
    }
    model.payArray = array;
    
    return model;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - 广告
- (void)addADMob
{
    self.bannerView.adUnitID = kADMob_ResultUnitId;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
}

- (GADBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(20, kScreenSize.height - kADMobHeight - kTabbarSafeAeraHeight,  kScreenSize.width - 40, kADMobHeight)];
    }
    return _bannerView;
}

- (void)initSubviews
{
    [self.view addSubview:self.bannerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenSize.width, kScreenSize.height - kTabbarSafeAeraHeight - kNavigationHeight - kADMobHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self refreshUI];
}

- (void)refreshUI
{
    _tableView.tableHeaderView = [self getTableHeaderView];
    [_tableView reloadData];
}

- (UIView *)getTableHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 80)];
    view.backgroundColor = kSkin_Color;
    
    CGFloat width = ((kScreenSize.width - 20)/ 4);
    CGFloat height = CGRectGetHeight(view.frame);
    
    NSArray *keyArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"TotalPay", nil), NSLocalizedString(@"TotalLoad", nil), NSLocalizedString(@"Interest", nil), NSLocalizedString(@"PayMonths", nil), nil];
    
    NSArray *valueArray = [[NSArray alloc] initWithObjects:_resultModel.fangJiaZongE, _resultModel.huanDaiZongE, _resultModel.zhiFuLiXi, _resultModel.huanKuanYueShu, nil];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        [view addSubview:subView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = keyArray[i];
        label.textColor = ColorOfHex(0x333333);
        label.font = [UIFont boldSystemFontOfSize:14];
        [subView addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(subView.mas_left).mas_offset(10);
            make.top.mas_equalTo(subView.mas_top).mas_offset(15);
            make.width.mas_equalTo(width);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = valueArray[i];
        label1.textColor = ColorOfHex(0x333333);
        label1.font = [UIFont systemFontOfSize:16];
        [subView addSubview:label1];
        [label1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(subView.mas_left).mas_offset(10);
            make.top.mas_equalTo(label.mas_bottom).mas_offset(10);
            make.width.mas_equalTo(width);
        }];
        
        label.textAlignment = NSTextAlignmentCenter;
        label1.textAlignment = NSTextAlignmentCenter;
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorOfHex(0xe0e0e0);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(view);
        make.height.mas_equalTo(PX_1);
    }];
    return view;
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
//    topNavi.titleLabel.text = @"房贷计算器";
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront: topNavi];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"sina_back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sina_back"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(topNavi);
        make.width.height.mas_equalTo(44);
    }];
    
    [self initChangeButtonWithTopNavi:topNavi];
}

- (void)initChangeButtonWithTopNavi:(SYTopNaviBarView *)topNavi
{
    CGFloat width = 100.0;
    CGFloat height = 34.0;
    
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake((kScreenSize.width - width * 2)/2.0, kNavigationHeight - height - 5, width * 2, height)];
    _buttonView.layer.masksToBounds = YES;
    _buttonView.layer.cornerRadius = height/2.0;
    _buttonView.backgroundColor = [UIColor clearColor];
    _buttonView.layer.borderColor = ColorOfHex(0xffffff).CGColor;
    _buttonView.layer.borderWidth = 0.5;
    [topNavi addSubview:_buttonView];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * width, 0, width, height);
        [button setTitle:i == 0 ? NSLocalizedString(@"EqualInterest", nil):NSLocalizedString(@"EqualMoney", nil)  forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:button];
        if (i == 0) {
            button.backgroundColor = ColorOfHex(0xffffff);
            [button setTitleColor:kSkin_Color forState:UIControlStateNormal];
        }
    }
}

- (void)click:(UIButton *)sender
{
    for (UIButton *button in _buttonView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (sender.tag == button.tag) {
                sender.backgroundColor = ColorOfHex(0xffffff);
                [sender setTitleColor:kSkin_Color forState:UIControlStateNormal];
            }else{
                button.backgroundColor = [UIColor clearColor];
                [button setTitleColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
            }
        }
    }
    
    
    if (sender.tag == 0) {
        _resultModel = _resultModel1;
    }else{
        _resultModel = _resultModel2;
    }

    [self refreshUI];
}

#pragma mark - UITableViewDelegate/Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultModel.payArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 40)];
    view.backgroundColor = ColorOfHex(0xffffff);
    
    
    NSArray *keyArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"NO.", nil), NSLocalizedString(@"Monthly", nil), NSLocalizedString(@"Momey", nil), NSLocalizedString(@"Interest", nil), NSLocalizedString(@"SurMoney", nil), nil];
    CGFloat firstWidth = 30;
    CGFloat width = ((kScreenSize.width - firstWidth - 20) / 4);
    CGFloat height = 40.0;
    
    for (NSInteger i = 0; i < keyArray.count; i++) {
        UIView *subView = [[UIView alloc] init];
        if (i == 0) {
            subView.frame = CGRectMake(10, 0, firstWidth, height);
        }else{
            subView.frame = CGRectMake(10 + firstWidth + (i - 1) * width, 0, width, height);
        }
        [view addSubview:subView];
        UILabel *label = [[UILabel alloc] init];
        label.text = keyArray[i];
        label.textColor = ColorOfHex(0x333333);
        label.font = [UIFont systemFontOfSize:14];
        [subView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(subView);
        }];
        
        label.textAlignment = NSTextAlignmentCenter;
        
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorOfHex(0xe0e0e0);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(view);
        make.height.mas_equalTo(PX_1);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PayModel *model = [_resultModel.payArray objectAtIndex:indexPath.row];
    [cell updateSYListCellWithCalculatorModel:model andIndex:indexPath.row + 1];
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = ColorOfHex(0xffffff);
    }else{
        cell.contentView.backgroundColor = ColorOfHex(0xf5f5f5);
    }
    return cell;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
