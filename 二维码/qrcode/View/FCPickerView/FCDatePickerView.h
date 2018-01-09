//
//  FCDatePickerView.h
//  MortgageCalculator
//
//  Created by yanli on 2017/12/16.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCDatePickerView : UIView
@property (strong, nonatomic) UIDatePicker    *pickerView;
@property (weak, nonatomic) id                 delegate;

@property (strong, nonatomic) UIButton        *cancelButton;
@property (strong, nonatomic) UIButton        *sureButton;
@property (strong, nonatomic) ValueModel      *currentSelectmodel;
@property (strong, nonatomic) NSMutableArray  *selectList;

- (instancetype)initWithDelegate:(id)delegate selectList:(NSMutableArray *)selectList currentSelectedModel:(ValueModel *)model;

- (void)show;

- (void)dismiss;
@end


@protocol FCFCDatePickerViewDelegate <NSObject>

- (void)didFCFCDatePickerViewSelectDidChangedWithModel:(ValueModel *)model;

@end
