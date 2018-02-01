//
//  HistoryViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/16.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "HistoryViewController.h"
#import "SYTopNaviBarView.h"
#import "CreateResultViewController.h"
#import "ScanResultViewController.h"
#import "QRCodeManager.h"
@import GoogleMobileAds;
@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
}
@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorOfHex(0xffffff);
    
    [self setUpNavigation];
    
    
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [self initData];
    [_tableView reloadData];
}

- (void)initData
{
    _dataArray = [NSMutableArray arrayWithArray:[HistoryManager scanHistory]];

    _dataArray1 = [NSMutableArray arrayWithArray:[HistoryManager createHistory]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"History", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront: topNavi];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"sina_back"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"sina_back"] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [topNavi addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.mas_equalTo(topNavi);
//        make.width.height.mas_equalTo(44);
//    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:NSLocalizedString(@"clean", nil) forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(topNavi);
        make.width.height.mas_equalTo(44);
    }];
}

- (void)back1
{
    [_dataArray removeAllObjects];
    [_dataArray1 removeAllObjects];
    
    [HistoryManager cleanScan];
    [HistoryManager cleanCreate];
    
    [_tableView reloadData];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(kNavigationHeight);
        make.bottom.mas_equalTo(-kADMobHeight);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _dataArray1.count;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenSize.width - 10, 30)];
    label.text = section == 0 ? NSLocalizedString(@"scan record", nil) : NSLocalizedString(@"create record", nil);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = ColorOfHex(0x333333);
    [view addSubview:label];
    
    view.backgroundColor = ColorOfHex(0xf0f0f0);
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kScreenSize.width, 0.5)];
    lineView.backgroundColor = ColorOfHex(0xe0e0e0);
    [view addSubview:lineView];
    return view;
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = ColorOfHex(0x333333);
        label.font = [UIFont systemFontOfSize:14];
        label.tag = 101;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(cell.contentView.mas_right).mas_offset(-22);
            make.bottom.mas_lessThanOrEqualTo(-10);
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
    
    NSString *title = @"";
    if (indexPath.section == 0) {
        title = [_dataArray objectAtIndex:indexPath.row];
    }else{
        title = [_dataArray1 objectAtIndex:indexPath.row];
    }
    
    UILabel *label = [cell viewWithTag:101];
    label.text = title;
    UIImageView *iamgeView = [cell viewWithTag:100];
    iamgeView.image = [QRCodeManager qrCodeImageWithContent:title codeImageSize:iamgeView.frame.size.width logo:nil logoFrame:CGRectZero red:0 green:0 blue:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *title = @"";
    if (indexPath.section == 0) {
        title = [_dataArray objectAtIndex:indexPath.row];
    }else{
        title = [_dataArray1 objectAtIndex:indexPath.row];
    }
    CreateResultViewController *vc = [[CreateResultViewController alloc] init];
    vc.result = title;
    [kRootNavigation pushViewController:vc animated:YES];
}
@end
