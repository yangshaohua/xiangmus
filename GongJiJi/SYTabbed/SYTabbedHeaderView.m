//
//  SYTabbedHeaderViewView.m
//  SYTabbedViewExample
//
//  Created by evlain_yang on 15/9/28.
//  Copyright (c) 2015年 evlain_yang. All rights reserved.
//

#import "SYTabbedHeaderView.h"
#import "SYTabbedHeaderItem.h"

#define LINE_HEIGHT 2

@interface SYTabbedHeaderView()
{
    BOOL _isRunDelegateMethods;
    BOOL _isRunDataSourceMethods;
    BOOL _isInitLineView;
    CGFloat _nextItemPos;
    
    UIScrollView *_scrollView;
    
    UIView *_selectedLine;
    
    UIView *_bottomLine;
    
    SYSelectedAniamedType _animatedType;
}

@property(nonatomic, strong)NSMutableArray *itemsArray;
@property(nonatomic, strong)NSMutableArray *itemsWidthArray;

@end

@implementation SYTabbedHeaderView

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if(self)
    {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _titleColor = [UIColor blackColor];
        _selectedTitleColor = [UIColor orangeColor];
        _titleViewBackgroundColor = [UIColor whiteColor];
        _itemsWidthArray = [[NSMutableArray alloc] init];
        _itemsArray = [[NSMutableArray alloc] init];
        _isRunDelegateMethods = NO;
        _isRunDataSourceMethods = NO;
        _isInitLineView = YES;
        _nextItemPos = 0;
        _font = [UIFont fontWithName:@"Arial" size:13];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _selectedLine = [[UIView alloc] init];
        _selectedLine.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_selectedLine];
        
        CGFloat bottomLineWidth = [UIScreen mainScreen].bounds.size.width;
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-5, bottomLineWidth, 5)];
        
        _bottomLine.backgroundColor = ColorOfHex(0xdbdbdb);
        [self addSubview:_bottomLine];
    }
    return self;
}

-(void)setDelegate:(id<SYTabbedHeaderViewDelegate>)delegate
{
    _delegate = delegate;
    [self createTabbedTitleView];
    _isRunDelegateMethods = YES;
}

-(void)setDataSource:(id<SYTabbedTitleViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self createTabbedTitleView];
    _isRunDataSourceMethods = YES;
}

-(void)createTabbedTitleView
{
    if(_dataSource && _isRunDataSourceMethods == NO)
    {
        _itemCount = [self.dataSource numberOfItemForTabbedHeaderView:self];
    }
    if(_delegate && _isRunDelegateMethods == NO)
    {
        if([self.delegate respondsToSelector:@selector(colorOfTabbedHeaderViewItem:)])
        {
            UIColor *color = [self.delegate colorOfTabbedHeaderViewItem:self];
            if(color)
            {
                _titleColor = color;
            }
        }
        if([self.delegate respondsToSelector:@selector(colorOfTabbedHeaderViewSelectedItem:)])
        {
            UIColor *color = [self.delegate colorOfTabbedHeaderViewSelectedItem:self];
            if(color)
            {
                _selectedTitleColor = color;
            }
        }
        if([self.delegate respondsToSelector:@selector(fontOfTabbedHeaderViewItem:)])
        {
            UIFont *font = [self.delegate fontOfTabbedHeaderViewItem:self];
            if(font)
            {
                _font = font;
            }
        }
        if([self.delegate respondsToSelector:@selector(backgroundColorOfTabbedHeaderView:)])
        {
            UIColor *color = [self.delegate backgroundColorOfTabbedHeaderView:self];
            if(color)
            {
                _titleViewBackgroundColor = color;
                self.backgroundColor = _titleViewBackgroundColor;
                _scrollView.backgroundColor = _titleViewBackgroundColor;
            }
        }
        if([self.delegate respondsToSelector:@selector(colorOfSelectedLine:)])
        {
            UIColor *selectedColor = [self.delegate colorOfSelectedLine:self];
            if(selectedColor)
            {
                _selecetViewColor = selectedColor;
                [_selectedLine setBackgroundColor:_selecetViewColor];
            }
        }
        if ([self.delegate respondsToSelector:@selector(colorOfHeaderBottomLine:)])
        {
            UIColor *bottomLineColor = [self.delegate colorOfHeaderBottomLine:self];
            if (bottomLineColor)
            {
                _bottomLineColor = bottomLineColor;
                [_bottomLine setBackgroundColor:_bottomLineColor];
            }
        }
        if([self.delegate respondsToSelector:@selector(animatedTypeOfSelectedLine:)])
        {
            _animatedType = [self.delegate animatedTypeOfSelectedLine:self];
        }
    }
    if(_dataSource && _delegate && (_isRunDelegateMethods == NO || _isRunDataSourceMethods == NO))
    {
        for(int i = 0 ; i < _itemCount ;i++)
        {
            SYTabbedHeaderItem *item = [self.dataSource tabbedHeaderView:self itemAtIndex:i];
            [_scrollView addSubview:item];
            [_itemsArray addObject:item];
        }
        for(int i = 0 ; i < _itemCount ; i++)
        {
            CGFloat itemWidth =[self.delegate tabbedHeaderView:self widthForItemAtIndex:i];
            NSNumber *widthObj = [NSNumber numberWithFloat:itemWidth];
            [_itemsWidthArray addObject:widthObj];
            
            SYTabbedHeaderItem *item = [_itemsArray objectAtIndex:i];
            [item setWidth:[widthObj floatValue]];
            [item setOwnerTabbedHeaderView:self andItemPosition:_nextItemPos];
            _nextItemPos += item.frame.size.width;
        }
        [self setItemsAttributes];
        [self resizeContentSize];
        [self setSelectedItem:[_itemsArray firstObject]];
    }
}

-(void)setItemsAttributes
{
    for(SYTabbedHeaderItem *item in _itemsArray)
    {
        item.titleColor = _titleColor;
        item.selectedTitleColor = _selectedTitleColor;
        item.font = _font;
        [item setBackgroundColor:_titleViewBackgroundColor];
    }
}

-(void)resizeContentSize
{
    [_scrollView setContentSize:CGSizeMake(_nextItemPos, self.frame.size.height)];
    [_scrollView bringSubviewToFront:_selectedLine];
    [_scrollView bringSubviewToFront:_bottomLine];
}

-(void)resetHeaderViewFrame:(CGRect)frame
{
    self.frame = frame;
    _bottomLine.frame = CGRectMake(_bottomLine.frame.origin.x, frame.size.height - 0.5, frame.size.width, _bottomLine.frame.size.height);
}

-(void)setSelectedIndex:(NSUInteger)index {
    SYTabbedHeaderItem *item = [self.itemsArray objectAtIndex:index];
    [self setSelectedItem:item];
}

-(void)setSelectedItem:(SYTabbedHeaderItem *)item
{
    for(SYTabbedHeaderItem *item in _itemsArray)
    {
        [item setTitleColor:_titleColor];
    }
    NSUInteger index = [_itemsArray indexOfObject:item];
    [item setTitleColor:_selectedTitleColor];
    
    //判断单元格是否显示在屏幕上，如果不在需要移动scrollView
    BOOL isItemAtLeftScreen = _scrollView.contentOffset.x > item.frame.origin.x;
    BOOL isItemAtRightScreen = _scrollView.contentOffset.x + _scrollView.frame.size.width < item.frame.origin.x + item.frame.size.width;
    if(isItemAtLeftScreen)
    {
        [_scrollView setContentOffset:CGPointMake(item.frame.origin.x, 0) animated:YES];
    }
    else if(isItemAtRightScreen)
    {
        [_scrollView setContentOffset:CGPointMake(item.frame.origin.x + item.frame.size.width - _scrollView.frame.size.width, 0) animated:YES];
    }
    if(_isInitLineView)
    {
        _selectedLine.frame = CGRectMake([self coculateLineViewPosition:index], self.frame.size.height - LINE_HEIGHT, item.frame.size.width, LINE_HEIGHT);
        _isInitLineView = NO;
    }
    else
    {
        if(_animatedType == SYSelectedAniamedTypeSpring)
        {
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                _selectedLine.frame = CGRectMake([self coculateLineViewPosition:index], self.frame.size.height - LINE_HEIGHT, item.frame.size.width, LINE_HEIGHT);
            } completion:^(BOOL finished) {
                
            }];
        }
        else if(_animatedType == SYSelectedAniamedTypeDefault || _animatedType == SYSelectedAniamedTypeRuntime)
        {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _selectedLine.frame = CGRectMake([self coculateLineViewPosition:index], self.frame.size.height - LINE_HEIGHT, item.frame.size.width, LINE_HEIGHT);
            } completion:^(BOOL finished){
                
            }];
        }
    }
    [self.delegate tabbedHeaderView:self didSelectItemAtIndex:index];
}

-(CGFloat)coculateLineViewPosition:(NSUInteger)index
{
    CGFloat x = 0;
    for(int i = 0 ; i < index ;i++)
    {
        x += [[_itemsArray objectAtIndex:i] frame].size.width;
    }
    return x;
    
}

-(void)setSelectedLineOffsetX:(CGFloat)x
{
    if(_animatedType == SYSelectedAniamedTypeRuntime)
        _selectedLine.frame = CGRectMake(x / 2, _selectedLine.frame.origin.y, _selectedLine.frame.size.width, _selectedLine.frame.size.height);
}

@end
