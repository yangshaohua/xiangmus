//
//  SYTopNaviBarView.m
//  SuYun
//
//  Created by iBlock on 15/7/26.
//  Copyright (c) 2015年 58. All rights reserved.
//

#import "SYTopNaviBarView.h"

@implementation SYTopNaviBarView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenBoundWidth, kNavigationHeight)];
    if ( self ) {
        
        self.backgroundColor = kSkin_Color;
        
        //标题
        _titleLabel = [[UILabel alloc] init] ;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18] ;
        _titleLabel.textColor = ColorOfHex(0xffffff);
        _titleLabel.frame = CGRectMake(0, self.frame.size.height - 44, kScreenBoundWidth, 44);
        _titleLabel.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:_titleLabel ] ;
        
        _titleView = [[UIView alloc] initWithFrame:CGRectZero ];
        [self addSubview:_titleView];
        
        //画线
//        CGFloat lineY = kNavigationHeight - 0.5;
//        UIView *line = [[UIView alloc ] initWithFrame:CGRectMake(0, lineY, kScreenBoundWidth, 0.5)];
//        line.backgroundColor = ColorOfHex(0xe0e0e0) ;
//        [self addSubview:line];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didchang) name:UIDeviceOrientationDidChangeNotification object:nil];
    return self;
}

- (void)didchang
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(self.superview);
        make.height.mas_equalTo(kNavigationHeight);
    }];

    if (_titleView.superview) {
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }

    if (_titleLabel.superview) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_titleView);
            make.height.mas_equalTo(kNavigationHeight - kStateBarHeight);
        }];
    }
}

-(void) setTitleView:(UIView *)titleView{
    
    self.titleLabel.hidden = YES ;
    
    [_titleView removeFromSuperview ];
    _titleView = titleView ;
    _titleView.hidden = NO ;
    
    _titleView.center = CGPointMake(kScreenBoundWidth / 2 , 20 + 44/2 ) ;
    [self addSubview:_titleView ];
}

-(void) setTitle:(NSString *) title{
    self.titleLabel.hidden = NO ;
    _titleView.hidden = YES ;
    
    self.titleLabel.text = title ;
    
}

@end
