//
//  AboutUsViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/5.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SYTopNaviBarView.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorOfHex(0xffffff);
    [self setUpNavigation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self class] setGestureEnabled:YES];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = @"关于";
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

- (void)createUI
{
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage imageNamed:@"icon 3-1"];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(80);
    }];
    NSString *realVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"房贷计算器 %@", realVer];
    label.textColor = ColorOfHex(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(imageview.mas_bottom).mas_offset(30);
    }];
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
