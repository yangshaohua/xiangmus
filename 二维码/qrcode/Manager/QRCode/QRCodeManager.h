//
//  QRCodeManager.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/15.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeManager : NSObject
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue;
@end
