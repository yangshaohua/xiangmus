//
//  SYListCell.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/10.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import "SYListCell.h"
@interface SYListCell ()
@property (strong, nonatomic) UILabel            *titleLabel;
@property (strong, nonatomic) UITextField        *valueTextField;
@property (strong, nonatomic) UILabel            *descLabel;
@property (strong, nonatomic) UIImageView        *descImageView;
@property (strong, nonatomic) UIView             *lineView;
@property (strong, nonatomic) CalculatorModel    *model;
@end

@implementation SYListCell
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = ColorOfHex(0x999999);
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
        
        self.valueTextField = [[UITextField alloc] init];
        self.valueTextField.textAlignment = NSTextAlignmentRight;
        [self.valueTextField addTarget:self action:@selector(keyBoardDown) forControlEvents:UIControlEventEditingDidEndOnExit];
        self.valueTextField.textColor = ColorOfHex(0x333333);
        self.valueTextField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.valueTextField];
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.textColor = ColorOfHex(0x999999);
        self.descLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.descLabel];
        
        self.descImageView = [[UIImageView alloc] init];
        self.descImageView.image = [UIImage imageNamed:@"quanzi_arrow_icon"];
        [self.contentView addSubview:self.descImageView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = ColorOfHex(0xe0e0e0);
        [self.contentView addSubview:self.lineView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)keyBoardDown
{
    
}

- (void)updateConstraints
{
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(titleSize.width);
    }];
    
    [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.bottom.mas_equalTo(self.contentView);
        if ((self.model.modelType == CalculatorModelType_NormalFang) || (self.model.modelType == CalculatorModelType_NormalDai)) {
            make.right.mas_equalTo(self.descLabel.mas_left).mas_offset(-5);
        }else{
            make.right.mas_equalTo(self.descImageView.mas_left).mas_offset(-5);
        }
    }];
    
    CGSize descSize = [self.descLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(descSize.width);
    }];
    
    [self.descImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    self.descImageView = [[UIImageView alloc] init];
    self.descImageView.image = [UIImage imageNamed:@"quanzi_arrow_icon"];
    [self.contentView addSubview:self.descImageView];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(PX_1);
    }];
    
    [super updateConstraints];
}

- (void)updateSYListCellWithCalculatorModel:(CalculatorModel *)model
{
    self.model = model;
    self.titleLabel.text = model.title;
    self.valueTextField.text = model.valueModel.key;
    self.descLabel.text = model.desc;
    
    if (model.modelType == CalculatorModelType_NormalFang || model.modelType == CalculatorModelType_NormalDai) {
        self.descImageView.hidden = YES;
        self.valueTextField.userInteractionEnabled = YES;
    }else{
        self.descImageView.hidden = NO;
        self.valueTextField.userInteractionEnabled = NO;
    }
    
    [self updateConstraints];
}

- (CGFloat)calculatorSYListHeight
{
    return 60;
}

- (void)textFieldDidChanged:(NSNotification *)notification
{
    UITextField *  object = notification.object;
    if ([object isKindOfClass:[UITextField class]] && self.valueTextField == object) {
        self.model.valueModel.value = object.text;
        self.model.valueModel.key = object.text;
        
        if ([self.delegate respondsToSelector:@selector(didSYListCellDidChangedWithModel:andCell:)]) {
            [self.delegate didSYListCellDidChangedWithModel:self.model.valueModel andCell:self];
        }
    }
}
@end





















