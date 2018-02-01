//
//  CreateBaseViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/24.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "CreateBaseViewController.h"

@interface CreateBaseViewController ()

@end

@implementation CreateBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createContentView];
    
    [self createCreateButton];
}

- (void)createContentView
{
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
}

- (void)createCreateButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"create", nil) forState:UIControlStateNormal];
    [button setTitleColor:kSkin_Color forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = kSkin_Color.CGColor;
    button.layer.borderWidth = 0.5;
    [button addTarget:self action:@selector(clickCreate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.contentView.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(35);
    }];
}

- (void)clickCreate
{
    NSString *content = [self getContent];
    if (!SYCHECK_VALID_STRING(content)) {
        [ProgressHUD show:NSLocalizedString(@"Please enter content", nil)];
        return;
    }
    CreateResultViewController *vc = [[CreateResultViewController alloc] init];
    vc.result = content;
    [kRootNavigation pushViewController:vc animated:YES];
}

- (NSString *)getContent
{
    return @"";
}
@end
