//
//  ShareManager.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/16.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject
+ (void)shareWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url;
@end
