//
//  CreateBaseViewController.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/24.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateResultViewController.h"
@interface CreateBaseViewController : BaseViewController
@property (strong, nonatomic) UIView *contentView;

- (void)createContentView;

- (void)createCreateButton;

- (void)clickCreate;

- (NSString *)getContent;
@end
