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
#import "SYActionSheetView.h"
@import GoogleMobileAds;
@interface CreateResultViewController ()<UIDocumentInteractionControllerDelegate>
{
    UIImageView *_imageView;
    NSInteger  _colorIndex;
    UIImage   *_image;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    NSInteger _selectType;  //0颜色   1 logo
    
    SYActionSheetView *actionSheetView;
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
        _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - kADMobHeight - kTabbarSafeAeraHeight,  kScreenSize.width - 40, kADMobHeight)];
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
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view insertSubview:imageView atIndex:0];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d", arc4random() % 2 + 1]];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = ColorOfHex(0xffffff);
    [self r:0 g:0 b:0];
    
    CGFloat width = kScreenSize.width - 150;
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
    
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button0 setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [button0 setTitleColor:kSkin_Color forState:UIControlStateNormal];
    button0.layer.cornerRadius = 3;
    button0.layer.masksToBounds = YES;
//    button0.layer.borderColor = kSkin_Color.CGColor;
    [button0 setBackgroundImage:[UIImage createImageWithColor:ColorOfHex(0xffffff)] forState:UIControlStateNormal];
//    button0.layer.borderWidth = 0.5;
    [button0 addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button0];
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_imageView.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(35);
    }];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"Color", nil), @"Logo", nil];
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * (kScreenSize.width / 2), kScreenSize.height - kTabbarSafeAeraHeight - 50, kScreenSize.width / 2, 35);
        button.tag = i;
        [button setTitleShadowColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
        button.titleLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(styleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)styleClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        _selectType = 0;
    }else{
        _selectType = 1;
    }
    
    actionSheetView = [[SYActionSheetView alloc] init];
    actionSheetView.delegate = self;
    //    actionSheetView.leftMargin = 15;
    //    actionSheetView.rightMargin = 15;
    //    actionSheetView.cornerRadius = 4;
    [actionSheetView show];
}

- (void)save
{
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [ProgressHUD show:NSLocalizedString(@"Save Success", nil)];
}

- (void)diy
{
    [actionSheetView dismiss];
    [self headImageClick];
}

- (void)clean
{
    _image = nil;
    [self r:red g:green b:blue];
}

- (void)logoClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self diy];
    }else{
        _image = [UIImage imageNamed:[[ColorManager logoArray] objectAtIndex:sender.tag]];
        [self r:red g:green b:blue];
    }
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


#pragma mark - SYActionSheetViewDelegate
- (NSInteger)numberOfRowsInActionSheetView:(SYActionSheetView *)actionSheetView
{
    return 1;
}

- (CGFloat)actionSheetView:(SYActionSheetView *)actionSheetView heightforRowIndex:(NSInteger)index
{
    if (_selectType == 0) {
        return 150;
    }
    
    return 150;
}

- (CGFloat)actionSheetViewHeightForFooter:(SYActionSheetView *)actionSheetView
{
    return 40;
}

- (UIView *)actionSheetViewViewForFooter:(SYActionSheetView *)actionSheetView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, PX_1)];
    lineview.backgroundColor = ColorOfHex(0xe0e0e0);
    [view addSubview:lineview];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = ColorOfHex(0xffffff);
    button.userInteractionEnabled = NO;
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
    button.frame = CGRectMake(0, PX_1, kScreenSize.width, 45);
    button.titleLabel.font = [UIFont systemFontOfSize:19];
    [view addSubview:button];
    
    return view;
}

- (UIView *)actionSheetView:(SYActionSheetView *)actionSheetView viewforRowIndex:(NSInteger)index
{
    if (_selectType == 0) {
        UIView *view = [[UIView alloc] init];
        UIScrollView *scrollview = [[UIScrollView alloc] init];
        scrollview.showsVerticalScrollIndicator = NO;
        [view addSubview:scrollview];
        
        CGFloat width = 30;
        CGFloat height = 30;
        NSInteger count = [ColorManager colorArray].count;
        
        NSInteger rowCount = 5;
        CGFloat left = 10;
        CGFloat space = (kScreenSize.width - 20 - rowCount * 30) / (rowCount - 1);
        CGFloat totleHeight = 0;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor colorWithHexString:[[ColorManager colorArray] objectAtIndex:i]]];
            button.frame = CGRectMake(left + i % rowCount * (width + space), 10 + i / rowCount * width + i / rowCount * 20, width, height);
            [scrollview addSubview:button];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = width / 2.0;
            button.tag = i;
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            
            totleHeight = CGRectGetMaxY(button.frame);
        }
        
        scrollview.frame = CGRectMake(0, 0, kScreenSize.width, 150);
        scrollview.contentSize = CGSizeMake(kScreenSize.width, totleHeight + 10);
        return view;
    }else{
        UIView *view = [[UIView alloc] init];
        UIScrollView *scrollview = [[UIScrollView alloc] init];
        scrollview.showsVerticalScrollIndicator = NO;
        [view addSubview:scrollview];
        
        CGFloat width = 40;
        CGFloat height = 40;
        NSInteger count = [ColorManager logoArray].count;
        
        NSInteger rowCount = 5;
        CGFloat left = 10;
        CGFloat space = (kScreenSize.width - 20 - rowCount * width) / (rowCount - 1);
        CGFloat totleHeight = 0;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:[[ColorManager logoArray] objectAtIndex:i]] forState:UIControlStateNormal];
            button.frame = CGRectMake(left + i % rowCount * (width + space), 10 + i / rowCount * width + i / rowCount * 20, width, height);
            [scrollview addSubview:button];
            button.tag = i;
            [button addTarget:self action:@selector(logoClick:) forControlEvents:UIControlEventTouchUpInside];
            
            totleHeight = CGRectGetMaxY(button.frame);
        }
        
        scrollview.frame = CGRectMake(0, 0, kScreenSize.width, 150);
        scrollview.contentSize = CGSizeMake(kScreenSize.width, totleHeight + 10);
        return view;
    }
    
    return nil;
}

- (void)actionSheetView:(SYActionSheetView *)actionSheetView didClickViewAtIndex:(NSInteger)index
{
    [actionSheetView dismiss];
}
@end
