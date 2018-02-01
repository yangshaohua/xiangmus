//
//  JZTabViewController2.m
//  Jiazheng
//
//  Created by ices on 14-7-24.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "SYTabbarController.h"
#import "UITabBar+customBar.h"
#import "DJScanViewController.h"
//#import "TestBarViewController.h"
#import "UITabBar+badge.h"
#import "CreateViewController.h"
#import "MineViewController.h"
#import "HistoryViewController.h"
@interface SYTabbarController ()
//{
//    SYYoupeiWebVC           *_testVC;
//}
@property (strong, nonatomic) NSMutableDictionary     *redPointDic;
@end

@implementation SYTabbarController

- (id)init
{
    return [self initWithSubViews:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (id)initWithSubViews:(NSMutableArray *)subviews
{
    self = [super init];
    if (self) {
        self.tabBar.translucent = NO;
        [self.tabBar ul_setUpLineColor:ColorOfHex(0XE0E0E0)];
        self.tabBar.backgroundColor = ColorOfHex(0x999999);
     //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     //   BOOL bidIsOpen = [defaults objectForKey:@"bidIsOpen"];
        
        CreateViewController *homeViewController = [[CreateViewController alloc] init];
        [self setVCTabBarTitleWithVC:homeViewController title:NSLocalizedString(@"create", nil) normalImage:[[UIImage imageNamed:@"tab_order"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"tab_orderselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        HistoryViewController *orderViewController = [[HistoryViewController alloc] init];
        [self setVCTabBarTitleWithVC:orderViewController title:NSLocalizedString(@"History", nil) normalImage:[[UIImage imageNamed:@"history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"history_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        

        
        MineViewController *mineViewController = [[MineViewController alloc] init];
        [self setVCTabBarTitleWithVC:mineViewController title:NSLocalizedString(@"mine", nil) normalImage:[[UIImage imageNamed:@"tab_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"tab_mineselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
//        TestBarViewController *testVC = [[TestBarViewController alloc] init];
//        [self setVCTabBarTitleWithVC:testVC title:@"TEST" normalImage:[[UIImage imageNamed:@"tab_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"tab_mineselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        

        self.viewControllers = [[NSArray alloc] initWithObjects:homeViewController,orderViewController, mineViewController, nil];
       
       
        self.delegate = self ;
    }
    return self;
}

- (void)setVCTabBarTitleWithVC:(UIViewController *)VC title:(NSString *)title normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage {
    VC.tabBarItem.title = title;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              ColorOfHex(0x888888), NSForegroundColorAttributeName,
                                              [UIFont systemFontOfSize:12], NSFontAttributeName,
                                              nil] forState:UIControlStateNormal]  ;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              ColorOfHex(0xE6454A), NSForegroundColorAttributeName,
                                              [UIFont boldSystemFontOfSize:12], NSFontAttributeName,
                                              nil] forState:UIControlStateSelected]  ;
    UIOffset offset = VC.tabBarItem.titlePositionAdjustment ;
    offset.vertical -= 0;
    VC.tabBarItem.titlePositionAdjustment = offset ;
    VC.tabBarItem.image = normalImage;
    VC.tabBarItem.selectedImage = selectImage;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor] ;
    vChecker = YES ;
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated ];
    
    NSInteger index = [self getCurrentIndex];
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    [vc viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated ];
    
//    if (vChecker == YES) {
//        _checker = [[JZVersionChecker alloc ] init ] ;
//        _checker.notifyNoUpdate = NO ;
//        [ _checker  checkVersion ] ;
//        vChecker = NO;
//    }
    NSInteger index = [self getCurrentIndex];
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    [vc viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ( currentIndex != 0  ) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(void) addBandge {
    
    
    
}

//-(void) mobTabbarClick{
//    
//    int index = (int)self.selectedIndex;
//
//    switch (index ) {
//        case 0:
//            break;
//        case 1:
//            [JZMob mobEventId:kMoborderlist attributes:nil] ;
//
//            break;
//        case 2:
//            [JZMob mobEventId:kMobmember attributes:nil] ;
//
//            break;
//        case 3:
//            [JZMob mobEventId:kMobmy attributes:nil] ;
//
//            break;
// 
//        default:
//            break;
//    }
//}

#pragma mark - 页签栏
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
//    [self mobTabbarClick ];
    _lastIndex  =  currentIndex ;
    currentIndex = (int)self.selectedIndex;
    
    

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
   
    return YES;
}

-(int) getIndex:(UIViewController *) vc {
    int index = 0 ;
    for (UIViewController *iVc in self.viewControllers ) {
        if ( iVc == vc ) {
            return  index ;
        }
        index++ ;
    }
    return  index ;
}

-(void) showTabAtIndex:(NSInteger) index  animated:(BOOL) animated {
    if (index < 0 || index >= self.viewControllers.count ) {
        return;
    }
    _lastIndex = currentIndex ;
    currentIndex = index ;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setSelectedIndex:index];
    });
}

-(NSInteger)getCurrentIndex{
    return currentIndex;
}

-(NSInteger) getLastIndex{
    
    return _lastIndex ;
}


-(NSArray *) getChildrenViewControllers  {
    
    return  self.childViewControllers ;
    
}

-(NSInteger) getIndexWithViewControllerClassStr:(NSString *)classString
{
    NSInteger index = -1;
    NSArray *viewControllerArray = [self getChildrenViewControllers];
    for (NSInteger i = 0; i < viewControllerArray.count; i++) {
        UIViewController *controller = [viewControllerArray objectAtIndex:i];
        if ([controller isKindOfClass:NSClassFromString(classString)]) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - 切换也签动画的监听
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
//    vc.view.left = 0 ;
    UIViewController *lastVC = [self.viewControllers objectAtIndex:_lastIndex ];
    [lastVC.view removeFromSuperview ];
    [_blackMask removeFromSuperview ];
    
    [self.view setUserInteractionEnabled:YES ];

}

@end
