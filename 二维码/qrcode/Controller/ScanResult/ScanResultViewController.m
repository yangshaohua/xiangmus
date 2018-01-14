//
//  ScanResultViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/12.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "ScanResultViewController.h"
#import "SYTopNaviBarView.h"
@interface ScanResultViewController ()
@property (strong, nonatomic) UITextView *textView;
@end
@implementation ScanResultViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorOfHex(0xffffff);
    
    [self setUpNavigation];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self class] setGestureEnabled:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"scan result", nil);
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    self.textView = [[UITextView alloc] init];
    self.textView.text = self.result;
    self.textView.textColor = ColorOfHex(0x333333);
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 2;
    self.textView.layer.borderColor = kSkin_Color.CGColor;
    self.textView.layer.borderWidth = 0.5;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kNavigationHeight + 15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(150);
    }];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:NSLocalizedString(@"copy", nil) forState:UIControlStateNormal];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 2;
    copyButton.layer.borderColor = kSkin_Color.CGColor;
    copyButton.layer.borderWidth = 0.5;
    [copyButton setTitleColor:kSkin_Color forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [copyButton addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
}

- (void)copyClick
{
    [ProgressHUD show:NSLocalizedString(@"copy success", nil)];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textView.text;
}
@end
