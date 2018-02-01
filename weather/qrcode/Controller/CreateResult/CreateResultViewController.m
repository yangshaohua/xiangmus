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
#import "SDImageCache.h"
#import "UIColor+Hex.h"
#import "UIViewController+UploadImage.h"

@interface CreateResultViewController ()<UIDocumentInteractionControllerDelegate>
{
    UIImageView *_imageView;
    NSInteger  _colorIndex;
    UIImage   *_image;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
}
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation CreateResultViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorOfHex(0xffffff);
    
    [self setUpNavigation];
    
    [self createUI];
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [HistoryManager addCreateHistory:self.result];
    
//    [self.view addSubview:self.bannerView];
//    [self addADMob];

    if (arc4random() % 3 == 0) {
        [[ShowAdManager sharedInstance] showADWithDurition:3];
    }
}

#pragma mark - 广告
- (void)addADMob
{
    self.bannerView.adUnitID = kADMob_ResultUnitId;
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
        _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - kADMobHeight - kTabbarHeight - kTabbarSafeAeraHeight,  kScreenSize.width - 40, kADMobHeight)];
    }
    return _bannerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [ShareManager shareWithTitle:nil image:_imageView.image url:nil];
}

- (void)createUI
{
    _imageView = [[UIImageView alloc] init];
    [self r:0 g:0 b:0];
    
    CGFloat width = kScreenSize.width - 200;
    if (IS_IPAD) {
        width = 400;
    }
    
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-(kScreenSize.width - width)/2.0);
        make.top.mas_equalTo(kNavigationHeight + 20);
        make.height.mas_equalTo(width);
        make.width.mas_equalTo(width);
    }];
    
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_imageView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:kSkin_Color];
    [button setTitle:@"Color" forState:UIControlStateNormal];
    [scrollview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(scrollview);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    
    for (NSInteger i = 0; i < [ColorManager colorArray].count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor colorWithHexString:[[ColorManager colorArray] objectAtIndex:i]]];
        button.frame = CGRectMake(60 + i * 60, 0, 50, 50);
        [scrollview addSubview:button];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 25;
        button.tag = i;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    scrollview.contentSize = CGSizeMake(60 + 60 * [ColorManager colorArray].count, 30);
    scrollview.scrollEnabled = YES;
    scrollview.bounces = YES;
    
    UIScrollView *scrollview1 = [[UIScrollView alloc] init];
    [self.view addSubview:scrollview1];
    [scrollview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(scrollview.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundColor:kSkin_Color];
    [button1 setTitle:@"Logo" forState:UIControlStateNormal];
    [scrollview1 addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(scrollview1);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundColor:kSkin_Color];
    [button2 setTitle:NSLocalizedString(@"Clean logo", nil) forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    [scrollview1 addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button1.mas_right).mas_offset(10);
        make.top.mas_equalTo(scrollview1);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setBackgroundColor:kSkin_Color];
    [button3 setTitle:NSLocalizedString(@"DIY", nil) forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(diy) forControlEvents:UIControlEventTouchUpInside];
    [scrollview1 addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button2.mas_right).mas_offset(10);
        make.top.mas_equalTo(scrollview1);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    for (NSInteger i = 0; i < [ColorManager logoArray].count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[[ColorManager logoArray] objectAtIndex:i]] forState:UIControlStateNormal];
        button.frame = CGRectMake(180 + i * 60, 0, 50, 50);
        [scrollview1 addSubview:button];
        button.tag = i;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 25;
        [button addTarget:self action:@selector(logoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    scrollview1.contentSize = CGSizeMake(180 + 60 * [ColorManager logoArray].count, 30);
    scrollview1.scrollEnabled = YES;
    scrollview1.bounces = YES;
}

- (void)diy
{
    [self headImageClick];
}

- (void)clean
{
    _image = nil;
    [self r:red g:green b:blue];
}

- (void)logoClick:(UIButton *)sender
{
    _image = [UIImage imageNamed:[[ColorManager logoArray] objectAtIndex:sender.tag]];
    [self r:red g:green b:blue];
}

- (void)clicklogo
{
    [self headImageClick];
}

- (void)photoDidSelectImage:(UIImage *)image imageUrl:(NSURL *)imageUrl
{
    if (!image) {
        return;
    }
    _image = image;
    [self r:red g:green b:blue];
}

- (BOOL)isImageAllowEditing
{
    return YES;
}

- (void)click:(UIButton *)sender
{
    _colorIndex = sender.tag;
    NSString *string = [[ColorManager colorArray] objectAtIndex:sender.tag];
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    unsigned int hex = 0;
    [scanner scanHexInt:&hex];
    
    
    red = ((hex & 0xFF0000) >> 16) / 255.0;
    green = ((hex & 0xFF00) >> 8) / 255.0;
    blue = (hex & 0xFF) / 255.0;
    [self r:red g:green b:blue];
}

- (void)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    CGFloat left = (kScreenSize.width - 100 - 60)/2.0;
    CGRect rect = CGRectMake(left, left, 60, 60);
    _imageView.image = [QRCodeManager qrCodeImageWithContent:self.result codeImageSize:kScreenSize.width - 100 logo:_image logoFrame:rect red:r green:g blue:b];
}
@end
