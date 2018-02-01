//
//  YSHTextView.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/25.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "YSHTextView.h"
@interface YSHTextView ()
{
    UILabel *_label;
}
@end
@implementation YSHTextView

- (instancetype)init
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:UITextViewTextDidChangeNotification object:nil];
        
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
        _label.textColor = ColorOfHex(0x999999);
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(4);
            make.right.bottom.mas_equalTo(-4);
        }];
    }
    return self;
}

- (void)setPlaceHodler:(NSString *)placeHodler
{
    _label.text = placeHodler;
}

- (void)change:(NSNotification *)notification
{
    UITextView *view = notification.object;
    if (view == self) {
        if (view.text.length > 0) {
            _label.hidden = YES;
        }else{
            _label.hidden = NO;
        }
    }
}
@end
