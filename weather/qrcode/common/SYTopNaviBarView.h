//
//  SYTopNaviBarView.h
//  SuYun
//
//  Created by iBlock on 15/7/26.
//  Copyright (c) 2015年 58. All rights reserved.
//  模仿系统导航条自定义视图

#import <UIKit/UIKit.h>

@interface SYTopNaviBarView : UIView

@property (nonatomic, strong) UILabel *titleLabel ;
@property (nonatomic, strong , setter= setTitleView:) UIView *titleView ;

-(void) setTitle:(NSString *) title ;

@end
