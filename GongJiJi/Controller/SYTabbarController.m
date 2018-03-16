//
//  JZTabViewController2.m
//  Jiazheng
//
//  Created by ices on 14-7-24.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import "SYTabbarController.h"
#import "UIColor+Hex.h"
#import "UITabBar+customBar.h"
#import "GongJiJinViewController.h"
#import "SearchGongJiJinViewController.h"
#import "NewsViewController.h"
#import "MyViewController.h"

@interface SYTabbarController ()

@property (strong, nonatomic) NSMutableDictionary     *redPointDic;

@end

@implementation SYTabbarController

- (id)init
{
    return [self initWithSubViews:nil];
}

- (id)initWithSubViews:(NSMutableArray *)subviews
{
    self = [super init];
    if (self) {
        self.tabBar.translucent = NO;
        [self.tabBar ul_setUpLineColor:[UIColor colorOfHex:0XE0E0E0]];
        self.tabBar.backgroundColor = [UIColor colorOfHex:0x999999];
        
        GongJiJinViewController *homeViewController = [[GongJiJinViewController alloc] init];
        [self setVCTabBarTitleWithVC:homeViewController title:@"首页" normalImage:[[UIImage imageNamed:@"1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"1_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        SearchGongJiJinViewController *bidVC = [[SearchGongJiJinViewController alloc] init];
        [self setVCTabBarTitleWithVC:bidVC title:@"查询" normalImage:[[UIImage imageNamed:@"2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"2_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        NewsViewController *orderViewController = [[NewsViewController alloc] init];
        [self setVCTabBarTitleWithVC:orderViewController title:@"资讯" normalImage:[[UIImage imageNamed:@"3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"3_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        MyViewController *myViewController = [[MyViewController alloc] init];
        [self setVCTabBarTitleWithVC:myViewController title:@"我的" normalImage:[[UIImage imageNamed:@"4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectImage:[[UIImage imageNamed:@"4_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        

        self.viewControllers = [[NSArray alloc] initWithObjects:homeViewController,bidVC,orderViewController,myViewController, nil];
       
        self.delegate = self ;
    }
    return self;
}

- (void)setVCTabBarTitleWithVC:(UIViewController *)VC title:(NSString *)title normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage {
    VC.tabBarItem.title = title;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor colorOfHex:0x888888], NSForegroundColorAttributeName,
                                              [UIFont systemFontOfSize:12], NSFontAttributeName,
                                              nil] forState:UIControlStateNormal]  ;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor colorOfHex:0xE6454A], NSForegroundColorAttributeName,
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
    
    [self getCurrentGoingOrderId];
    
    if (@available(iOS 11.0, *)){//避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated ] ;
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

#pragma mark - 接口请求
- (void)getCurrentGoingOrderId
{
   
}

- (void)getCurrentGoingOrderIdSuccess:(NSDictionary *)dic
{
    
}

- (void)addYouPei:(NSNotification *)notification
{
   
}
-(void)addNotificationBadge:(NSNotification *)notification{
    NSInteger unReadCount = [notification.object integerValue];
    [self addRedPointWithControllerName:@"SYNoticeViewController" andUnReadCount:unReadCount];
}
-(void)addYoupeiBadge:(NSNotification *)notification{
    NSInteger unReadCount = [notification.object integerValue];
    
    [self addRedPointWithControllerName:@"SYYoupeiWebVC" andUnReadCount:unReadCount];
}

- (void)addRedPointWithControllerName:(NSString *)controllerName andUnReadCount:(NSInteger)count
{
   
}

-(void)updateTabBarFrame{
   
}
@end
