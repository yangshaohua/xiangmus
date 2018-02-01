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
@interface CreateViewController ()<UITextViewDelegate>
{
    UILabel *_lable;
}
@property (strong, nonatomic) UITextView *textView;
@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation CreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 self.view.backgroundColor = ColorOfHex(0xffffff);
    [self setUpNavigation];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notication:) name:UITextViewTextDidChangeNotification object:nil];
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textView endEditing:YES];
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"create qrcode", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront:topNavi];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"sina_back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sina_back"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(topNavi);
        make.width.height.mas_equalTo(44);
    }];
}

- (void)back
{
    [kRootNavigation popViewControllerAnimated:YES];
}

- (void)createUI
{
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = ColorOfHex(0x333333);
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 2;
    self.textView.delegate = self;
    self.textView.layer.borderColor = kSkin_Color.CGColor;
    self.textView.layer.borderWidth = 0.5;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kNavigationHeight + 15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(150);
    }];
    
    _lable = [[UILabel alloc] init];
    _lable.text = NSLocalizedString(@"Please enter content", nil);
    _lable.textColor = ColorOfHex(0x999999);
    _lable.font = [UIFont systemFontOfSize:14];
    [self.textView addSubview:_lable];
    [_lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textView).mas_offset(5);
        make.top.mas_equalTo(self.textView).mas_offset(10);
    }];
    
    CGFloat width = 70;
    CGFloat leftSpace = (kScreenSize.width - 70 - width * 2)/2.0;
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:NSLocalizedString(@"clear", nil) forState:UIControlStateNormal];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 2;
    copyButton.layer.borderColor = kSkin_Color.CGColor;
    copyButton.layer.borderWidth = 0.5;
    [copyButton setTitleColor:kSkin_Color forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [copyButton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(leftSpace);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(width);
    }];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:NSLocalizedString(@"create", nil) forState:UIControlStateNormal];
    clearButton.layer.masksToBounds = YES;
    clearButton.layer.cornerRadius = 2;
    clearButton.layer.borderColor = kSkin_Color.CGColor;
    clearButton.layer.borderWidth = 0.5;
    [clearButton setTitleColor:kSkin_Color forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearButton addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(copyButton.mas_right).mas_offset(70);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-leftSpace);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(width);
    }];
}

- (void)copyClick
{
    if (self.textView.text.length <= 0) {
        [ProgressHUD show:NSLocalizedString(@"Please enter content", nil)];
        return;
    }
    CreateResultViewController *scanResultVC = [[CreateResultViewController alloc] init];
    scanResultVC.result = self.textView.text;
    [kRootNavigation pushViewController:scanResultVC animated:YES];
}

- (void)clearClick
{
    _textView.text = @"";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
}

- (void)notication:(NSNotification *)notication
{
    if (self.textView.text.length <= 0) {
        _lable.hidden = NO;
    }else{
        _lable.hidden = YES;
    }
}


@end
