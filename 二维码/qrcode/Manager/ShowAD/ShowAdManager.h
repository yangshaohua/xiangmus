//
//  ShowAdManager.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/12.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;
@interface ShowAdManager : NSObject
@property(nonatomic, strong) GADInterstitial *interstitial;
+ (instancetype)sharedInstance;

- (void)showADWithDurition:(NSInteger)durition;
@end
