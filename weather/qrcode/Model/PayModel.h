//
//  PayModel.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2017/12/10.
//  Copyright © 2017年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject
@property (copy, nonatomic) NSString                *yueGong;//月供
@property (copy, nonatomic) NSString                *liXi;//利息
@property (copy, nonatomic) NSString                *benJin;//本金
@property (copy, nonatomic) NSString                *shengYuDaiKuan;//剩余贷款
@end


