//
//  BaseViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/24.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ColorOfHex(0xffffff);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
