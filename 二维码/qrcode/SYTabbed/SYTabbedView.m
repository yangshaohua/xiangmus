//
//  SYTabbedView.m
//  SYTabbedViewExample
//
//  Created by evlain_yang on 15/9/28.
//  Copyright (c) 2015年 evlain_yang. All rights reserved.
//

#import "SYTabbedView.h"
#import "SYTabbedHeaderItem.h"
#import "SYTabbedScrollView.h"

//默认选择头部视图占高度比例
#define DEFAULT_TITLE_HEIGHT_RATE 1.0/8

@interface SYTabbedView()
{
    NSMutableArray *_tabbedTableViews;
    NSMutableArray *_tabbedItems;
    NSArray *_tabbedItemTitleStrings;
    NSMutableArray *_tabbedItemWidth;
    
    SYTabbedHeaderView *_headerView;
    SYTabbedScrollView *_scrollView;
    
    NSUInteger _tableViewsCount;

    UIColor *_headerViewItemColor;
    UIColor *_headerViewItemSelectedColor;
    UIColor *_headerViewBackgroundColor;
    UIColor *_headerViewLineSelectedColor;
    UIColor *_headerViewLineBottomColor;
    UIFont *_headerViewItemFont;

    SYSelectedAniamedType _animatedType;
    
    CGFloat _headerHeight;
}
@end

@implementation SYTabbedView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _headerView = [[SYTabbedHeaderView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height * DEFAULT_TITLE_HEIGHT_RATE)];
        _scrollView = [[SYTabbedScrollView alloc] initWithFrame:CGRectMake(0,_headerView.frame.size.height, frame.size.width, frame.size.height * (1 - DEFAULT_TITLE_HEIGHT_RATE))];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;

        [self addSubview:_headerView];
        [self addSubview:_scrollView];

        _delegate = nil;
        _dataSource = nil;
        
        _currentIndex = 0;
        _tableViewsCount = 0;
    }
    return self;
}

/*
 *  delegate setter方法，用于处理所有的代理方法回调。
 *  optional方法需要验证代理对象是否实现。required方法直接调用。
 *  和dataSource共同决定才能回调的方法，需要判断是否设置了代理，这点在dataSource setter中相同。
 */
-(void)setDelegate:(id<SYTabbedViewDelegate>)delegate
{
    _delegate = delegate;
    
    if([_delegate respondsToSelector:@selector(heightOfHeaderInTabbedView)])
    {
        [self resizeFrameUsingheight];
    }
    else if([_delegate respondsToSelector:@selector(percentHeightOfHeaderInTabbedView)])
    {
        [self resizeFrameUsingPercent];
    }
    if([_delegate respondsToSelector:@selector(colorOfTabbedViewItem:)])
    {
        _headerViewItemColor = [_delegate colorOfTabbedViewItem:self];
    }
    if([_delegate respondsToSelector:@selector(colorOfTabbedViewSelectedItem:)])
    {
        _headerViewItemSelectedColor = [_delegate colorOfTabbedViewSelectedItem:self];
    }
    if([_delegate respondsToSelector:@selector(tabbedHeaderBackgroundColorOfTabbedView:)])
    {
        _headerViewBackgroundColor = [_delegate tabbedHeaderBackgroundColorOfTabbedView:self];
    }
    if([_delegate respondsToSelector:@selector(fontOfTabbedViewItem:)])
    {
        _headerViewItemFont  = [_delegate fontOfTabbedViewItem:self];
    }
    if([_delegate respondsToSelector:@selector(colorOfSelectedLine:)])
    {
        _headerViewLineSelectedColor = [_delegate colorOfSelectedLine:self];
    }
    if ([_delegate respondsToSelector:@selector(colorOfHeaderBottomLine:)])
    {
        _headerViewLineBottomColor = [_delegate colorOfHeaderBottomLine:self];
    }
    if([_delegate respondsToSelector:@selector(animatedTypeOfSelectedLine:)])
    {
        _animatedType = [_delegate animatedTypeOfSelectedLine:self];
    }
    if([_delegate respondsToSelector:@selector(backgroundColorOfTabbedView:)])
    {
        _scrollView.backgroundColor = [_delegate backgroundColorOfTabbedView:self];
    }
    if(_dataSource)
    {
        [self initTabbedItemWidth];
        [self addTitleViewDelegateAndDataSource];
    }
}

/*
 *  dataSource setter方法，用于处理所有的代理方法回调
 *  optional方法需要验证代理对象是否实现。required方法直接调用。
 *  和delegate共同决定才能回调的方法，需要判断是否设置了代理，这点在delegate setter中相同
 */
-(void)setDataSource:(id<SYTabbedViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _tableViewsCount = [_dataSource numberOfViewsInTabbedView];
    [self setScrollViewContentSize];
    [self initTabbedTableViews];
    _tabbedItemTitleStrings = [_dataSource titleOfTabbedItem];
    
    if(_delegate)
    {
        [self initTabbedItemWidth];
        [self addTitleViewDelegateAndDataSource];
    }
}

/*
 *  获取所有内容视图，并根据index设置位置，方法需同时设置delegate和dataSource才能回调
 */
-(void)initTabbedTableViews
{
    _tabbedTableViews = [[NSMutableArray alloc] initWithCapacity:_tableViewsCount];
    for(int i = 0 ; i < _tableViewsCount ; i++)
    {
        UIView *view = [_dataSource tabbedView:self viewForIndex:i];
        view.frame = CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_tabbedTableViews addObject:view];
        [_scrollView addSubview:view];
    }
}

/*
 *  获取详细内容视图个数后重新设置scrollView的contentSize
 */
-(void)setScrollViewContentSize;
{
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * _tableViewsCount, _scrollView.frame.size.height)];
}

/*
 *  获取每个头部视图单元格宽度
 */
-(void)initTabbedItemWidth
{
    _tabbedItemWidth = [[NSMutableArray alloc] initWithCapacity:_tableViewsCount];
    _tabbedItems = [[NSMutableArray alloc] initWithCapacity:_tableViewsCount];
    for(int i = 0; i < _tableViewsCount ; i++)
    {
        [_tabbedItemWidth addObject:[NSNumber numberWithFloat:[_delegate tabbedView:self widthForItemAtIndex:i]]];
    }
}

/*
 *  根据头部视图高度重新设置头部视图和详细内容视图frame
 */
-(void)resizeFrameUsingheight
{
    CGFloat height = [_delegate heightOfHeaderInTabbedView];
    if(height <= 30.0)
    {
        return;
//        _headerHeight = 30.0;
    }
    else
    {
        [_headerView resetHeaderViewFrame:CGRectMake(0, 0, self.frame.size.width, height)];
        _scrollView.frame = CGRectMake(0, _headerView.frame.size.height, self.frame.size.width, self.frame.size.height - height);
        _headerHeight = height;
    }
}
/*
 *  根据头部视图百分比重新设置头部视图和详细内容视图的frame
 */
-(void)resizeFrameUsingPercent
{
    CGFloat percent = [_delegate percentHeightOfHeaderInTabbedView];
    if(percent >= 1.0 || percent <= 0.0)
    {
        return;
//        _headerHeight = 0;
    }
    else
    {
        [_headerView resetHeaderViewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * percent)];
        _scrollView.frame = CGRectMake(0, _headerView.frame.size.height, self.frame.size.width, self.frame.size.height * (1 - percent));
        _headerHeight = _scrollView.frame.size.height;
    }
}

/*
 *  设置头部视图的代理和数据源，执行头部视图的代理和数据源回调，需在处理完成本类的所有代理和数据回调后执行
 */
-(void)addTitleViewDelegateAndDataSource
{
    _headerView.delegate = self;
    _headerView.dataSource = self;
}

#pragma public methods
- (void)isBounce:(BOOL)bounce
{
    _scrollView.bounces = bounce;
}

- (void)showContentViewAtIndex:(NSUInteger)index isShow:(BOOL)show
{
    UITableView *view = [_tabbedTableViews objectAtIndex:index];
    if(show)
    {
        view.hidden = NO;
    }
    else
    {
        view.hidden = YES;
    }
}

- (void)showContentViewAtIndex:(NSUInteger)index {
    
    if (index > _tabbedTableViews.count) {
        NSLog(@"\n SYTabbedView showContentViewAtIndex Error: index超过元素个数!!! \n");
        return;
    }
    
    [_headerView setSelectedIndex:index];
}

- (CGFloat)getHeaderHeight
{
    return _headerHeight;
}

#pragma mark EYTabbedHeaderViewDelegate

-(CGFloat)tabbedHeaderView:(SYTabbedHeaderView *)headerView widthForItemAtIndex:(NSUInteger)index
{
    return [[_tabbedItemWidth objectAtIndex:index] floatValue];
}

-(void)tabbedHeaderView:(SYTabbedHeaderView *)headerView didSelectItemAtIndex:(NSUInteger)index
{
    _currentIndex = index;
    
    CGPoint movePoint = CGPointMake(_scrollView.frame.origin.x + _scrollView.frame.size.width * index, 0);
    [_scrollView setContentOffset:movePoint animated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbedView:didChangeViewAtIndex:)]) {
        [self.delegate tabbedView:self didChangeViewAtIndex:index];
    }
}

-(UIColor *)colorOfTabbedHeaderViewItem:(SYTabbedHeaderView *)headerView
{
    return _headerViewItemColor;
}

-(UIColor *)colorOfTabbedHeaderViewSelectedItem:(SYTabbedHeaderView *)headerView
{
    return _headerViewItemSelectedColor;
}

-(UIColor *)backgroundColorOfTabbedHeaderView:(SYTabbedHeaderView *)headerView
{
    return _headerViewBackgroundColor;
}

-(UIFont *)fontOfTabbedHeaderViewItem:(SYTabbedHeaderView *)headerView
{
    return _headerViewItemFont;
}

-(UIColor *)colorOfSelectedLine:(SYTabbedHeaderView *)headerView
{
    return _headerViewLineSelectedColor;
}

-(UIColor *)colorOfHeaderBottomLine:(SYTabbedHeaderView *)headerView
{
    return _headerViewLineBottomColor;
}

-(SYSelectedAniamedType)animatedTypeOfSelectedLine:(SYTabbedHeaderView *)headerView
{
    return _animatedType;
}

#pragma mark EYTabbedHeaderViewDataSource

-(SYTabbedHeaderItem *)tabbedHeaderView:(SYTabbedHeaderView *)headerView itemAtIndex:(NSUInteger)index
{
    SYTabbedHeaderItem *item = [[SYTabbedHeaderItem alloc] init];
    [item setTitle:[_tabbedItemTitleStrings objectAtIndex:index]];
    [_tabbedItems addObject:item];
    return item;
}

-(NSUInteger)numberOfItemForTabbedHeaderView:(SYTabbedHeaderView *)headerView
{
    return _tableViewsCount;
}

#pragma mark UIScrollViewDelegate
/*
 *  根据scrollView的contentOffset来判断滚动到了哪一个视图，从而改变头部视图的选中状态
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat positionX = scrollView.contentOffset.x;
    NSUInteger index = positionX / self.frame.size.width;
    if (index != self.currentIndex) {
        [_headerView setSelectedItem:[_tabbedItems objectAtIndex:index]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView setSelectedLineOffsetX:scrollView.contentOffset.x];
}

@end
