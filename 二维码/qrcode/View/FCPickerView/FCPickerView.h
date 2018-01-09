//
//  FCPickerView.h
//  MortgageCalculator
//
//  Created by yanli on 2017/12/16.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#define kFCPickerViewHeight          170
#define kFCPickerTopViewHeight       40
#define kFCPickerPickerViewHeight    130

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FCPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView    *pickerView;
@property (weak, nonatomic) id                 delegate;

@property (strong, nonatomic) UIButton        *cancelButton;
@property (strong, nonatomic) UIButton        *sureButton;

@property (strong, nonatomic) UIView          *customView;
@property (strong, nonatomic) UITextField     *customTextField;
@property (strong, nonatomic) ValueModel      *currentSelectmodel;
@property (strong, nonatomic) NSMutableArray  *selectList;
@property (assign, nonatomic) BOOL             custom;

- (instancetype)initWithDelegate:(id)delegate selectList:(NSMutableArray *)selectList currentSelectedModel:(ValueModel *)model withCustom:(BOOL)custom;

- (void)show;

- (void)dismiss;
@end

@protocol FCPickerViewDelegate <NSObject>

- (void)didFCPickerViewSelectDidChangedWithModel:(ValueModel *)model;

@end


@interface FCCell : UIView
@property (strong, nonatomic) UILabel         *label;
@property (strong, nonatomic) ValueModel      *valueModel;

- (void)updateFCCellWith:(ValueModel *)model;
@end
