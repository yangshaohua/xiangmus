//
//  MingPianViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/24.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "MingPianViewController.h"

@interface MingPianViewController ()
{
    NSMutableArray *_array;
}
@end

@implementation MingPianViewController

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
    model.key = NSLocalizedString(@"Name", nil);
    model.view = [[UITextField alloc] init];
    [_array addObject:model];
    
    BaseModel *model1 = [[BaseModel alloc] init];
    model1.key = NSLocalizedString(@"Tel", nil);
    model1.view = [[UITextField alloc] init];
    [_array addObject:model1];
    
    BaseModel *model2 = [[BaseModel alloc] init];
    model2.key = NSLocalizedString(@"Address", nil);
    model2.view = [[UITextView alloc] init];
    [_array addObject:model2];
    
    BaseModel *model3 = [[BaseModel alloc] init];
    model3.key = NSLocalizedString(@"Email", nil);
    model3.view = [[UITextField alloc] init];
    [_array addObject:model3];
    
    BaseModel *model4 = [[BaseModel alloc] init];
    model4.key = NSLocalizedString(@"CompanyName", nil);
    model4.view = [[UITextField alloc] init];
    [_array addObject:model4];
    
    BaseModel *model5 = [[BaseModel alloc] init];
    model5.key = NSLocalizedString(@"Job", nil);
    model5.view = [[UITextField alloc] init];
    [_array addObject:model5];
    
    BaseModel *model6 = [[BaseModel alloc] init];
    model6.key = NSLocalizedString(@"HomePage", nil);
    model6.view = [[UITextField alloc] init];
    [_array addObject:model6];
   
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = YES;
    [self.contentView addSubview:scrollView];
    
    CGFloat top = 0;
    for (NSInteger i = 0; i < _array.count; i++) {
        BaseModel *model = [_array objectAtIndex:i];
        
        CGFloat height = 44;
        if ([model.view isKindOfClass:[UITextView class]]) {
            height = 80;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, top, kScreenSize.width, height)];
        
        [scrollView addSubview:view];
        
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
    
    scrollView.contentSize = CGSizeMake(kScreenSize.width, top);
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
        if (kScreenSize.height - kNavigationHeight - 44 - kTabbarHeight - 75 - kADMobHeight - top > 0) {
            make.height.mas_equalTo(top);
        }else{
            make.height.mas_equalTo(kScreenSize.height - kNavigationHeight - 44 - kTabbarHeight - 75 - kADMobHeight);
        }
    }];
}
/*
 BEGIN:VCARD
 FN:司小文
 ORG:北京XXXX有限公司
 ADR;TYPE=WORK:;;北京丰台区
 TITLE:iOS软件工程师
 TEL;WORK:1583098****
 TEL;WORK:87654321
 URL:http://blog.csdn.net/siwen1990
 EMAIL;TYPE=PREF,INTERNET:63149****@qq.com
 END:VCARD
 */
- (NSString *)getContent
{
    NSString *string = @"";
    string = [string stringByAppendingString:@"BEGIN:VCARD"];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingFormat:@"FN:%@", [self getKeyWithIndex:0]];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingFormat:@"ORG:%@", [self getKeyWithIndex:4]];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingFormat:@"ADR;TYPE=WORK:%@", [self getKeyWithIndex:2]];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingFormat:@"TITLE:%@", [self getKeyWithIndex:5]];
    string = [string stringByAppendingString:@"\n"];
    
    string = [string stringByAppendingFormat:@"TEL;WORK:%@", [self getKeyWithIndex:1]];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingFormat:@"URL:%@", [self getKeyWithIndex:6]];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingFormat:@"EMAIL;TYPE=PREF,INTERNET:%@", [self getKeyWithIndex:3]];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingString:@"END:VCARD"];
    return string;
}

- (NSString *)getKeyWithIndex:(NSInteger)index
{
     BaseModel *model = [_array objectAtIndex:index];
    return ((UITextField *)model.view).text;
}
@end
