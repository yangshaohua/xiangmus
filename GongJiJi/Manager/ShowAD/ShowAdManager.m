//
//  ShowAdManager.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/12.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "ShowAdManager.h"
@interface ShowAdManager ()<GADInterstitialDelegate>
{
    NSInteger _showDurition;
    
    NSTimer *_timer;
    
    UIButton *_closeButton;
    
    UIView   *_screenView;
}
@end
@implementation ShowAdManager
+ (instancetype)sharedInstance
{
    static ShowAdManager *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[ShowAdManager alloc] init];
    });
    return mediator;
}

- (void)showADWithDurition:(NSInteger)durition
{
    _showDurition = durition + 1;
    [self createAndLoadInterstitial];
}

- (void)createAndLoadInterstitial
{
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:kADMob_StartUnitId];
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ kGADSimulatorID,];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:request];
    
    //获取viewController的视图
//    [[[UIApplication sharedApplication] keyWindow] addSubview:[self getScreenView]];
}

- (UIView *)getScreenView
{
    if (!_screenView) {
        //获取LaunchScreen.storyborad
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Launch Screen" bundle:nil];
        
        //通过使用storyborardID去获取启动页viewcontroller
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        _screenView = viewController.view;
    }
    return _screenView;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [_screenView removeFromSuperview];
    [self show];
}

- (void)show
{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:kRootNavigation];
        
        [self.interstitialController.view addSubview:[self closeButton]];
        [_closeButton setTitle:[NSString stringWithFormat:@"跳过%ld", (long)_showDurition] forState:UIControlStateNormal];
        
        if (_timer) {
            [_timer invalidate];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeReduce) userInfo:nil repeats:YES];
        
        
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(kScreenSize.width - 100, 30 + kTabbarSafeAeraHeight, 80, 35);
        _closeButton.backgroundColor = kSkin_Color;
        _closeButton.layer.cornerRadius = 35/2.0;
        _closeButton.tag = 100;
        _closeButton.layer.masksToBounds = YES;
        _closeButton.layer.borderColor = ColorOfHex(0xfffff).CGColor;
        _closeButton.layer.borderWidth = 1;
        [_closeButton setTitleColor:ColorOfHex(0xffffff) forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)timeReduce
{
    _showDurition--;
    
    if (_showDurition < 0) {
        [_timer invalidate];
        _timer = nil;
        [self.interstitialController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    [self.interstitialController.view bringSubviewToFront:_closeButton];
    [_closeButton setTitle:[NSString stringWithFormat:@"跳过%ld", (long)_showDurition] forState:UIControlStateNormal];
}

- (void)closeClick
{
    [self.interstitialController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UIViewController *)interstitialController
{
    UIViewController * vc = nil;
    if ([self.interstitial respondsToSelector:@selector(viewController)]) {
        vc = [self.interstitial performSelector:@selector(viewController) withObject:nil];
    }
    return vc;
}
@end
