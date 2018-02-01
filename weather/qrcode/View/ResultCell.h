//
//  ResultCell.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/10.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ResultCell : UITableViewCell
- (void)updateSYListCellWithCalculatorModel:(PayModel *)model andIndex:(NSInteger)index;
- (CGFloat)calculatorSYListHeight;
@end
