//
//  UploadImageAlertView.m
//  CustomAlertView
//
//  Created by changpengkai on 16/8/9.
//  Copyright © 2016年 com.pengkaichang. All rights reserved.
//

#define kButtonItemHeight                  50
#define kButtonTitleFontSize               17
#define kButtonTitleFontColor              0x333333
#define kButtonCancelTitleFontColor        0x9B9B9B
#define kLineColor                         0xDFDFDF
#define KBaseButotnTag                     10000
#define kButtonContainerViewColor          0x000000


#import "UploadImageAlertView.h"

@interface UploadImageAlertView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *buttonContainerView;
@end

@implementation UploadImageAlertView

+ (id)upLoadImageAlertView {
    
    return [[UploadImageAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];;
        [self addSubview:self.backView];
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setButtonTitles:(NSArray *)buttonTitles {
    
    _buttonTitles = buttonTitles;
    
    CGFloat totalItemHeight = _buttonTitles.count * kButtonItemHeight;
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.buttonContainerView = [[UIView alloc]init];
    self.buttonContainerView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:self.buttonContainerView];
    [self.buttonContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenSize.width);
        make.left.mas_equalTo(self.backView.mas_left);
        make.height.mas_equalTo(buttonTitles.count * kButtonItemHeight);
        make.bottom.mas_equalTo(self.backView).offset(totalItemHeight);
    }];
    
    for (int i = 0; i < buttonTitles.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = KBaseButotnTag + i;
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
        [button setTitleColor:ColorOfHex(kButtonTitleFontColor) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainerView addSubview:button];
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.buttonContainerView.mas_left);
            make.top.mas_equalTo(self.buttonContainerView.mas_top).offset(i * kButtonItemHeight);
            make.width.mas_equalTo(kScreenSize.width);
            make.height.mas_equalTo(kButtonItemHeight);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = ColorOfHex(kLineColor);
        [button addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.buttonContainerView.mas_left);
            make.width.mas_equalTo(kScreenSize.width);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(button);
        }];
        
        if (i == buttonTitles.count - 1) {
            lineView.hidden = YES;
            [button setTitleColor:ColorOfHex(kButtonCancelTitleFontColor) forState:UIControlStateNormal];
        }
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}



- (void)show {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            [self.buttonContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backView);
            }];
            [self.buttonContainerView setNeedsLayout];
            [self.buttonContainerView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
        }];

    });
}

- (void)dismiss {
    
    if (![self.buttonTitles isKindOfClass:[NSArray class]]) {
        [self removeFromSuperview];
        return;
    }
    
    CGFloat totalItemHeight = self.buttonTitles.count * kButtonItemHeight;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [self.buttonContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView).mas_offset(totalItemHeight);
        }];
        [self.buttonContainerView setNeedsLayout];
        [self.buttonContainerView layoutIfNeeded];

    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismiss];
}

- (void)buttonAction:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.tag - KBaseButotnTag);
    }
    [self dismiss];
}

@end
