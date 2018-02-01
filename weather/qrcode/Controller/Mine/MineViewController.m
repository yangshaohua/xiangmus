//
//  MineViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "MineViewController.h"
#import "SYTopNaviBarView.h"
#import <StoreKit/StoreKit.h>
#import "AboutUsViewController.h"
#import "HistoryViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self initData];
    
    [self createUI];
    
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"my", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront:topNavi];
}

- (void)initData
{
    _dataArray = [[NSMutableArray alloc] init];
    
    MyModel *model = [[MyModel alloc] init];
    model.name = NSLocalizedString(@"scan record", nil);
    
    MyModel *model1 = [[MyModel alloc] init];
    model1.name = NSLocalizedString(@"create record", nil);
    
    MyModel *model2 = [[MyModel alloc] init];
    model2.name = NSLocalizedString(@"goto appraise", nil);
    
    MyModel *model3 = [[MyModel alloc] init];
    model3.name = NSLocalizedString(@"Share" , nil);
    
    MyModel *model4 = [[MyModel alloc] init];
    model4.name = NSLocalizedString(@"about qrcode", nil);
    
//    [_dataArray addObject:model];
//    [_dataArray addObject:model1];
    [_dataArray addObject:model2];
    [_dataArray addObject:model3];
    [_dataArray addObject:model4];
}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(kNavigationHeight);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = ColorOfHex(0xe0e0e0);
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(cell.contentView);
            make.height.mas_equalTo(PX_1);
        }];
        
        UIImageView *arrow = [[UIImageView alloc] init];
        arrow.image = [UIImage imageNamed:@"arrow"];
        [cell.contentView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.contentView.mas_right).mas_offset(-15);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(7, 13));
        }];
    }
    
    MyModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row >= _dataArray.count) {
        return;
    }
    
    if (indexPath.row == 0){
        [self comment];
    }else if (indexPath.row == 1){
        [self share];
    }else if (indexPath.row == 2){
        AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
        [kRootNavigation pushViewController:aboutVC animated:YES];
    }
}

- (void)comment
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.3) {
            [SKStoreReviewController requestReview];
    }else{
        // iOS 10.3 之前的使用这个
        NSString  * nsStringToOpen = @"itms-apps://itunes.apple.com/app/id1330266768?action=write-review";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    }
}

- (void)share
{
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    NSString *downloadurl = @"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1335920043?mt=8";https://itunes.apple.com/cn/app/id1141301708?mt=8
    NSString *downloadurl = @"https://itunes.apple.com/cn/app/id1335920043?mt=8";
    [ShareManager shareWithTitle:name image:[UIImage imageNamed:@"icon 3-1"] url:downloadurl];
}
@end
