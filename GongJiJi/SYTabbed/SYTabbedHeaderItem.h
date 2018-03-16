//
//  SYTabbedHeaderItem.h
//  SYTabbedViewExample
//
//  Created by evlain_yang on 15/9/28.
//  Copyright (c) 2015年 evlain_yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTabbedHeaderView.h"
@interface SYTabbedHeaderItem : UIView

@property(nonatomic, weak, readonly)SYTabbedHeaderView *headerView;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, strong)UIColor *titleColor;
@property(nonatomic, strong)UIColor *selectedTitleColor;
@property(nonatomic, assign)CGFloat position;
@property(nonatomic, strong)UIFont *font;

-(instancetype)init;
-(void)setOwnerTabbedHeaderView:(SYTabbedHeaderView *)headerView andItemPosition:(CGFloat)position;

@end
