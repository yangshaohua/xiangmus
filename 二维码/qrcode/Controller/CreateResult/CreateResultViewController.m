//
//  CreateResultViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "CreateResultViewController.h"
#import "SYTopNaviBarView.h"
#import "QRCodeManager.h"

@interface CreateResultViewController ()<UIDocumentInteractionControllerDelegate>
{
    UIImageView *_imageView;
}
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation CreateResultViewController
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
    topNavi.titleLabel.text = NSLocalizedString(@"QRCode", nil);
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
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"share"] forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [topNavi addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(topNavi);
        make.width.height.mas_equalTo(44);
    }];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share
{
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aigei_com.mp3" ofType:nil]];
    
    self.documentInteractionController = [UIDocumentInteractionController
                                      interactionControllerWithURL:url];
    [self.documentInteractionController setDelegate:self];
    
    [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];

}

- (void)createUI
{
    CGFloat left = (kScreenSize.width - 100 - 50)/2.0;
    CGRect rect = CGRectMake(left, left, 50, 50);
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [QRCodeManager qrCodeImageWithContent:self.result codeImageSize:kScreenSize.width - 100 logo:[UIImage imageNamed:@"tab_mineselected"] logoFrame:rect red:1 green:0 blue:0];
    
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(kNavigationHeight + 20);
        make.height.mas_equalTo(kScreenSize.width - 100);
        make.width.mas_equalTo(kScreenSize.width - 100);
    }];
}

@end
