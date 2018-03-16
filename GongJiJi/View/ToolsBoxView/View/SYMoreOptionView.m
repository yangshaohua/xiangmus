//
//  JZMoreOptionView.m
//  SuYunDriver
//
//  Created by yangshaohua on 2017/8/12.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import "SYMoreOptionView.h"
#import "SYToolBoxView.h"
@interface SYMoreOptionView ()
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong)SYToolBoxView *toolBoxView;
@end

@implementation SYMoreOptionView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = kScreenBounds;
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)show
{
    SYPageModel *tempModel = self.pageModel;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [self addSubview:self.bgView];
    
    self.toolBoxView = [[SYToolBoxView alloc]initWithPage:tempModel];
    self.toolBoxView.delegate = self;
    self.toolBoxView.frame = CGRectMake(kScreenBoundWidth - kJZToolBoxViewWidth - 11, 60, kJZToolBoxViewWidth, tempModel.boxArray.count * 45 + 8);
    self.toolBoxView.layer.anchorPoint = CGPointMake(0.89, 0);
    self.toolBoxView.frame = CGRectMake(kScreenBoundWidth - kJZToolBoxViewWidth - 11, 60, kJZToolBoxViewWidth, tempModel.boxArray.count * 45 + 8);
    self.toolBoxView.layer.shadowOffset = CGSizeMake(0.5, 1);
    self.toolBoxView.layer.shadowOpacity = 0.36;
    self.toolBoxView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.toolBoxView.layer.shadowRadius = 3;
    
    [self addSubview:self.toolBoxView];
    
    self.toolBoxView.transform = CGAffineTransformMakeScale(0, 0);
    //    self.toolBoxView.alpha = 0;
    
    WS(weakSelf)
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.5;
        weakSelf.toolBoxView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.toolBoxView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
        }];
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        _bgView = [[UIButton alloc] initWithFrame:keyWindow.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        
        _bgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeToolsView)];
        [_bgView addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removeToolsView)];
        [_bgView addGestureRecognizer:pan];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDoubleTapGesture)];
        tap2.numberOfTapsRequired = 2;
        [_bgView addGestureRecognizer:tap2];
    }
    
    return _bgView;
}

#pragma mark - Private Method
- (void)removeToolsView
{
    WS(weakSelf)
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.toolBoxView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.bgView.alpha = 0;
            weakSelf.toolBoxView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(didJZMoreOptionViewClickAtIndex:)]) {
        [self.delegate didJZMoreOptionViewClickAtIndex:-1];
    }
}

- (void)removeToolsViewNoAnimation
{
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(didJZMoreOptionViewClickAtIndex:)]) {
        [self.delegate didJZMoreOptionViewClickAtIndex:-1];
    }
}

- (void)clickDoubleTapGesture {
//    
}

- (void)didJZToolBoxViewClickButtonAtIndex:(NSInteger)index
{
    [self removeToolsView];
    if ([self.delegate respondsToSelector:@selector(didJZMoreOptionViewClickAtIndex:)]) {
        [self.delegate didJZMoreOptionViewClickAtIndex:index];
    }
}
@end
