//
//  JZTabViewController2.h
//  Jiazheng
//
//  Created by ices on 14-7-24.
//  Copyright (c) 2014年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "JZVersionChecker.h"


@protocol TabedViewController <NSObject>

-(NSString *) getTitle ;

-(UIImage *) getActiveBgImage ;

-(UIImage *) getDeactiveBgImage ;

-(void) tabController:(UIViewController *)tab willLeaveTab:(id<TabedViewController>)vc ofIndex:(int) tabIndex  ;

-(void) tabController:(UIViewController *)tab didEnterTab:(id<TabedViewController>)vc ofIndex:(int) tabIndex  ;

-(UIView *) getTitleView ;

-(UIBarButtonItem *) getRightBarbuttonItem ;

-(UIBarButtonItem *) getLeftBarbuttonItem ;

@end


@protocol JYTabContainer

-(NSInteger) getLastIndex;
-(NSInteger) getCurrentIndex;
-(void) showTabAtIndex:(NSInteger) index animated:(BOOL) animated ;

-(NSArray *) getChildrenViewControllers ;
-(NSInteger) getIndexWithViewControllerClassStr:(NSString *)classString;
@end

@interface SYTabbarController : UITabBarController < JYTabContainer ,UITabBarControllerDelegate >{
    NSInteger _lastIndex ;
    NSInteger currentIndex;
    BOOL vChecker ;
    
    UIView *_blackMask ;
}

- (id)initWithSubViews:(NSMutableArray *)subviews;

@end
