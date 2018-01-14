//
//  PhotoManager.h
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/14.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
@interface PhotoManager : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
+ (instancetype)sharedInstance;

- (void)takePhoto;
@end
