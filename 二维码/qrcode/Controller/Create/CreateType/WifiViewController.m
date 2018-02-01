//
//  WifiViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/25.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "WifiViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface WifiViewController ()
{
    NSMutableArray *_array;
    UIScrollView *_scrollView;
}
@end

@implementation WifiViewController

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
    
    _array = [[NSMutableArray alloc] init];
    BaseModel *model = [[BaseModel alloc] init];
    model.key = @"Wifi名称";
    model.view = [[UITextField alloc] init];
    ((UITextField *)model.view).text = [self SSID];
    [_array addObject:model];
    
    BaseModel *model1 = [[BaseModel alloc] init];
    model1.key = @"Wifi密码";
    model1.view = [[UITextField alloc] init];
    [_array addObject:model1];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    [self.contentView addSubview:_scrollView];
    
    
    CGFloat top = 0;
    for (NSInteger i = 0; i < _array.count; i++) {
        BaseModel *model = [_array objectAtIndex:i];
        
        CGFloat height = 44;
        if ([model.view isKindOfClass:[UITextView class]]) {
            height = 80;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, top, kScreenSize.width, height)];
        
        [_scrollView addSubview:view];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.text = model.key;;
        lable.textColor =  ColorOfHex(0x333333);
        lable.font = [UIFont systemFontOfSize:14];
        [view addSubview:lable];
        
        CGSize size = [lable sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            if ([model.view isKindOfClass:[UITextField class]]) {
                make.centerY.mas_equalTo(view);
            }else{
                make.top.mas_equalTo(10);
            }
            make.width.mas_equalTo(size.width);
        }];
        
        UITextField *temp = (UITextField *)model.view;
        temp.textColor = ColorOfHex(0x333333);
        temp.font = [UIFont systemFontOfSize:14];
        [view addSubview:temp];
        temp.layer.cornerRadius = 2;
        temp.layer.masksToBounds = YES;
        temp.layer.borderColor = ColorOfHex(0xe0e0e0).CGColor;
        temp.layer.borderWidth = 0.5;
        [temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lable.mas_right).mas_offset(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
        }];
        
        top = CGRectGetMaxY(view.frame);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = ColorOfHex(0xe0e0e0);
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(view);
            make.height.mas_equalTo(PX_1);
        }];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, top + 10, 60, 30)];
    label.text = NSLocalizedString(@"Encryption Type", nil);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = ColorOfHex(0x333333);
    [_scrollView addSubview:label];
    
    NSArray *array = [NSArray arrayWithObjects:@"WAP/WAP2", @"WEP", NSLocalizedString(@"NO Encryption", nil), nil];
    CGFloat width = (kScreenSize.width - 20 - 40) / 3;
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + i * width + i * 20, CGRectGetMaxY(label.frame) + 10, width, 30);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 1;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.masksToBounds = YES;
        [button setTitleColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:ColorOfHex(0xffffff) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage createImageWithColor:ColorOfHex(0xffffff)] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage createImageWithColor:ColorOfHex(0xd0d0d0)] forState:UIControlStateSelected];
        button.tag = 100 + i;
        [_scrollView addSubview:button];
        
        if (i == 0) {
            button.selected = YES;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(kScreenSize.width, top + 40 + 10 + 40);
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(top + 40 + 10 + 40);
    }];
    
}

- (void)click:(UIButton *)sender
{
    for (UIButton *button in _scrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = NO;
        }
    }
    sender.selected = YES;
}

//WIFI:S:12;P:3333www3333www3333www3333www3333www;T:WPA/WPA2;H:1;
- (NSString *)getContent
{
    NSString *type = @"";
    NSInteger index = 0;
    for (UIButton *button in _scrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.selected) {
                index = button.tag - 100;
                type = button.titleLabel.text;
                break;
            }
        }
    }
    
    NSString *content = @"WIFI:S:";
    content = [content stringByAppendingString:[self getKeyWithIndex:0]];
    content = [content stringByAppendingString:@";P:"];
    content = [content stringByAppendingString:[self getKeyWithIndex:0]];
    content = [content stringByAppendingString:@";T:"];
    content = [content stringByAppendingString:type];
    content = [content stringByAppendingString:@";H:1;"];
    return content;
}

- (NSString *)getKeyWithIndex:(NSInteger)index
{
    BaseModel *model = [_array objectAtIndex:index];
    return ((UITextField *)model.view).text;
}

- (NSString*)SSID
{
    
    NSArray* ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    
    for (NSString* ifnam in ifs)
        
    {
        
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count])
            
            break;
        
    }
    
    return info[@"SSID"];
}

@end
