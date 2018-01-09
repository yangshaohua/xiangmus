//
//  SYTabbedView.h
//  SYTabbedViewExample
//
//  Created by evlain_yang on 15/9/28.
//  Copyright (c) 2015年 evlain_yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTabbedHeaderView.h"

@class SYTabbedView;


@protocol SYTabbedViewDelegate <NSObject>

@required
/**
 *  设置选择头部视图单元格宽度
 */
-(CGFloat)tabbedView:(SYTabbedView *)tabbedView widthForItemAtIndex:(NSUInteger)index;

@optional

/**
 *  设置选择头部视图占的半分比，剩余的为内容视图高度
 */
-(CGFloat)percentHeightOfHeaderInTabbedView;

/**
 *  设置选择头部视图高度，剩余的为内容视图高度，该方法和percentHeightOfHeaderInTabbedView只可以使用一个。如果两个同时设置，以直接设置高度为准。
 */
-(CGFloat)heightOfHeaderInTabbedView;

/**
 *  设置选择头部视图单元格字体颜色
 */
-(UIColor *)colorOfTabbedViewItem:(SYTabbedView *)tabbedView;

/**
 *  设置选择头部视图单元格字体选中颜色
 */
-(UIColor *)colorOfTabbedViewSelectedItem:(SYTabbedView *)tabbedView;

/**
 *  设置选择头部视图背景颜色
 */
-(UIColor *)tabbedHeaderBackgroundColorOfTabbedView:(SYTabbedView *)tabbedView;

/**
 *  设置滚动视图背景颜色(在内容视图大小不等于滚动视图大小时有效)
 */
-(UIColor *)backgroundColorOfTabbedView:(SYTabbedView *)tabbedView;

/**
 *  设置选择头部视图单元格字体
 */
-(UIFont *)fontOfTabbedViewItem:(SYTabbedView *)tabbedView;

/**
 *  设置选择头部视图选择线颜色
 */
-(UIColor *)colorOfSelectedLine:(SYTabbedView *)tabbedView;

/**
 *  设置头部底部线条颜色
 */
-(UIColor *)colorOfHeaderBottomLine:(SYTabbedView *)tabbedView;

/**
 *  设置选择线动画
 *
 */
-(SYSelectedAniamedType)animatedTypeOfSelectedLine:(SYTabbedView *)tabbedView;

/**
 *  切换视图回调
 *
 */
-(void)tabbedView:(SYTabbedView *)tabbedView didChangeViewAtIndex:(NSUInteger)index;

@end

@protocol SYTabbedViewDataSource <NSObject>

@required

/*
 *  获取对应下标的详细视图，该视图对应的是同一下标的选择头部单元视图
 */
-(UIView *)tabbedView:(SYTabbedView *)tabbedView viewForIndex:(NSUInteger)index;

/*
 *  获取选择头部视图单元视图标题
 */
-(NSArray *)titleOfTabbedItem;

/*
 *  获取选择头部视图单元格的数目和详细视图的数目，两者的数量应该一致
 */
-(NSUInteger)numberOfViewsInTabbedView;

@end

/*
 *  选择视图类，包含了选择头部视图和内容视图两部分，实现了选择头部的代理和数据源
 *  主要结构为头部视图和详细视图，均为本对象成员变量。
 */
@interface SYTabbedView : UIView<SYTabbedHeaderViewDelegate,SYTabbedTitleViewDataSource,UIScrollViewDelegate>

@property (nonatomic, assign, readonly) NSUInteger currentIndex;

@property (nonatomic , weak)id<SYTabbedViewDelegate>delegate;
@property (nonatomic , weak)id<SYTabbedViewDataSource>dataSource;

- (void)isBounce:(BOOL)bounce;
- (CGFloat)getHeaderHeight;
- (void)showContentViewAtIndex:(NSUInteger)index isShow:(BOOL)show;
/**
 *  设置显示的元素
 *
 *  @param index default is 0
 */
- (void)showContentViewAtIndex:(NSUInteger)index;

@end
