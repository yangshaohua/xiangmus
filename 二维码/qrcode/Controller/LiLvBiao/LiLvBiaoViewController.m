//
//  LiLvBiaoViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/18.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "LiLvBiaoViewController.h"
#import "SYTopNaviBarView.h"

@interface LiLvBiaoViewController ()<UIWebViewDelegate>
{
    UIWebView *_webview;
}
@end

@implementation LiLvBiaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavigation];
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenSize.width, kScreenSize.height - kNavigationHeight)];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lilvbiao" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
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
    topNavi.titleLabel.text = NSLocalizedString(@"Interest rate table", nil);
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
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
