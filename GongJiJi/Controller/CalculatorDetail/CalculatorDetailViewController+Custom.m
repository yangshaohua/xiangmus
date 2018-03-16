//
//  CalculatorDetailViewController+Custom.m
//  MortgageCalculator
//
//  Created by yanli on 2017/12/16.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "CalculatorDetailViewController+Custom.h"
#import <StoreKit/StoreKit.h>
@implementation CalculatorDetailViewController (Custom)
- (void)pingFen
{
    if (arc4random() % 4 == 0) {
        //去评分
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Relatives, 5 star praise can unlock more functions oh", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"NextTime", nil) otherButtonTitles:NSLocalizedString(@"Unlock", nil), nil];
        [alertView show];
        
    }else{
        //弹广告
        [[ShowAdManager sharedInstance] showADWithDurition:3];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.3) {
//            [SKStoreReviewController requestReview];
//        }else{
            // iOS 10.3 之前的使用这个
            NSString  * nsStringToOpen = @"itms-apps://itunes.apple.com/app/id1330266768?action=write-review";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
//        }
    }
}
@end
