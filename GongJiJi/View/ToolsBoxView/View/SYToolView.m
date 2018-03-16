//
//  JZToolView.m
//  Jiazheng
//
//  Created by zhangzhigang on 16/2/25.
//  Copyright © 2016年 58. All rights reserved.
//  modify  by   yangshaohua

#import "SYToolView.h"
@interface SYToolView ()


//@property(nonatomic, strong)UIView      *redDot;

@end

@implementation SYToolView

- (instancetype)initWithTool:(SYToolModel *)toolModel
{
    if (self = [super init]) {
        
        self.toolModel = toolModel;
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.button];
        
        WS(weakSelf)
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(weakSelf);
            make.center.equalTo(weakSelf);
        }];
        
        [self.button addSubview:self.imageView];
        
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:toolModel.iconUrl] placeholderImage:nil];
        
        self.imageView.image = [UIImage imageNamed:toolModel.iconUrl];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@12);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(weakSelf.button);
        }];
        
        [self.button addSubview:self.titleLabel];
        self.titleLabel.text = toolModel.title;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(@(7 + 30 + 7));
            make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(5);
            make.centerY.equalTo(weakSelf.button);
            make.height.mas_equalTo(@15);
            make.width.mas_equalTo(@100);
        }];
        
    }
    
    return self;
}

#pragma mark - Getter & Setter
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        
//        [_button setBackgroundImage:[UIImage imageFromColor:[UIColor colorOfHex:0xFFFFFF]] forState:UIControlStateNormal];
//        [_button setBackgroundImage:[UIImage imageFromColor:ColorOfHex(0xF5F7FA)] forState:UIControlStateSelected];
//        [_button setBackgroundImage:[UIImage imageFromColor:ColorOfHex(0xF5F7FA)] forState:UIControlStateHighlighted];
    }
    
    return _button;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = ColorOfHex(0x292D33);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _titleLabel;
}

- (void)buttonClicked
{
    [self toolboxItemClick];
}

- (void)toolboxItemClick
{
   
}

#pragma mark - Private Method

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
