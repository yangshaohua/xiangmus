//
//  SNViewController+UploadImage.h
//  RaidersQA
//
//  Created by shaohua6 on 15/8/24.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UploadImage)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//选择图片
- (void)headImageClick;
- (void)photoDidSelectImage:(UIImage *)image imageUrl:(NSURL *)imageUrl;

- (BOOL)isImageAllowEditing;
-(void)takePhoto;
@end
