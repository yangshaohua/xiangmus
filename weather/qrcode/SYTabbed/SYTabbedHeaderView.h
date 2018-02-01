//
//  SYTabbedHeaderViewView.h
//  SYTabbedViewExample
//
//  Created by evlain_yang on 15/9/28.
//  Copyright (c) 2015年 evlain_yang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  选择线动画
 */
typedef NS_ENUM(NSInteger, SYSelectedAniamedType)
{
    SYSelectedAniamedTypeDefault,   //默认动画
    SYSelectedAniamedTypeSpring,     //弹簧动画
    SYSelectedAniamedTypeRuntime    //
};

@class SYTabbedHeaderView;
@class SYTabbedHeaderItem;
@protocol SYTabbedHeaderViewDelegate <NSObject>

@required
/*
 *  单元格宽度
 */
-(CGFloat)tabbedHeaderView:(SYTabbedHeaderView *)headerView widthForItemAtIndex:(NSUInteger)index;

@optional

/*
 *  点击回调事件
 */
-(void)tabbedHeaderView:(SYTabbedHeaderView *)headerView didSelectItemAtIndex:(NSUInteger)index;

/*
 *  单元格标题颜色
 */
-(UIColor *)colorOfTabbedHeaderViewItem:(SYTabbedHeaderView *)headerView;

/*
 *  单元格标题选择颜色
 */
-(UIColor *)colorOfTabbedHeaderViewSelectedItem:(SYTabbedHeaderView *)headerView;

/*
 *  背景颜色
 */
-(UIColor *)backgroundColorOfTabbedHeaderView:(SYTabbedHeaderView *)headerView;

/*
 *  标题字体
 */
-(UIFont *)fontOfTabbedHeaderViewItem:(SYTabbedHeaderView *)headerView;

/**
 *  选择线颜色
 */
-(UIColor *)colorOfSelectedLine:(SYTabbedHeaderView *)headerView;

/**
 *  底部线的颜色
 */
-(UIColor *)colorOfHeaderBottomLine:(SYTabbedHeaderView *)headerView;

/**
 *  设置选择线动画
 *
 */
-(SYSelectedAniamedType)animatedTypeOfSelectedLine:(SYTabbedHeaderView *)headerView;
@end

@protocol SYTabbedTitleViewDataSource <NSObject>

@required

/*
 *  单元格实例，包含标题
 */
-(SYTabbedHeaderItem *)tabbedHeaderView:(SYTabbedHeaderView *)headerView itemAtIndex:(NSUInteger)index;

/*
 *  单元格个数
 */
-(NSUInteger)numberOfItemForTabbedHeaderView:(SYTabbedHeaderView *)headerView;

@end

@interface SYTabbedHeaderView : UIView

@property(nonatomic, weak)id<SYTabbedHeaderViewDelegate>delegate;
@property(nonatomic, weak)id<SYTabbedTitleViewDataSource>dataSource;
@property(nonatomic, readonly, assign)NSUInteger itemCount;
@property(nonatomic, readonly)UIColor *titleColor;
@property(nonatomic, readonly)UIColor *selectedTitleColor;
@property(nonatomic, readonly)UIFont *font;
@property(nonatomic, readonly)UIColor *titleViewBackgroundColor;
@property(nonatomic, readonly)UIColor *selecetViewColor;
@property(nonatomic, readonly)UIColor *bottomLineColor;

-(void)setSelectedIndex:(NSUInteger)index;
-(void)setSelectedItem:(SYTabbedHeaderItem *)item;
-(void)resetHeaderViewFrame:(CGRect)frame;
-(void)setSelectedLineOffsetX:(CGFloat)x;

@end
