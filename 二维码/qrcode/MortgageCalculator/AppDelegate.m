//
//  AppDelegate.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/7.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "AppDelegate.h"
#import "SYTabbarController.h"
#import <Bugly/Bugly.h>
#import "IQKeyboardManager.h"
#import "MLTransitionAnimation.h"
@import GoogleMobileAds;
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化 google admob
    [GADMobileAds configureWithApplicationID:kADMob_AppId];

    //bugly
    [self registerBugly];
    //键盘
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[SYTabbarController alloc] init]];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    
    [UIViewController setGestureEnabled:YES];
    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    return YES;
}

//腾讯Bugly
- (void)registerBugly {
    BuglyConfig *buglyConfig = [[BuglyConfig alloc] init];
    buglyConfig.debugMode = YES;
    buglyConfig.reportLogLevel = BuglyLogLevelWarn;
    //    buglyConfig.channel = DISTRIBUTE_CHANNEL;
    buglyConfig.blockMonitorEnable = YES;
    [Bugly startWithAppId:kBugly_AppId config:buglyConfig];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UIViewController *vc = [[kRootNavigation viewControllers] lastObject];
    [vc viewWillAppear:YES];
    [vc viewDidAppear:YES];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
