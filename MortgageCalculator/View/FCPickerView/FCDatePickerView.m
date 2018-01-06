//
//  FCDatePickerView.m
//  MortgageCalculator
//
//  Created by yanli on 2017/12/16.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "FCDatePickerView.h"

@implementation FCDatePickerView
- (instancetype)initWithDelegate:(id)delegate selectList:(NSMutableArray *)selectList currentSelectedModel:(ValueModel *)model
{
    if (self = [super init]) {
        self.backgroundColor = ColorOfHex(0xffffff);
        self.delegate = delegate;
        self.currentSelectmodel = model;
        self.selectList = selectList;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelButton setTitleColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
    self.cancelButton.frame = CGRectMake(0, 0, 60, kFCPickerTopViewHeight);
    [self addSubview:self.cancelButton];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton setTitleColor:ColorOfHex(0x333333) forState:UIControlStateNormal];
    self.sureButton.frame = CGRectMake(kScreenSize.width - 60, 0, 60, kFCPickerTopViewHeight);
    [self addSubview:self.sureButton];
    
    self.pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kFCPickerTopViewHeight, kScreenSize.width, kFCPickerPickerViewHeight)];
    self.pickerView.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.pickerView.locale = locale;
    
    
//    //当前时间创建NSDate
//    NSDate *localDate = [NSDate date];
//    //在当前时间加上的时间：格里高利历
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
//    //设置时间
//    [offsetComponents setYear:0];
//    [offsetComponents setMonth:0];
//    [offsetComponents setDay:5];
//    [offsetComponents setHour:20];
//    [offsetComponents setMinute:0];
//    [offsetComponents setSecond:0];
//    //设置最大值时间
//    NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:localDate options:0];
//    //设置属性
//    self.pickerView.minimumDate = localDate;
//    self.pickerView.maximumDate = maxDate;
    
    [self addSubview:self.pickerView];
    
    NSDate *date = [NSDate dateWithString:self.currentSelectmodel.value];
    self.pickerView.date = date;
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    shadowView.tag = 999;
    shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    [window addSubview:shadowView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [shadowView addGestureRecognizer:tap];
    
    
    self.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, kFCPickerViewHeight);
    shadowView.alpha = 0;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenSize.height - kFCPickerViewHeight - kTabbarSafeAeraHeight, kScreenSize.width, kFCPickerViewHeight);
        shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    UIView *view = [[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, kFCPickerViewHeight);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [view removeFromSuperview];
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender == self.sureButton) {
        NSString *string = [NSDate stringWithDate:self.pickerView.date];
        ValueModel *model = [[ValueModel alloc] init];
        model.key = string;
        model.value = string;
        if ([self.delegate respondsToSelector:@selector(didFCPickerViewSelectDidChangedWithModel:)]) {
            [self.delegate didFCPickerViewSelectDidChangedWithModel:model];
        }
    }
    [self dismiss];
}
@end
