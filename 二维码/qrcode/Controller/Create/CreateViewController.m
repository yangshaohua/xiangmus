//
//  CreateViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "CreateViewController.h"
#import "SYTopNaviBarView.h"
#import "CreateResultViewController.h"
#import "PhotoManager.h"
#import "SYTopNaviBarView.h"
#import "SYTabbedView.h"
#import "TextViewController.h"
#import "MingPianViewController.h"
#import "DJScanViewController.h"
#import "NetViewController.h"
#import "WifiViewController.h"
@import GoogleMobileAds;
@interface CreateViewController ()<SYTabbedViewDataSource, SYTabbedViewDelegate>
{
    NSInteger    _currentIndex;
}

@property(nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) NSArray *orderList;

@property (nonatomic, strong) SYTabbedView *tabbedView;
@end

@implementation CreateViewController

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        
        self.isRefresh = NO;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigation];
    [self setUpSYTabbedView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kADMobHeight);
    }];
    [self addADMob];
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
        _bannerView = [[GADBannerView alloc] init];
        
    }
    return _bannerView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIViewController *orderListVC = [_orderList objectAtIndex:self.tabbedView.currentIndex];
    
    [orderListVC viewWillAppear:YES];
}

- (void)showIndex:(NSInteger)index
{
    if (index < self.orderList.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tabbedView showContentViewAtIndex:index];
        });
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Public Methods
- (void)initRefreshState:(NSNumber *)refreshState
{
    self.isRefresh = [refreshState boolValue];
}

#pragma mark - SYTabbedViewDataSource
/*
 *  获取对应下标的详细视图，该视图对应的是同一下标的选择头部单元视图
 */
-(UIView *)tabbedView:(SYTabbedView *)tabbedView viewForIndex:(NSUInteger)index {
    
    UIViewController *orderListVC = [self.orderList objectAtIndex:index];
    return orderListVC.view;
}

/*
 *  获取选择头部视图单元视图标题
 */
-(NSArray *)titleOfTabbedItem {
    return @[NSLocalizedString(@"Text", nil), NSLocalizedString(@"VisitCard", nil), NSLocalizedString(@"Website", nil), @"wifi"];
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
-(void)tabbedView:(SYTabbedView *)tabbedView didChangeViewAtIndex:(NSUInteger)index
{
    
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
    return 44.0;
}

-(UIColor *)colorOfSelectedLine:(SYTabbedView *)tabbedView
{
    return ColorOfHex(0xE6454A);
}

-(UIColor *)colorOfTabbedViewSelectedItem:(SYTabbedView *)tabbedView
{
    return ColorOfHex(0xE6454A);
}

-(UIColor *)colorOfTabbedViewItem:(SYTabbedView *)tabbedView
{
    return ColorOfHex(0x333333);
}

-(UIColor *)colorOfHeaderBottomLine:(SYTabbedView *)tabbedView
{
    return ColorOfHex(0xe0e0e0);
}

-(UIFont *)fontOfTabbedViewItem:(SYTabbedView *)tabbedView
{
    return [UIFont systemFontOfSize:16.0];
}

#pragma mark - Getters & Setters
- (NSArray *)orderList {
    
    if (_orderList == nil) {
        TextViewController *vc1 = [[TextViewController alloc] init];
        
        MingPianViewController *vc2 = [[MingPianViewController alloc] init];
        
        NetViewController *vc3 = [[NetViewController alloc] init];
        
        WifiViewController *vc4 = [[WifiViewController alloc] init];
        
        vc1.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - kNavigationHeight - kTabbarHeight - kADMobHeight);
        vc2.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - kNavigationHeight - kTabbarHeight - kADMobHeight);
        vc1.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - kNavigationHeight - kTabbarHeight - kADMobHeight);
        vc1.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - kNavigationHeight - kTabbarHeight - kADMobHeight);
        
        _orderList = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, nil];
    }
    return _orderList;
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"appname", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront: topNavi];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button1 setTitle:NSLocalizedString(@"clean", nil) forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"right_qrcode"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"right_qrcode"] forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(topNavi);
        make.width.height.mas_equalTo(44);
    }];
}

- (void)scan
{
    DJScanViewController *vc = [[DJScanViewController alloc] init];
    [kRootNavigation pushViewController:vc animated:YES];
}

- (void)setUpSYTabbedView
{
    self.tabbedView = [[SYTabbedView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenBoundWidth, kScreenBoundHeight - kTabbarHeight - kNavigationHeight)];
    self.tabbedView.dataSource = self;
    self.tabbedView.delegate = self;
    [self.tabbedView showContentViewAtIndex:0];
    [self.view addSubview:self.tabbedView];
}

@end
