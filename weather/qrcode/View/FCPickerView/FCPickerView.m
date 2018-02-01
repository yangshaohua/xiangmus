//
//  FCPickerView.m
//  MortgageCalculator
//
//  Created by yanli on 2017/12/16.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "FCPickerView.h"

@implementation FCPickerView
- (instancetype)initWithDelegate:(id)delegate selectList:(NSMutableArray *)selectList currentSelectedModel:(ValueModel *)model withCustom:(BOOL)custom
{
    if (self = [super init]) {
        self.backgroundColor = ColorOfHex(0xffffff);
        self.delegate = delegate;
        self.currentSelectmodel = model;
        self.selectList = selectList;
        self.custom = custom;
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
    
    self.customView = [[UIView alloc] init];
    self.customView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.customView];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancelButton.mas_right).mas_offset(20);
        make.right.mas_equalTo(self.sureButton.mas_left).mas_offset(-20);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(kFCPickerTopViewHeight);
    }];
    
    self.customTextField = [[UITextField alloc] init];
    self.customTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.customTextField.placeholder = @"请输入利率";
    self.customTextField.textColor = ColorOfHex(0x333333);
    self.customTextField.font = [UIFont systemFontOfSize:14];
    [self.customTextField addTarget:self action:@selector(keyBoardDown) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.customView addSubview:self.customTextField];
    [self.customTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.customView.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.customView.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(self.customView);
        make.height.mas_equalTo(kFCPickerTopViewHeight - 5 * 2);
    }];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kFCPickerTopViewHeight, kScreenSize.width, kFCPickerPickerViewHeight)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
    NSInteger row = 0;
    for (NSInteger i = 0; i < self.selectList.count; i++) {
        ValueModel *model = self.selectList[i];
        if ([model.key isEqualToString:self.currentSelectmodel.key]) {
            row = i;
            break;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    });
}


- (void)keyBoardDown
{
    
}
#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.selectList.count;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    re
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    FCCell *cell = nil;
    if (view) {
        cell = (FCCell *)view;
    }else{
        cell = [[FCCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    }
    
    [cell updateFCCellWith:self.selectList[row]];
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
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
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    ValueModel *model = self.selectList[row];
    if (sender == self.cancelButton) {
        
    }else if (sender == self.sureButton){
        if (self.customTextField.text.length) {
            ValueModel *model1 = [[ValueModel alloc] init];
            model1.key = self.customTextField.text;
            model1.value = self.customTextField.text;
            if ([self.delegate respondsToSelector:@selector(didFCPickerViewSelectDidChangedWithModel:)]) {
                [self.delegate didFCPickerViewSelectDidChangedWithModel:model1];
            }
        }else{
            if (![self.currentSelectmodel.key isEqualToString:model.key]) {
                self.currentSelectmodel = model;
                if ([self.delegate respondsToSelector:@selector(didFCPickerViewSelectDidChangedWithModel:)]) {
                    [self.delegate didFCPickerViewSelectDidChangedWithModel:self.currentSelectmodel];
                }
            }
        }
    }
    [self dismiss];
}

@end




@implementation FCCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont boldSystemFontOfSize:15];
        self.label.textColor = ColorOfHex(0x333333);
        [self addSubview:self.label];
    }
    return self;
}

- (void)updateConstraints
{
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}

- (void)updateFCCellWith:(ValueModel *)model
{
    self.valueModel = model;
    self.label.text = model.key;
    
    [self updateConstraints];
}
@end
