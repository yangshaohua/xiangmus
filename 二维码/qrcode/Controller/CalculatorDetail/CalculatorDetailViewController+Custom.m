//
//  CalculatorDetailViewController+Custom.m
//  MortgageCalculator
//
//  Created by yanli on 2017/12/16.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "CalculatorDetailViewController+Custom.h"

@implementation CalculatorDetailViewController (Custom)
- (void)pingFen
{
    if (arc4random() % 5 == 0) {
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
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1330266768&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    }
}
@end
