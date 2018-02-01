//
//  TextViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/24.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()
{
    YSHTextView *_textView;
}
@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)createContentView
{
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    
    _textView = [[YSHTextView alloc] init];
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 3;
    _textView.layer.borderWidth = 0.5;
    _textView.placeHodler = NSLocalizedString(@"Please enter content", nil);
    _textView.layer.borderColor = kSkin_Color.CGColor;
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(150);
    }];
}

- (NSString *)getContent
{
    return _textView.text;
}
@end
