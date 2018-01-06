//
//  ViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/7.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//
#define kTopScollViewHeight  45

#import "ViewController.h"
#import "SYTabbedView.h"
#import "SYListViewController.h"
#import "SYTopNaviBarView.h"
@import GoogleMobileAds;
#import "ShangYeViewController.h"
#import "GongJiJinViewController.h"
#import "ZuHeViewController.h"
#import "TiQianHuanDaiViewController.h"
#import "LiLvBiaoViewController.h"
#import "AboutUsViewController.h"

#import "SYMoreOptionView.h"
#import "SYPageModel.h"

@interface ViewController ()<SYTabbedViewDataSource, SYTabbedViewDelegate>
{
    NSInteger    _currentIndex;
}
@property(nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray *orderList;

@property (nonatomic, strong) SYTabbedView *tabbedView;
@end


@implementation ViewController
#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        
        self.isRefresh = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.bannerView];
    
    [self setUpNavigation];
    
    [self setUpSYTabbedView];
    
    [self addADMob];
    
    [self iniNavigation];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SYListViewController *orderListVC = [_orderList objectAtIndex:self.tabbedView.currentIndex];
    
    [orderListVC viewWillAppear:YES];
    
    [[self class] setGestureEnabled:NO];
}

#pragma mark - 广告
- (void)addADMob
{
    self.bannerView.adUnitID = kADMob_HomeUnitId;
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
        _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - kADMobHeight - kTabbarSafeAeraHeight,  kScreenSize.width - 40, kADMobHeight)];
    }
    return _bannerView;
}

#pragma mark - 初始化视图
- (void)iniNavigation
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)showIndex:(NSInteger)index
{
    if (index < self.orderList.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tabbedView showContentViewAtIndex:index];
        });
    }
}

#pragma mark - Public Methods
- (void)initRefreshState:(NSNumber *)refreshState
{
    self.isRefresh = [refreshState boolValue];
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = @"房贷计算器";
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront: topNavi];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"利率表" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(moreAnimationOption) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button];
    button.tag = 1000;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topNavi).mas_offset(-11);
        make.right.mas_equalTo(topNavi.mas_right).mas_offset(-10);
        make.width.height.mas_equalTo(22);
    }];
}

//利率表
- (void)liLvClick
{
    LiLvBiaoViewController *vc = [[LiLvBiaoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpSYTabbedView
{
    self.tabbedView = [[SYTabbedView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenBoundWidth, kScreenBoundHeight - kTabbarHeight - kNavigationHeight)];
    self.tabbedView.dataSource = self;
    self.tabbedView.delegate = self;
    [self.tabbedView showContentViewAtIndex:0];
    [self.view addSubview:self.tabbedView];
}

#pragma mark - SYTabbedViewDataSource
/*
 *  获取对应下标的详细视图，该视图对应的是同一下标的选择头部单元视图
 */
-(UIView *)tabbedView:(SYTabbedView *)tabbedView viewForIndex:(NSUInteger)index {
    
    SYListViewController *orderListVC = [self.orderList objectAtIndex:index];
    return orderListVC.view;
}

/*
 *  获取选择头部视图单元视图标题
 */
-(NSArray *)titleOfTabbedItem {
    return @[@"商业贷", @"公积金贷", @"组合贷款", @"提前还贷"];
}

/*
 *  获取选择头部视图单元格的数目和详细视图的数目，两者的数量应该一致
 */
-(NSUInteger)numberOfViewsInTabbedView {
    return self.orderList.count;
}

#pragma mark - SYTabbedViewDelegate
/**
 *  切换视图回调
 *
 */
-(void)tabbedView:(SYTabbedView *)tabbedView didChangeViewAtIndex:(NSUInteger)index {
    
    SYListViewController *orderListVC = [self.orderList objectAtIndex:index];
    //    [orderListVC showLoadingView];
    
    if (_currentIndex == index) {
        return;
    }
    _currentIndex = index;
}

/**
 *  设置选择头部视图单元格宽度
 */
-(CGFloat)tabbedView:(SYTabbedView *)tabbedView widthForItemAtIndex:(NSUInteger)index
{
    return kScreenBoundWidth / self.orderList.count;
}

-(CGFloat)heightOfHeaderInTabbedView
{
    return kTopScollViewHeight;
}

-(UIColor *)colorOfSelectedLine:(SYTabbedView *)tabbedView
{
    return kSkin_Color;
}

-(UIColor *)colorOfTabbedViewSelectedItem:(SYTabbedView *)tabbedView
{
    return kSkin_Color;
}

-(UIColor *)colorOfTabbedViewItem:(SYTabbedView *)tabbedView
{
    return ColorOfHex(0x333333);
}

-(UIColor *)colorOfHeaderBottomLine:(SYTabbedView *)tabbedView
{
    return [UIColor clearColor];
}

-(UIFont *)fontOfTabbedViewItem:(SYTabbedView *)tabbedView
{
    return [UIFont systemFontOfSize:15.0];
}

#pragma mark - Getters & Setters
- (NSMutableArray *)orderList
{
    if (_orderList == nil) {
        _orderList = [[NSMutableArray alloc] init];
        NSArray *catogryArray = [NSArray arrayWithObjects:@(LoanType_Commercial), @(LoanType_Accumulation) , @(LoanType_Combination), @(LoanType_Advance), nil];
        NSInteger count = catogryArray.count;
        for (NSInteger i = 0; i < count; i ++ ) {
            SYListViewController *VC = nil;
            if (i == 0) {
                VC = [[ShangYeViewController alloc] init];
            }else if (i == 1){
                VC = [[GongJiJinViewController alloc] init];
            }else if (i == 2){
                VC = [[ZuHeViewController alloc] init];
            }else{
                VC = [[TiQianHuanDaiViewController alloc] init];
            }
            
            VC.loanType = (LoanType)[catogryArray[i] integerValue];
            [VC.view setFrame:CGRectMake(0, 0, kScreenBoundWidth, self.tabbedView.frame.size.height - kTopScollViewHeight - kADMobHeight)];
            [_orderList addObject:VC];
        }
        
        
        
    }
    return _orderList;
}

- (void)moreAnimationOption
{
    SYMoreOptionView *moreOptionView = [[SYMoreOptionView alloc] init];
    moreOptionView.pageModel = [self transformMoreOptionModelToPageModel];
    moreOptionView.delegate = self;
    [moreOptionView show];
    
    UIView *view = [self.view viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeRotation(M_PI/4);
    } completion:^(BOOL finished) {
        
    }];
}

- (SYPageModel *)transformMoreOptionModelToPageModel
{
    SYPageModel *tempModel = [[SYPageModel alloc]init];
    NSMutableArray *toolsArray = [NSMutableArray arrayWithCapacity:0];
//    for (NSInteger i = 0; i < self.moreOptionModel.menus.count; i++) {
//        SYOrderTaskMoreOptionModel *model = [self.moreOptionModel.menus objectAtIndex:i];
//        SYToolModel *toolModel = [[SYToolModel alloc] init];
//        toolModel.iconUrl = model.iconUrl;
//        toolModel.title = model.name;
//        [toolsArray addObject:toolModel];
//    }
    SYToolModel *toolModel = [[SYToolModel alloc] init];
            toolModel.iconUrl = @"lilv";
            toolModel.title = @"利率表";
            [toolsArray addObject:toolModel];
    
    SYToolModel *toolModel1 = [[SYToolModel alloc] init];
                toolModel1.iconUrl = @"score";
    toolModel1.title = @"去评分";
    [toolsArray addObject:toolModel1];
    
    SYToolModel *toolModel2 = [[SYToolModel alloc] init];
                toolModel2.iconUrl = @"about";
    toolModel2.title = @"关于我们";
    [toolsArray addObject:toolModel2];
    
    tempModel.boxArray = toolsArray;
    return tempModel;
}

- (void)didJZMoreOptionViewClickAtIndex:(NSInteger)index
{
    UIView *view = [self.view viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        if (index == 0) {
            [self liLvClick];
        }else if (index == 1){
            NSString  * nsStringToOpen = @"itms-apps://itunes.apple.com/app/id1330266768?action=write-review";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
        }else if (index == 2){
            AboutUsViewController *vc = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
}
@end
