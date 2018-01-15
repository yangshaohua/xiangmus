//
//  MineViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "MineViewController.h"
#import "SYTopNaviBarView.h"

@interface MineViewController ()
{
    UILabel *_lable;
}
@property (strong, nonatomic) UITextView *textView;
@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notication:) name:UITextViewTextDidChangeNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"create", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront:topNavi];
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"album"] forState:UIControlStateHighlighted];
    //    [button addTarget:self action:@selector(albumClick) forControlEvents:UIControlEventTouchUpInside];
    //    [topNavi addSubview:button];
    //    [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.bottom.mas_equalTo(topNavi);
    //        make.width.height.mas_equalTo(44);
    //    }];
}

- (void)createUI
{
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = ColorOfHex(0x333333);
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 2;
    self.textView.delegate = self;
    self.textView.layer.borderColor = kSkin_Color.CGColor;
    self.textView.layer.borderWidth = 0.5;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kNavigationHeight + 15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(150);
    }];
    
    _lable = [[UILabel alloc] init];
    _lable.text = NSLocalizedString(@"Please enter content", nil);
    _lable.textColor = ColorOfHex(0x999999);
    _lable.font = [UIFont systemFontOfSize:14];
    [self.textView addSubview:_lable];
    [_lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textView).mas_offset(5);
        make.top.mas_equalTo(self.textView).mas_offset(10);
    }];
    
    CGFloat width = 70;
    CGFloat leftSpace = (kScreenSize.width - 30 - width * 2)/2.0;
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:NSLocalizedString(@"clear", nil) forState:UIControlStateNormal];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 2;
    copyButton.layer.borderColor = kSkin_Color.CGColor;
    copyButton.layer.borderWidth = 0.5;
    [copyButton setTitleColor:kSkin_Color forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [copyButton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(leftSpace);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(width);
    }];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:NSLocalizedString(@"create", nil) forState:UIControlStateNormal];
    clearButton.layer.masksToBounds = YES;
    clearButton.layer.cornerRadius = 2;
    clearButton.layer.borderColor = kSkin_Color.CGColor;
    clearButton.layer.borderWidth = 0.5;
    [clearButton setTitleColor:kSkin_Color forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearButton addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(copyButton.mas_right).mas_offset(30);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-leftSpace);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(width);
    }];
}

- (void)copyClick
{
    if (self.textView.text.length <= 0) {
        [ProgressHUD show:NSLocalizedString(@"Please enter content", nil)];
        return;
    }

}

- (void)clearClick
{
    _textView.text = @"";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
}

- (void)notication:(NSNotification *)notication
{
    if (self.textView.text.length <= 0) {
        _lable.hidden = NO;
    }else{
        _lable.hidden = YES;
    }
}

@end
