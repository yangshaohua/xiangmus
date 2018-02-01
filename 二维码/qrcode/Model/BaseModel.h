//
//  BaseModel.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/25.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (strong, nonatomic) NSString                *key;
@property (strong, nonatomic) NSString                *value;
@property (strong, nonatomic) UIView                  *view;
@end
