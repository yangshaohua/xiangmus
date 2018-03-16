
//
//  ResultCell.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/10.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#define kResultCellRowCount    4
#import "ResultCell.h"
@interface ResultCell ()
@property (strong, nonatomic) UILabel            *qiShuLabel;
@property (strong, nonatomic) UILabel            *yueGongLabel;
@property (strong, nonatomic) UILabel            *benJinLabel;
@property (strong, nonatomic) UILabel            *liXiLabel;
@property (strong, nonatomic) UILabel            *shengYuBenJinLabel;

@property (strong, nonatomic) UIView             *lineView;
@property (strong, nonatomic) PayModel           *model;
@end
@implementation ResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.qiShuLabel = [[UILabel alloc] init];
        self.qiShuLabel.textColor = ColorOfHex(0x333333);
        self.qiShuLabel.textAlignment = NSTextAlignmentCenter;
        self.qiShuLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.qiShuLabel];
        
        self.yueGongLabel = [[UILabel alloc] init];
        self.yueGongLabel.textColor = ColorOfHex(0x333333);
        self.yueGongLabel.textAlignment = NSTextAlignmentCenter;
        self.yueGongLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.yueGongLabel];
        
        self.benJinLabel = [[UILabel alloc] init];
        self.benJinLabel.textAlignment = NSTextAlignmentCenter;
        self.benJinLabel.textColor = ColorOfHex(0x333333);
        self.benJinLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.benJinLabel];
        
        self.liXiLabel = [[UILabel alloc] init];
        self.liXiLabel.textAlignment = NSTextAlignmentCenter;
        self.liXiLabel.textColor = ColorOfHex(0x333333);
        self.liXiLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.liXiLabel];
        
        self.shengYuBenJinLabel = [[UILabel alloc] init];
        self.shengYuBenJinLabel.textAlignment = NSTextAlignmentCenter;
        self.shengYuBenJinLabel.textColor = ColorOfHex(0x333333);
        self.shengYuBenJinLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.shengYuBenJinLabel];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = ColorOfHex(0xe0e0e0);
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)updateConstraints
{
    [self.qiShuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(30);
    }];
    
    [self.yueGongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.qiShuLabel.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo((kScreenSize.width - 50)/kResultCellRowCount);
    }];
    
    [self.benJinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yueGongLabel.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo((kScreenSize.width - 50)/kResultCellRowCount);
    }];
    
    [self.liXiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.benJinLabel.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo((kScreenSize.width - 50)/kResultCellRowCount);
    }];
    
    [self.shengYuBenJinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.liXiLabel.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo((kScreenSize.width - 50)/kResultCellRowCount);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(PX_1);
    }];
    
    [super updateConstraints];
}

- (void)updateSYListCellWithCalculatorModel:(PayModel *)model andIndex:(NSInteger)index
{
    self.model = model;
    self.qiShuLabel.text = [NSString stringWithFormat:@"%ld", index];
    self.yueGongLabel.text = model.yueGong;
    self.benJinLabel.text = model.benJin;
    self.liXiLabel.text = model.liXi;
    self.shengYuBenJinLabel.text = model.shengYuDaiKuan;
    
    [self updateConstraints];
}

- (CGFloat)calculatorSYListHeight
{
    return 60;
}
@end
