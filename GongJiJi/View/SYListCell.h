//
//  SYListCell.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/10.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CalculatorModel.h"
@interface SYListCell : UITableViewCell
@property (weak, nonatomic) id delegate;
- (void)updateSYListCellWithCalculatorModel:(CalculatorModel *)model;
- (CGFloat)calculatorSYListHeight;
@end



@protocol SYListCellDelegate <NSObject>

- (void)didSYListCellDidChangedWithModel:(ValueModel *)model andCell:(SYListCell *)cell;

@end


