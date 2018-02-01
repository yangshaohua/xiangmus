//
//  SYActionSheetView.m
//  SuYunDriver
//
//  Created by yangshaohua on 2017/8/10.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import "SYActionSheetView.h"
@interface SYActionSheetView ()
{
    CGFloat _contentHeight;
}
@property (nonatomic, strong) UIView           *shadowView;

@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) NSMutableArray   *viewArray;

@end

@implementation SYActionSheetView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = kScreenBounds;
        self.rowHeight = 50;
        self.viewArray = [[NSMutableArray alloc] init];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    [self createShadowView];
    [self createScrollView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = self.cornerRadius;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    
    NSInteger count = [self getCount];
    CGFloat totalHeight = 0;
    for (NSInteger i = 0; i < count; i++) {
        CGFloat height = [self getHeightWithIndex:i];
        
        UIView *view = [self getViewWithIndex:i];
        view.frame = CGRectMake(0, totalHeight, kScreenSize.width - self.leftMargin - self.rightMargin, height);
        [contentView addSubview:view];
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), height);
        clickButton.tag = i;
        [clickButton addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        [view insertSubview:clickButton atIndex:0];
        totalHeight += height;
        
        [_viewArray addObject:view];
    }
    contentView.frame = CGRectMake(self.leftMargin, 0, kScreenSize.width - self.leftMargin - self.rightMargin, totalHeight);
    
    UIView *footerView = nil;
    if ([self.delegate respondsToSelector:@selector(actionSheetViewViewForFooter:)]) {
        footerView = [self.delegate actionSheetViewViewForFooter:self];
        footerView.frame = CGRectMake(0, totalHeight, CGRectGetWidth(footerView.frame), CGRectGetHeight(footerView.frame));
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(footerView.frame));
        clickButton.tag = count;
        [clickButton addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView insertSubview:clickButton atIndex:0];
    }
    
    if (footerView) {
        [self.scrollView addSubview:footerView];
    }
    CGFloat footerHeight = [self getFooterHeight];
    
    totalHeight += footerHeight;
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), totalHeight);
    if (totalHeight > CGRectGetHeight(self.frame)) {
        totalHeight = CGRectGetHeight(self.frame);
    }
    
    _contentHeight = totalHeight;
    self.scrollView.frame = CGRectMake(0, kScreenBoundHeight - totalHeight - kTabbarSafeAeraHeight, CGRectGetWidth(self.frame), totalHeight + _contentHeight);
    
}

- (void)createShadowView
{
    _shadowView = [[UIView alloc] initWithFrame:kScreenBounds];
    _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [self addSubview:_shadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_shadowView addGestureRecognizer:tap];
}

- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
}

- (void)reloadData
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_viewArray removeAllObjects];
    [self initSubviews];
}

- (UIView *)viewWithIndex:(NSInteger)index{
    if (index < [_viewArray count]) {
        return [_viewArray objectAtIndex:index];
    }
    return  nil;
}

- (NSInteger)getCount
{
    NSInteger count = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfRowsInActionSheetView:)]) {
        count = [self.delegate numberOfRowsInActionSheetView:self];
    }
    return count;
}

- (CGFloat)getHeightWithIndex:(NSInteger)index
{
    CGFloat height = self.rowHeight;
    if ([self.delegate respondsToSelector:@selector(actionSheetView:heightforRowIndex:)]) {
        height = [self.delegate actionSheetView:self heightforRowIndex:index];
    }
    return height;
}

- (CGFloat)getFooterHeight
{
    CGFloat height = 0;
    if ([self.delegate respondsToSelector:@selector(actionSheetViewHeightForFooter:)]) {
        height = [self.delegate actionSheetViewHeightForFooter:self];
    }
    return height;
}

- (UIView *)getViewWithIndex:(NSInteger)index
{
    UIView *view = nil;
    if ([self.delegate respondsToSelector:@selector(actionSheetView:viewforRowIndex:)]) {
        view = [self.delegate actionSheetView:self viewforRowIndex:index];
    }
    return view;
}


- (void)show
{
    [self reloadData];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    self.scrollView.frame = CGRectMake(0, kScreenBoundHeight, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    self.shadowView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = CGRectMake(0, kScreenBoundHeight - _contentHeight - kTabbarSafeAeraHeight, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        
        self.shadowView.alpha = 0.2;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = CGRectMake(0, kScreenBoundHeight, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - 点击
- (void)cellClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(actionSheetView:didClickViewAtIndex:)]) {
        [self.delegate actionSheetView:self didClickViewAtIndex:sender.tag];
    }
}
@end


