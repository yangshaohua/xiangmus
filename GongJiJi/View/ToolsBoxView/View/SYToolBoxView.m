//
//  JZToolBoxView.m
//  Jiazheng
//
//  Created by zhangzhigang on 16/2/25.
//  Copyright © 2016年 58. All rights reserved.
//  modify  by   yangshaohua

#import "SYToolBoxView.h"
#import "SYToolView.h"

@interface SYToolBoxView ()

@property(nonatomic, strong)UIImageView *tipImageView;
@property(nonatomic, strong)UIView      *bgView;

@end

@implementation SYToolBoxView
- (instancetype)initWithPage:(SYPageModel *)pageModel
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 2;
//        self.alpha = 0.9;
        
        WS(weakSelf)
        
        [self addSubview:self.tipImageView];
        [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@0);
            make.right.mas_equalTo(@-18);
            make.size.mas_equalTo(CGSizeMake(12, 8));
        }];
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(@0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kJZToolBoxViewWidth);
            make.top.mas_equalTo(weakSelf.tipImageView.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(pageModel.boxArray.count *(45.5));
        }];
        
        
        UIView *line = nil;
        for (int i = 0; i < pageModel.boxArray.count; i++) {
            
            SYToolModel *toolModel = pageModel.boxArray[i];
            
            SYToolView *toolView = [[SYToolView alloc] initWithTool:toolModel];
            [weakSelf.bgView addSubview:toolView];
            
            toolView.button.tag = i;
            [toolView.button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(@0);
                
                if (!line) {
                    make.top.mas_equalTo(weakSelf.tipImageView.mas_bottom);
                } else {
                    make.top.mas_equalTo(line.mas_bottom);
                }
                
                make.height.mas_equalTo(@45);
                make.width.mas_equalTo(kJZToolBoxViewWidth);
            }];
            
            line = [UIView new];
            line.backgroundColor = ColorOfHex(0xe8ebf0);
            [weakSelf.bgView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(@0);
                make.width.mas_equalTo(kJZToolBoxViewWidth);
                make.height.mas_equalTo(PX_1);
                make.top.mas_equalTo(toolView.mas_bottom);
            }];
        }
    }
    
    return self;
}

#pragma mark - Getter & Setter
- (UIImageView *)tipImageView
{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"order_arrow"];
        _tipImageView.image = image;
        _tipImageView.alpha = 1.0;
    }
    
    return _tipImageView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 2;
        _bgView.clipsToBounds = YES;
    }
    
    return _bgView;
}

- (void)itemClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didJZToolBoxViewClickButtonAtIndex:)]) {
        [self.delegate didJZToolBoxViewClickButtonAtIndex:sender.tag];
    }
}
@end
